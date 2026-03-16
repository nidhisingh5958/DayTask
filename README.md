# DayTask

A Flutter task management app with Supabase authentication and database storage.

## Features

- Email/password sign up, login, and logout via Supabase Auth
- Auth-gated navigation (unauthenticated users stay on login flow)
- Dashboard with task list from Supabase
- Add and delete tasks
- Optional task status toggle (pending/completed)
- Riverpod state management
- Responsive dark UI inspired by the provided Figma style
- Basic animations (screen entrance, auth/dashboard switch, task item transitions)

## Tech Stack

- Flutter 3.38+
- supabase_flutter
- flutter_riverpod
- google_fonts

## Folder Structure

```text
lib/
├── main.dart
├── app/
│   ├── app_gate.dart
│   └── theme.dart
├── auth/
│   ├── auth_controller.dart
│   ├── auth_service.dart
│   ├── login_screen.dart
│   └── signup_screen.dart
├── dashboard/
│   ├── dashboard_screen.dart
│   ├── task_controller.dart
│   ├── task_model.dart
│   ├── task_service.dart
│   └── task_tile.dart
├── services/
│   └── supabase_service.dart
└── utils/
		└── validators.dart
```

## Supabase Setup

1. Create a Supabase project.
2. Create a `tasks` table:

```sql
create table if not exists public.tasks (
	id uuid primary key default gen_random_uuid(),
	user_id uuid not null references auth.users(id) on delete cascade,
	title text not null,
	is_completed boolean not null default false,
	created_at timestamptz not null default now()
);

alter table public.tasks enable row level security;

create policy "Users can view own tasks"
on public.tasks for select
using (auth.uid() = user_id);

create policy "Users can insert own tasks"
on public.tasks for insert
with check (auth.uid() = user_id);

create policy "Users can update own tasks"
on public.tasks for update
using (auth.uid() = user_id);

create policy "Users can delete own tasks"
on public.tasks for delete
using (auth.uid() = user_id);
```

3. Run the app with Supabase keys:

```bash
flutter run \
	--dart-define=SUPABASE_URL=YOUR_SUPABASE_URL \
	--dart-define=SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

## Commands

```bash
flutter pub get
flutter analyze
flutter test
```

## Hot Reload vs Hot Restart

- Hot Reload: Injects updated source code into the running app while preserving current state. Use for fast UI iteration.
- Hot Restart: Rebuilds the app from scratch and resets state. Use when initialization logic or top-level state changes.

## Notes

- If Supabase keys are not provided, the app shows a setup message screen.
- Real-time updates are not enabled by default (fetch-on-demand approach).
