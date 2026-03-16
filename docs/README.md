# DayTask Documentation

This folder contains complete technical documentation for the DayTask Flutter application.

## Document Index

- `getting-started.md`: local setup, install steps, and run commands
- `supabase.md`: database schema, RLS policies, and auth/runtime configuration
- `architecture.md`: project structure, modules, and state management design
- `feature-flows.md`: authentication and task-management user flows
- `testing.md`: test strategy, commands, and current coverage
- `troubleshooting.md`: common setup/runtime issues and fixes

## Quick Start

1. Read `getting-started.md`
2. Complete Supabase setup from `supabase.md`
3. Run the app with `--dart-define` values
4. Validate with `flutter analyze` and `flutter test`

## Scope Implemented

- Flutter app with auth and dashboard flow
- Supabase email/password authentication
- Task create/read/update/delete against Supabase table
- Riverpod-based state management
- Responsive dark UI and basic animations
- Basic model serialization test

## Notes

- Real-time subscriptions are not enabled; data is fetched on demand.
- If Supabase env values are missing, the app shows a configuration guidance screen.
