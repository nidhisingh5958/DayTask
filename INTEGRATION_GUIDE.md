# Supabase Integration - Step-by-Step Implementation Guide

## Overview
Your DayTask app is ready to integrate with Supabase. The code is complete; you just need to:
1. Create the database table
2. Configure authentication
3. Run the app with environment variables

---

## Step 1: Set Up Supabase Database

### 1.1 Access Supabase Console
```
1. Go to: https://supabase.com/dashboard
2. Sign in with your credentials
3. Select project: bgrryhkqlyuhqwvbekeh (or your project ID)
```

### 1.2 Create Tasks Table
```
1. Click SQL Editor (left sidebar)
2. Click "+ New Query"
3. Copy this entire SQL block:
```

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

-- Create indexes for performance
CREATE INDEX tasks_user_id_idx ON tasks(user_id);
CREATE INDEX tasks_created_at_idx ON tasks(created_at DESC);

-- Enable Row Level Security
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Users can only view their own tasks
CREATE POLICY "Users can view their own tasks"
  ON tasks FOR SELECT
  USING (auth.uid() = user_id);

-- RLS Policy: Users can create their own tasks
CREATE POLICY "Users can create their own tasks"
  ON tasks FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- RLS Policy: Users can update their own tasks
CREATE POLICY "Users can update their own tasks"
  ON tasks FOR UPDATE
  USING (auth.uid() = user_id);

-- RLS Policy: Users can delete their own tasks
CREATE POLICY "Users can delete their own tasks"
  ON tasks FOR DELETE
  USING (auth.uid() = user_id);
```

```
4. Click "Run" button (Ctrl+Enter)
5. Check for "Success" message
6. Go to Table Editor (left sidebar) → you should see "tasks" table
```

### 1.3 Verify Table Creation
```
1. In Supabase, click "Table Editor"
2. Click "tasks" in the left sidebar
3. You should see empty table with columns:
   - id (UUID)
   - user_id (UUID)
   - title (text)
   - is_completed (boolean)
   - created_at (timestamp)
   - updated_at (timestamp)
```

---

## Step 2: Configure Authentication

### 2.1 Email Settings (for testing)
```
1. Go to Settings → Auth (left sidebar)
2. Scroll down to "Email Confirmations"
3. Toggle OFF "Enable email confirmations"
   (This allows instant signup for testing)
```

### 2.2 (Optional) Enable Google OAuth
```
1. In Auth settings, click "Providers" tab
2. Find "Google" and click it
3. Enable Google OAuth:
   - Enabled: ON
   - Client ID: Add your Google OAuth credentials
   - Client Secret: Add your Google secret
4. Set Redirect URL: io.supabase.daytask://login-callback/
```

---

## Step 3: Run the App

### Option A: Terminal (Recommended for first run)

```bash
# Navigate to project
cd /Volumes/DevSSD/Developer/DayTask

# Run with environment variables from .env
flutter run --dart-define-from-file=.env
```

Expected output:
```
Launching lib/main.dart on ...
Running Gradle task 'assembleDebug'...
✓ Built build/app/outputs/flutter-app-debug.apk
Installing and launching...
```

### Option B: VS Code (for development)

```
1. Open the project in VS Code
2. Open .vscode/launch.json
3. Add this configuration:
```

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter Debug",
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

```
4. Press F5 to run
5. App should launch in simulator/device
```

### Option C: Terminal (Direct Command)

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://bgrryhkqlyuhqwvbekeh.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJncnJ5aGtxbHl1aHF3dmJla2VoIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzM2NzE4NTcsImV4cCI6MjA4OTI0Nzg1N30.TNm3v-WMrCN6oIr5o1U6YesoM3Mzn4PesjuZDQlpJhs
```

---

## Step 4: Test the Integration

### 4.1 Sign Up Flow
```
1. App opens with splash screen (auto-advances in 4 seconds)
2. Click "Let's Start" or wait for auto-advance
3. On Login screen, click "Create account"
4. Fill signup form:
   - Full Name: Test User
   - Email: test@example.com
   - Password: TestPassword123!
5. Click "Sign Up"
6. Should automatically redirect to Dashboard
```

### 4.2 Verify User Created
```
1. In Supabase, go to Settings → Auth
2. Click "Users" tab
3. You should see "test@example.com" listed
```

### 4.3 Create Task Flow
```
1. In Dashboard, click "+" (bottom center)
2. Fill task form:
   - Task Title: "First Supabase Task"
   - Details: "Testing integration"
3. Click "Create"
4. Task should appear in ongoing tasks list
5. Check Supabase:
   - Go to Table Editor → tasks
   - You should see your task with user_id matching created user
```

### 4.4 Test Task Management
```
1. Click task to view details
2. Toggle completion status → should update immediately
3. Swipe or click delete → task should disappear
4. Refresh Supabase table to verify deletions
```

### 4.5 Test Offline Backup
```
1. Go to Profile (click user avatar)
2. Scroll down to "Create Offline Backup"
3. Click "Create Offline Backup"
4. Should show: "Offline backup created: task-backup-..."
5. Click "Restore Latest Backup"
6. Should show: "Restored X tasks from offline backup"
```

---

## Step 5: Troubleshooting

### Problem: "Supabase is not configured"

**Solution:**
```bash
# Make sure running with .env
flutter run --dart-define-from-file=.env

# Or rebuild
flutter clean
flutter pub get
flutter run --dart-define-from-file=.env
```

### Problem: 401 Unauthorized when creating tasks

**Solution:**
1. Verify RLS policies are correctly set up:
   - Go to Table Editor → tasks → Policies (tab)
   - Check all 4 policies are listed
   
2. Simplify RLS temporarily (for testing):
```sql
-- Disable RLS temporarily
ALTER TABLE tasks DISABLE ROW LEVEL SECURITY;
```

3. After testing, re-enable:
```sql
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
```

### Problem: Tasks don't appear after refresh

**Solution:**
1. Check network connection
2. Verify RLS policies include SELECT
3. Check Supabase logs: Logs → Auth or Database

### Problem: Authentication fails

**Solution:**
1. Go to Settings → Auth → Email Confirmations
2. Make sure "Require email confirmation" is OFF
3. Try signing up with valid email format

---

## Project Structure Review

```
lib/
├── main.dart                          # App entry point
├── app/
│   ├── app_gate.dart                 # Auth router
│   ├── theme.dart                    # UI theme
│   └── splash_screen.dart            # 4-second auto-advance splash
├── auth/
│   ├── auth_service.dart             # Supabase Auth methods
│   ├── auth_controller.dart          # Riverpod state
│   ├── login_screen.dart             # Sign in UI
│   └── signup_screen.dart            # Sign up UI
├── dashboard/
│   ├── task_service.dart             # Supabase CRUD ops
│   ├── task_controller.dart          # Riverpod state (loads tasks)
│   ├── task_model.dart               # Task data model
│   ├── dashboard_screen.dart         # Main dashboard UI
│   ├── task_tile.dart                # Task item widget
│   ├── secondary_screens.dart        # Profile, messages, etc.
│   └── task_details_screen.dart      # Task detail view
├── services/
│   ├── supabase_service.dart         # Supabase client initialization
│   └── offline_backup_service.dart   # Local JSON backup/restore
└── utils/
    └── validators.dart               # Email/password validation
```

---

## What's Already Ready

✅ **Functionality Complete:**
- User authentication (sign up, login, logout)
- Task CRUD (Create, Read, Update, Delete)
- Offline backup (local JSON export/import)
- Auto-sync with Supabase
- RLS privacy policies
- Error handling

✅ **UI/UX Complete:**
- Modern dark theme
- Smooth animations
- Responsive layout
- Offline backup buttons in Profile
- 4-second auto-advance splash screen

✅ **Environment Setup:**
- `.env` file with Supabase credentials
- Automatic env variable loading
- Error feedback for missing config

---

## Summary

```
✓ Code is production-ready
✓ Just need to:
  1. Create tasks table in Supabase
  2. Disable email confirmations (optional)
  3. Run: flutter run --dart-define-from-file=.env
  4. Test signup → create task → verify in Supabase
```

Good luck! 🚀
