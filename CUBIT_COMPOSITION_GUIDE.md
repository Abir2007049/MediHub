## Composing Cubits in Flutter BLoC

There are a few patterns for this, depending on your use case:

---

### Pattern 1: Cubit B listens to Cubit A via Stream subscription

The cleanest approach — Cubit B subscribes to Cubit A's stream in its constructor.

```dart
class CubitA extends Cubit<int> {
  CubitA() : super(0);

  void increment() => emit(state + 1);
}

class CubitB extends Cubit<String> {
  final CubitA _cubitA;
  late final StreamSubscription _subscription;

  CubitB(this._cubitA) : super('Value: 0') {
    _subscription = _cubitA.stream.listen((aState) {
      emit('Value: $aState'); // react to A's state changes
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel(); // always cancel!
    return super.close();
  }
}
```

**Key point:** Always cancel the subscription in `close()` to avoid memory leaks.

---

### Pattern 2: Inject Cubit A and read its state on demand

If Cubit B only needs A's *current* state occasionally (not reactively), just read `cubitA.state` directly:

```dart
class CubitB extends Cubit<String> {
  final CubitA _cubitA;

  CubitB(this._cubitA) : super('');

  void doSomething() {
    final aValue = _cubitA.state; // read on demand
    emit('Computed from: $aValue');
  }
}
```

---

### Pattern 3: BlocListener in the UI layer (no direct coupling)

If you want to keep cubits decoupled, react in the widget tree instead:

```dart
BlocListener<CubitA, int>(
  listener: (context, aState) {
    // Drive Cubit B from the UI when A changes
    context.read<CubitB>().onAChanged(aState);
  },
  child: YourWidget(),
)
```

Then in Cubit B:

```dart
class CubitB extends Cubit<String> {
  CubitB() : super('');

  void onAChanged(int aValue) {
    emit('Reacting to: $aValue');
  }
}
```

---

### Pattern 4: Shared repository as the single source of truth

The most scalable pattern — both cubits depend on a shared `Repository`, not on each other:

```dart
class CounterRepository {
  final _controller = StreamController<int>.broadcast();
  Stream<int> get stream => _controller.stream;
  int _value = 0;

  void increment() {
    _value++;
    _controller.add(_value);
  }
}

class CubitA extends Cubit<int> {
  final CounterRepository _repo;
  CubitA(this._repo) : super(0) {
    _repo.stream.listen(emit);
  }
  void increment() => _repo.increment();
}

class CubitB extends Cubit<String> {
  final CounterRepository _repo;
  late final StreamSubscription _sub;
  CubitB(this._repo) : super('') {
    _sub = _repo.stream.listen((v) => emit('Value is $v'));
  }
  @override
  Future<void> close() { _sub.cancel(); return super.close(); }
}
```

---

### Which pattern to use?

| Situation | Pattern |
|---|---|
| B needs to react *reactively* to A | Stream subscription (Pattern 1) |
| B only reads A occasionally | Inject & read state (Pattern 2) |
| Keep cubits fully decoupled | BlocListener in UI (Pattern 3) |
| Multiple cubits share the same data | Shared repository (Pattern 4) |

**Pattern 4 is generally recommended** for larger apps — it avoids tight coupling between cubits and keeps your business logic in the repository layer where it belongs.
