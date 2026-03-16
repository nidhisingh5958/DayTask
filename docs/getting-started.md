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

1. Create a local env file from the template:

```bash
cp .env.example .env
```

2. Fill in `.env` with your real Supabase credentials.

3. Run the app using the env file:

```bash
flutter run --dart-define-from-file=.env
```

Fallback (direct runtime defines):

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
