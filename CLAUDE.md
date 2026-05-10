# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run code generation (required after modifying Hive models)
dart run build_runner build --delete-conflicting-outputs

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Build
flutter build apk
flutter build ios

# Regenerate launcher icons (after changing assets/icons/)
dart run flutter_launcher_icons
```

> Hive adapter `.g.dart` files are generated — never edit them manually. Re-run `build_runner` after changing any `@HiveType` / `@HiveField` annotated class.

## Architecture

Feature-based structure with a 3-layer pattern inside each feature:

```
lib/
├── core/              # Shared across all features
│   ├── constants/     # App-wide constants and damage models
│   ├── providers/     # Firebase & analytics Riverpod providers
│   ├── router/        # GoRouter config and route constants (AppRouter)
│   ├── services/      # Analytics, Crashlytics wrappers
│   ├── theme/         # Design tokens: colors, text styles, spacing
│   ├── utils/         # Formatters, error translation helpers
│   └── widgets/       # Reusable UI (LunoCard, StatCard, CigeritoBubble)
├── features/          # Self-contained feature modules
│   ├── auth/          # Google, Apple, Email sign-in
│   ├── onboarding/    # Duolingo-style mascot onboarding flow
│   ├── main/          # Dashboard with real-time quit stats
│   ├── damage/        # Organ damage analysis and timeline
│   ├── diary/         # Craving/slip logging, calendar, history
│   ├── crisis/        # Crisis mode support
│   └── settings/      # Theme toggle, account settings
└── services/
    └── local_storage/ # HiveService — local persistence
```

Each feature contains:
- `data/` — Models, repositories, Firestore integration
- `application/` — Business logic, Riverpod providers, calculators
- `presentation/` — Screens, pages, widgets, controllers

## State Management

**Riverpod** is used throughout. Key providers:
- `statsProvider` (StreamProvider) — real-time dashboard quit statistics
- `userProfileProvider` — user profile data
- `historyLogsProvider` — daily craving/slip logs stream

Business logic lives in `application/` layer (e.g., `QuitCalculator` in `features/main/application/quit_calculator.dart` computes money saved, time lost, organ recovery).

## Routing

GoRouter with a stateful shell for the 5-tab bottom nav (Home, Damage, Crisis, History, Settings). Auth guards in `app_router.dart` handle: splash → onboarding → auth → main flow. Route name constants are defined in the `AppRouter` class.

## Data Persistence

- **Hive** — local storage for `UserProfile` and `DailyLogs` boxes; initialized in `main.dart`
- **Firestore** — remote sync of profile and logs via repository pattern

## UI Conventions

- App locale is hardcoded to `tr_TR` (Turkish)
- Light/dark theme is toggled by the user and persisted via Hive
- Design tokens (colors, spacing, text styles) are in `core/theme/` — use these instead of hardcoded values
- Mascot character "Cigerito" appears via `CigeritoBubble` / `SpeechBubble` widgets across screens
