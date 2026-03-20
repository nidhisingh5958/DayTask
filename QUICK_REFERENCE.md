# Supabase Integration - Quick Reference

## 🚀 Get Started in 5 Minutes

### Step 1: Create Database Table (2 min)
Go to [Supabase Console](https://supabase.com/dashboard) → SQL Editor → New Query

**Copy & paste this SQL:**
```sql
CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  title VARCHAR(500) NOT NULL,
  is_completed BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX tasks_user_id_idx ON tasks(user_id);
CREATE INDEX tasks_created_at_idx ON tasks(created_at DESC);

ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own tasks" ON tasks FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can create their own tasks" ON tasks FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update their own tasks" ON tasks FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete their own tasks" ON tasks FOR DELETE USING (auth.uid() = user_id);
```

Click **Run** ✓

### Step 2: Disable Email Confirmation (1 min)
Supabase Console → Settings → Auth → Email Confirmations → Toggle **OFF**

### Step 3: Run the App (1 min)
```bash
cd /Volumes/DevSSD/Developer/DayTask
flutter run --dart-define-from-file=.env
```

### Step 4: Test It! (1 min)
1. **Sign Up**: test@example.com / TestPassword123!
2. **Create Task**: Click "+" → Add "Test Task"
3. **Verify**: Task appears instantly + in Supabase console

---

## 📋 Verification Checklist

- [ ] Tasks table created in Supabase
- [ ] RLS policies enabled
- [ ] Email confirmation disabled
- [ ] `.env` file has valid credentials
- [ ] No analyzer errors
- [ ] App runs with `--dart-define-from-file=.env`
- [ ] Can sign up
- [ ] Can create task
- [ ] Task appears in Supabase console

---

## 🔗 Key Integrations

| Component          | File                              | Status |
|-------------------|-----------------------------------|--------|
| Supabase Client   | `lib/services/supabase_service.dart` | ✅ Done |
| Authentication    | `lib/auth/auth_service.dart`      | ✅ Done |
| Task CRUD         | `lib/dashboard/task_service.dart` | ✅ Done |
| State Management  | `lib/dashboard/task_controller.dart` | ✅ Done |
| Offline Backup    | `lib/services/offline_backup_service.dart` | ✅ Done |
| Environment Setup | `.env` file                        | ✅ Done |

---

## 🎯 What Works

✅ **Users**
- Sign up with email/password
- Sign in
- Sign out
- OAuth (Google) - optional

✅ **Tasks**
- Add task
- View all tasks
- Mark complete/incomplete
- Delete task
- Auto-sync with Supabase

✅ **Offline**
- Create local JSON backup
- Restore from backup
- Works without internet

✅ **UI/UX**
- Modern dark theme
- Smooth animations
- Error messages
- Loading states

---

## 📞 Common Issues

### Error: "Supabase is not configured"
```bash
flutter clean
flutter pub get
flutter run --dart-define-from-file=.env
```

### Error: 401 Unauthorized
1. Verify RLS policies are set
2. Check email confirmation is disabled
3. Ensure user is logged in

### Tasks don't appear
1. Check Supabase console → Table Editor → tasks
2. Verify user_id matches logged-in user
3. Check network connection

### Can't sign up
1. Settings → Auth → Email Confirmations → OFF
2. Use valid email format
3. Try different email if blocked

---

## 📚 Documentation Files

```
SUPABASE_SETUP.md          ← Full setup guide with SQL
SUPABASE_CHECKLIST.md      ← Step-by-step checklist
INTEGRATION_GUIDE.md       ← Detailed implementation steps
QUICK_REFERENCE.md         ← This file (quick lookup)
```

---

## 🔐 Security Notes

✅ **Row Level Security (RLS)**
- Users can only access their own tasks
- Enforced at database level
- Cannot bypass from app

✅ **Authentication**
- Passwords hashed by Supabase
- JWT tokens for session
- Auto-logout on invalid token

✅ **Offline Backup**
- Stored locally only (not synced)
- User controls backup/restore
- Encrypted if device encrypted

---

## 🎓 Project Structure

```
DayTask/
├── lib/
│   ├── main.dart                      # Entry point
│   ├── app/
│   │   ├── app_gate.dart              # Auth router
│   │   ├── splash_screen.dart         # 4s auto-advance
│   │   └── theme.dart                 # UI design system
│   ├── auth/
│   │   ├── auth_service.dart          # Supabase Auth
│   │   ├── auth_controller.dart       # Riverpod state
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── dashboard/
│   │   ├── task_service.dart          # Supabase CRUD
│   │   ├── task_controller.dart       # Riverpod state
│   │   ├── task_model.dart            # Data model
│   │   ├── dashboard_screen.dart      # Main UI
│   │   ├── task_tile.dart             # Task widget
│   │   └── secondary_screens.dart     # Profile, etc.
│   ├── services/
│   │   ├── supabase_service.dart      # Supabase init
│   │   └── offline_backup_service.dart # Local backup
│   └── utils/
│       └── validators.dart            # Form validation
│
├── .env                               # Credentials ✅
├── .env.example                       # Template
├── pubspec.yaml                       # Dependencies ✅
└── README.md                          # Project info
```

---

## 🚀 Next Steps

1. **Now**: Create tasks table in Supabase
2. **Next**: Run app with `flutter run --dart-define-from-file=.env`
3. **Then**: Test sign up → create task → verify in Supabase
4. **Finally**: Explore features and customize as needed

---

## 💡 Pro Tips

**Tip 1**: Use VS Code?
```
1. Create .vscode/launch.json with --dart-define-from-file=.env
2. Press F5 to run (auto-loads env)
```

**Tip 2**: Debug Supabase queries
Go to Supabase → Logs → you'll see all database queries

**Tip 3**: Test with multiple users
Sign up different emails and create tasks to test RLS

**Tip 4**: Backup your backups
Offline backup saves to app documents folder

---

**Status**: ✅ Ready to integrate!

Everything is configured. Just create the database table and run the app.
