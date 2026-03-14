# Project Guidelines

## Code Style

- Follow Flutter and Dart lints from analysis_options.yaml.
- Prefer package imports with package:medihub/... for cross-feature references.
- Keep UI widgets generic and reusable. Prefer shared widgets in lib/core/widgets when already used by a flow, and avoid feature-specific duplicate wrappers.
- For simple UI additions, use standard Flutter Material widgets unless a shared core widget is required for consistency.

## Architecture

- Keep the feature-first structure under lib/features/{feature}/presentation and lib/features/{feature}/data.
- Use Cubit for state and GetIt for dependency wiring.
- When adding a new Cubit or repository:
  - Register it in lib/core/di/service_locator.dart.
  - Add its provider in lib/main.dart if it must be available app-wide.
- Keep route changes centralized in lib/core/router/app_router.dart and preserve auth redirect behavior.
- Keep shared domain models in lib/models with Freezed and JSON serialization.

## Build And Test

- Install dependencies: flutter pub get
- Generate code after model/env annotation changes: dart run build_runner build --delete-conflicting-outputs
- Analyze: flutter analyze
- Run tests: flutter test --coverage
- Run app locally: flutter run

## Environment

- A .env file is required for runtime and codegen paths that depend on Env values.
- Required keys:
  - SUPABASE_URL
  - SUPABASE_KEY

## Conventions And Pitfalls

- Do not edit generated files directly:
  - lib/models/\*.g.dart
  - lib/models/\*.freezed.dart
- Use source code as the source of truth when docs differ. Medicine docs mention RxNorm in some markdown files, but active implementation is in lib/features/prescription/data/services/medicine_test_service.dart.
- Prefer package:medihub imports instead of deep relative imports to avoid breakage during file moves.
- Current tests are lightweight smoke coverage; add targeted tests when changing Cubit logic, repositories, routing, or serialization behavior.

## Key Reference Files

- lib/main.dart
- lib/core/di/service_locator.dart
- lib/core/router/app_router.dart
- lib/core/theme/app_theme.dart
- lib/models/env.dart
- .github/workflows/main.yaml
