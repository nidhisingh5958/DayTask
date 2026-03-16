# Supabase Setup

## Runtime Configuration

The app reads credentials from compile-time defines in `lib/services/supabase_service.dart`:

- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

If either value is missing, Supabase is not initialized and the app shows a setup message.

## SQL Schema

Run the following in Supabase SQL editor:

```sql
create extension if not exists pgcrypto;

create table if not exists public.tasks (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  is_completed boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
```

## Row Level Security

```sql
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

## Authentication

The app uses Supabase email/password auth via methods in `lib/auth/auth_service.dart`:

- `signUp(email, password)`
- `signIn(email, password)`
- `signOut()`

Auth state stream from Supabase drives route gating in `lib/app/app_gate.dart`.
