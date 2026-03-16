# Getting Started

## Prerequisites

- Flutter SDK 3.38+
- Dart SDK 3.10+
- A Supabase project with an anon key

## Install Dependencies

```bash
flutter pub get
```

## Run the App

Use runtime defines for Supabase:

```bash
flutter run \
  --dart-define=SUPABASE_URL=YOUR_SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

## Verify Build Health

```bash
flutter analyze
flutter test
```

## Build Targets

The project was scaffolded with Android, iOS, and Web support.

## Development Notes

- Hot reload keeps state and is best for UI iteration.
- Hot restart resets app state and is useful after initialization changes.
