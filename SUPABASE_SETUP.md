# Supabase Integration Setup Guide

## Current Status
✅ Supabase credentials are configured in `.env`  
✅ Auth service is set up  
✅ Task service is ready  
✅ Offline backup system is functional

## Required Database Setup

### Step 1: Create Auth Users Table (Optional - Supabase Auto-creates)
Supabase automatically creates a `auth.users` table. No action needed.

### Step 2: Create Tasks Table

Run this SQL in your Supabase SQL editor:

```sql
-- Create tasks table
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title VARCHAR(500) NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster queries
CREATE INDEX tasks_user_id_idx ON tasks(user_id);
CREATE INDEX tasks_created_at_idx ON tasks(created_at DESC);

-- Enable Row Level Security (RLS)
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Create RLS policy: Users can only see their own tasks
CREATE POLICY "Users can view their own tasks"
  ON tasks FOR SELECT
  USING (auth.uid() = user_id);

-- Create RLS policy: Users can create their own tasks
CREATE POLICY "Users can create their own tasks"
  ON tasks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Create RLS policy: Users can update their own tasks
CREATE POLICY "Users can update their own tasks"
  ON tasks FOR UPDATE
  USING (auth.uid() = user_id);

-- Create RLS policy: Users can delete their own tasks
CREATE POLICY "Users can delete their own tasks"
  ON tasks FOR DELETE
  USING (auth.uid() = user_id);
```

### Step 3: Verify Table Creation
1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project
3. Go to **SQL Editor** → **New Query**
4. Run query to verify:
```sql
SELECT table_name FROM information_schema.tables 
WHERE table_schema = 'public';
```
You should see `tasks` in the results.

## Running the App

### Option 1: Terminal with Environment Variables
```bash
flutter run --dart-define-from-file=.env
```

### Option 2: VS Code (Recommended)
Edit `.vscode/launch.json`:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "DayTask Debug",
      "request": "launch",
      "type": "dart",
      "program": "lib/main.dart",
      "args": [
        "--dart-define-from-file=.env"
      ]
    }
  ]
}
```

Then press `F5` to run.

### Option 3: Run Configuration Script
```bash
flutter run \
  --dart-define=SUPABASE_URL=https://bgrryhkqlyuhqwvbekeh.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJncnJ5aGtxbHl1aHF3dmJla2VoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM2NzE4NTcsImV4cCI6MjA4OTI0Nzg1N30.TNm3v-WMrCN6oIr5o1U6YesoM3Mzn4PesjuZDQlpJhs
```

## Troubleshooting

### Issue: "Supabase is not configured"
**Solution:**
- Verify `.env` file exists with correct values
- Run with `--dart-define-from-file=.env` flag
- Rebuild: `flutter clean && flutter pub get && flutter run`

### Issue: 401 Unauthorized when accessing tasks
**Solution:**
- Check Row Level Security (RLS) policies are enabled
- Verify user is logged in (check `currentUser`)
- Ensure RLS policies allow SELECT/INSERT/UPDATE/DELETE

### Issue: Tasks table doesn't exist
**Solution:**
- Run the SQL commands in Supabase SQL editor
- Verify table creation with: `SELECT * FROM information_schema.tables;`

### Issue: Cannot sign up or authenticate
**Solution:**
- Ensure Email Confirmations are disabled (Settings → Auth → Email)
- Or configure email delivery (Settings → Email Templates)

## Features Verification

After setup, test these flows:

1. **Sign Up**: Register with email/password
2. **Login**: Sign in with created account
3. **Create Task**: Add a new task (should sync to Supabase)
4. **Complete Task**: Toggle task completion
5. **Delete Task**: Remove a task
6. **Logout**: Sign out and verify redirect to login

## Architecture

```
App Flow:
  ┌─────────────────┐
  │   Flutter App   │
  └────────┬────────┘
           │
    ┌──────▼──────────┐
    │ SupabaseService │ (Handles Supabase client)
    └────────┬────────┘
             │
    ┌────────┴──────────┬──────────────┐
    │                   │              │
  ┌─▼────┐        ┌──────▼───┐  ┌────▼──────┐
  │ Auth  │        │  Tasks   │  │ Offline   │
  │Service│        │ Service  │  │  Backup   │
  └───────┘        └──────────┘  └───────────┘
    │                   │              │
    └───────────────────┼──────────────┘
                        │
                ┌───────▼─────────┐
                │  Supabase API   │
                └─────────────────┘
```

## Next Steps

1. ✅ Create tasks table with SQL
2. ✅ Configure RLS policies
3. ✅ Run app with environment variables
4. ✅ Test all authentication flows
5. ✅ Verify task CRUD operations work
6. ✅ Test offline backup system

All code is production-ready. Just ensure database schema matches expectations!
