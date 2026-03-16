# Architecture

## High-Level Design

The app is organized with feature-first folders and a thin service layer.

- UI screens and widgets live in feature folders (`auth`, `dashboard`)
- Supabase integration is isolated in service classes
- Riverpod providers/controllers coordinate async state and UI updates

## Folder Structure

```text
lib/
  main.dart
  app/
    app_gate.dart
    theme.dart
  auth/
    auth_controller.dart
    auth_service.dart
    login_screen.dart
    signup_screen.dart
  dashboard/
    dashboard_screen.dart
    task_controller.dart
    task_model.dart
    task_service.dart
    task_tile.dart
  services/
    supabase_service.dart
  utils/
    validators.dart
```

## State Management

Riverpod is used for dependency injection and state:

- `authServiceProvider`: auth service instance
- `authStateProvider`: stream of Supabase auth state
- `currentUserProvider`: current user accessor
- `taskControllerProvider`: `StateNotifier` with `AsyncValue<List<TaskModel>>`

## Navigation and Route Guard

`AppGate` is the route gate:

- If Supabase is not configured -> config guidance screen
- If auth stream has no session -> login screen
- If session exists -> dashboard screen

## Data Flow

1. UI triggers controller action (`addTask`, `deleteTask`, `toggleTask`)
2. Controller calls `TaskService`
3. `TaskService` executes Supabase query
4. Controller refreshes state via `loadTasks()`
5. UI rebuilds from `AsyncValue`
