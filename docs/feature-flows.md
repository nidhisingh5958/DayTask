# Feature Flows

## Authentication Flow

1. App starts and initializes Supabase in `main.dart`
2. `AppGate` watches `authStateProvider`
3. User sees login screen when no active session
4. User can navigate to sign-up and create an account
5. Successful sign-in updates session stream
6. `AppGate` animates transition to dashboard
7. Logout clears session and returns user to login

## Dashboard Flow

1. Dashboard watches `taskControllerProvider`
2. Controller loads tasks for current user from Supabase
3. UI shows loading, error, empty, or list states

## Add Task Flow

1. User taps `Add Task`
2. Bottom sheet opens and accepts task title
3. Controller `addTask()` inserts into Supabase
4. Controller reloads and UI shows updated task list

## Delete Task Flow

1. User swipes task row or taps delete icon
2. Controller `deleteTask()` removes row in Supabase
3. Controller reloads and UI updates

## Toggle Completion Flow

1. User toggles switch on task tile
2. Controller `toggleTask()` updates `is_completed`
3. Controller reloads and UI reflects pending/completed state
