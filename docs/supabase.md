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

## Optional Chat + Notification Schema

Run this if you want the Messages and Notifications screens to use live backend data.

```sql
create table if not exists public.chat_threads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  last_message text,
  time_label text,
  avatar_initials text default 'NA',
  avatar_color integer default 12379855,
  is_group boolean not null default false,
  updated_at timestamptz not null default now()
);

create table if not exists public.chat_messages (
  id uuid primary key default gen_random_uuid(),
  thread_id uuid not null references public.chat_threads(id) on delete cascade,
  sender_id uuid references auth.users(id) on delete set null,
  content text not null,
  is_seen boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  action text not null,
  task text not null,
  time_label text,
  avatar_initials text default 'NA',
  avatar_color integer default 12379855,
  is_new boolean not null default true,
  created_at timestamptz not null default now()
);
```

Enable RLS and policies:

```sql
alter table public.chat_threads enable row level security;
alter table public.chat_messages enable row level security;
alter table public.notifications enable row level security;

create policy "Users can read own chat threads"
on public.chat_threads for select
using (auth.uid() = user_id);

create policy "Users can insert own chat threads"
on public.chat_threads for insert
with check (auth.uid() = user_id);

create policy "Users can update own chat threads"
on public.chat_threads for update
using (auth.uid() = user_id);

create policy "Users can read messages in own threads"
on public.chat_messages for select
using (
  exists (
    select 1
    from public.chat_threads t
    where t.id = thread_id and t.user_id = auth.uid()
  )
);

create policy "Users can insert messages in own threads"
on public.chat_messages for insert
with check (
  exists (
    select 1
    from public.chat_threads t
    where t.id = thread_id and t.user_id = auth.uid()
  )
);

create policy "Users can read own notifications"
on public.notifications for select
using (auth.uid() = user_id);

create policy "Users can insert own notifications"
on public.notifications for insert
with check (auth.uid() = user_id);
```

## Authentication

The app uses Supabase email/password auth via methods in `lib/auth/auth_service.dart`:

- `signUp(email, password)`
- `signIn(email, password)`
- `signOut()`

Auth state stream from Supabase drives route gating in `lib/app/app_gate.dart`.
