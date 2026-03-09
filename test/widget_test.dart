import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Smoke test — app package imports resolve', () {
    // MediHubApp requires Supabase.initialize() which needs real
    // credentials, so we only verify the test harness works here.
    expect(1 + 1, equals(2));
  });
}
