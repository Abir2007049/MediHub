# medihub

medihub — Flutter mobile application.

This README explains how to clone, configure, and run the project locally.

## Prerequisites

- Install Flutter (stable channel). Verify with `flutter --version`.
- Install Git: `git --version`.
- For Android builds: Android Studio (Android SDK + emulator) and JDK.
- For iOS builds (macOS only): Xcode and command line tools.

## Clone

1. Clone the repository:

```bash
git clone https://github.com/Abir2007049/MediHub.git
cd MediHub
```

1. (Optional) Switch to the branch used by this workspace:

```bash
git checkout rayat/supabase
```

## Project configuration

This project expects a `.env` file at the project root with runtime keys used by the app. Create a `.env` file with at least the following keys:

```bash
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_KEY=your-supabase-key
```

Make sure to keep secret keys out of version control.

## Install dependencies

Run:

```bash
flutter pub get
```

## Code generation

If you change models or annotations (Freezed / JsonSerializable / other generators), run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

If you encounter generator conflicts, the command above will remove conflicting generated files.

## Run the app

-- Start an emulator or connect a device, then run:

```bash
flutter run
```

-- Build a release APK (example):

```bash
flutter build apk --release
```

-- Example advanced build with obfuscation (optional):

```bash
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
```

## Tests & analysis

-- Run static analysis:

```bash
flutter analyze
```

-- Run tests:

```bash
flutter test --coverage
```

## Troubleshooting

- If Flutter reports missing licenses for Android: `flutter doctor --android-licenses`.
- If code generation fails, re-run the build_runner command above.
- If environment values are missing, ensure the `.env` file exists in the project root.

## Useful files

- Entry point: [lib/main.dart](lib/main.dart)
- Dependency injection: [lib/core/di/service_locator.dart](lib/core/di/service_locator.dart)
- App routing: [lib/core/router/app_router.dart](lib/core/router/app_router.dart)

## Agent skills (optional)

This project may use AI/agent skills. To quickly add the `flutter/skills` collection using the `skills` CLI via `npx`, run:

```bash
npx skills add flutter/skills
```

## Contributing

If you'd like help getting set up, or want me to run tests/format or create a `.env.example`, tell me and I can add it.

---

Happy hacking!
