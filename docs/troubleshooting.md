# Troubleshooting

## App Shows Supabase Config Message

Cause:

- Missing `SUPABASE_URL` or `SUPABASE_ANON_KEY`

Fix:

- Create `.env` from `.env.example`, set both values, then run with `--dart-define-from-file`:

```bash
cp .env.example .env
flutter run --dart-define-from-file=.env
```

- Alternative: pass both `--dart-define` values directly.

## Login or Signup Fails

Checklist:

- Email and password are valid
- Supabase Auth email/password provider is enabled
- Network access is available

## Tasks Not Loading

Checklist:

- `tasks` table exists in Supabase
- RLS is enabled
- All four policies are created
- `user_id` column references `auth.users(id)`

## Permission Denied on Insert/Update/Delete

Cause:

- RLS policy missing or mismatched

Fix:

- Re-apply policies from `docs/supabase.md`

## UI Not Updating After Data Change

Notes:

- This app uses fetch-on-demand, not realtime subscriptions
- Task list updates after controller actions or pull-to-refresh
