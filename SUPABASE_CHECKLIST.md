# Supabase Integration Checklist

## ✅ Pre-Setup Verification

- [x] Flutter SDK installed: `flutter --version`
- [x] Supabase credentials in `.env`
- [x] All dependencies installed: `flutter pub get`
- [x] Code compiles: `flutter analyze` (No errors)

## 🏗️ Database Schema Setup

### Tasks Table
- [ ] Log in to [Supabase Console](https://supabase.com/dashboard)
- [ ] Copy this SQL into **SQL Editor**:

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

-- Create indexes
CREATE INDEX tasks_user_id_idx ON tasks(user_id);
CREATE INDEX tasks_created_at_idx ON tasks(created_at DESC);

-- Enable RLS
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Users can view their own tasks" ON tasks FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create their own tasks" ON tasks FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own tasks" ON tasks FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own tasks" ON tasks FOR DELETE USING (auth.uid() = user_id);
```

- [ ] Execute the SQL (click "Run" or Ctrl+Enter)
- [ ] Verify `tasks` table appears in **Table Editor**

## 🔐 Authentication Settings

- [ ] Go to **Settings** → **Auth**
- [ ] Find **Email Confirmations** → Set to **Disabled** (for testing)
- [ ] Enable **Google OAuth** (if needed):
  - [ ] Add Google credentials
  - [ ] Set redirect URL: `io.supabase.daytask://login-callback/`

## ▶️ Running the App

### Terminal Method
```bash
cd /Volumes/DevSSD/Developer/DayTask
flutter run --dart-define-from-file=.env
```

### VS Code Method
- [ ] Open Run and Debug (Ctrl+Shift+D)
- [ ] Click "Create a launch.json file"
- [ ] Use this configuration:

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

- [ ] Press F5 to run

## 🧪 Testing Flows

### 1. Authentication
- [ ] **Sign Up**: Create new account with test email
  - Email: `test@example.com`
  - Password: `TestPassword123!`
- [ ] Verify user appears in **Authentication** → **Users** in Supabase
- [ ] **Login**: Sign out and sign back in
- [ ] **Logout**: Navigate back to login screen

### 2. Tasks CRUD
- [ ] **Create**: Add task "Test Task" - should appear instantly
- [ ] **View**: Task appears in dashboard immediately
- [ ] **Update**: Toggle completion status
- [ ] **Delete**: Remove task, verify it disappears
- [ ] Check Supabase console: **Table Editor** → **tasks** should show data

### 3. Real-time Sync
- [ ] Open app in Simulator
- [ ] Open Supabase console in browser (same project)
- [ ] Create task in app → Check it appears in Supabase
- [ ] Delete task from Supabase console → Check app reflects change*

*Note: Real-time requires RealtimeClient setup (optional enhancement)

### 4. Offline Features
- [ ] **Create Backup**: Go to Profile → "Create Offline Backup"
  - Should show: "Offline backup created: task-backup-..."
- [ ] **Restore Backup**: Click "Restore Latest Backup"
  - Should show: "Restored X tasks from offline backup"

## 🐛 Debugging

If issues occur, check these logs:

### Check Connection
```dart
// In main.dart or splash screen, temporarily add:
print('Supabase configured: ${SupabaseService.isConfigured}');
print('Current user: ${SupabaseService.client.auth.currentUser?.email}');
```

### Check Environment Variables
```bash
# Run and check console output:
flutter run -v --dart-define-from-file=.env 2>&1 | grep SUPABASE
```

### Database Access
```sql
-- In Supabase SQL Editor:
SELECT COUNT(*) FROM tasks;
SELECT * FROM auth.users LIMIT 5;
```

## 🚀 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| "Supabase is not configured" | Run with `--dart-define-from-file=.env` |
| Tasks not syncing | Verify RLS policies are enabled |
| 401 Unauthorized | Check user is logged in (`currentUser` not null) |
| Tasks table doesn't exist | Run SQL script in Supabase console |
| Email confirmation loop | Disable "Email Confirmations" in Auth settings |
| App crashes on startup | Run `flutter clean && flutter pub get` |

## 📱 Platform-Specific Notes

### iOS
- [ ] Update URL Scheme in `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>io.supabase.daytask</string>
    </array>
  </dict>
</array>
```

### Android
- [ ] Update `android/app/build.gradle` URL scheme:
```gradle
manifestPlaceholders = [
    "auth_scheme": "io.supabase.daytask"
]
```

### Web
- [ ] Add redirect URL in Supabase console: `http://localhost:5000`

## ✨ Verification Checklist

After completing all steps, verify:

- [ ] User can create account
- [ ] User can log in
- [ ] New tasks sync to Supabase
- [ ] Tasks load on app restart
- [ ] Offline backup works
- [ ] All CRUD operations work
- [ ] No console errors
- [ ] Navigation flows smoothly

---

**Status**: Ready for production after all checks pass ✅
