# Supabase `profiles` Table (Auth)

The app stores user profile data in a Supabase `profiles` table so that:

- Sign up and OAuth flows can persist name, email, phone with `auth.uid()`.
- Session restore can resolve the current user from Supabase when the backend is unavailable.

## 1. Table Schema

Run in Supabase Dashboard → SQL Editor (or as a migration):

```sql
-- Profiles table: id = auth.uid(), plus name, email, phone, timestamps
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Optional: trigger to keep updated_at in sync
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_updated_at ON public.profiles;
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();

-- RLS
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

-- Users can read their own profile
CREATE POLICY "Users can read own profile"
ON public.profiles FOR SELECT
TO authenticated
USING (auth.uid() = id);

-- Users can insert their own profile (e.g. on sign up)
CREATE POLICY "Users can insert own profile"
ON public.profiles FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
ON public.profiles FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Optional: users can delete their own profile
CREATE POLICY "Users can delete own profile"
ON public.profiles FOR DELETE
TO authenticated
USING (auth.uid() = id);
```

## 2. App Usage

- **Sign up (email)**: After Supabase `auth.signUp`, the app upserts a row into `profiles` with `id = auth.uid()`, then syncs with the backend if configured.
- **OAuth / Google**: After `getSessionFromUrl`, the app upserts `profiles` from OAuth metadata (email, name, phone).
- **Email verification**: After `verifyOTP`, the app upserts `profiles` from current user metadata.
- **getCurrentUser**: Tries backend first; on 404/401 or “user not found”, falls back to reading from `profiles` by `auth.uid()`.

## 3. Column Mapping

| Column     | Type      | Source / notes                          |
|-----------|-----------|-----------------------------------------|
| `id`      | UUID (PK) | `auth.uid()`                            |
| `name`    | TEXT      | Sign-up form, OAuth metadata            |
| `email`   | TEXT      | Sign-up form, OAuth metadata            |
| `phone`   | TEXT      | Optional; sign-up form, OAuth metadata |
| `created_at` | TIMESTAMPTZ | Default `now()` on insert           |
| `updated_at` | TIMESTAMPTZ | Default `now()`, trigger on update  |

Ensure RLS policies use `id` (not `user_id`) to match this schema.
