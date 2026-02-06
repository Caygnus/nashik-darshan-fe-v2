# Supabase Database & RLS Setup

This app uses Supabase Postgres via the client (anon key). All tables **must** have Row Level Security (RLS) enabled and policies that allow only the intended access.

## 1. Enable RLS on All Tables

In Supabase Dashboard → SQL Editor, or via migrations:

```sql
-- Enable RLS on every user-facing table
ALTER TABLE your_table ENABLE ROW LEVEL SECURITY;
```

## 2. Minimal Safe Policies

### Authenticated users (read/write own data)

Example: table `profiles` with `id` (UUID, primary key) = `auth.uid()`. See `docs/SUPABASE_PROFILES_TABLE.md` for full schema and migration.

```sql
-- Allow authenticated users to read their own row
CREATE POLICY "Users can read own profile"
ON profiles FOR SELECT
TO authenticated
USING (auth.uid() = id);

-- Allow authenticated users to insert their own row
CREATE POLICY "Users can insert own profile"
ON profiles FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = id);

-- Allow authenticated users to update their own row
CREATE POLICY "Users can update own profile"
ON profiles FOR UPDATE
TO authenticated
USING (auth.uid() = id)
WITH CHECK (auth.uid() = id);

-- Allow authenticated users to delete their own row (if needed)
CREATE POLICY "Users can delete own profile"
ON profiles FOR DELETE
TO authenticated
USING (auth.uid() = id);
```

### Public read, authenticated write

Example: table `categories` (read by anyone, write by authenticated).

```sql
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can read categories"
ON categories FOR SELECT
TO anon, authenticated
USING (true);

CREATE POLICY "Authenticated can insert categories"
ON categories FOR INSERT
TO authenticated
WITH CHECK (true);
```

## 3. Ensure Queries Do Not Fail

- Every table used from the Flutter app must have at least one policy that allows the operation (SELECT/INSERT/UPDATE/DELETE) for the role used (anon or authenticated).
- If RLS is enabled and no policy allows an operation, the query returns empty or fails. Add policies so that:
  - Authenticated users can read/write their own data where applicable.
  - Public read-only tables have a SELECT policy for `anon` and/or `authenticated`.

## 4. Using the Database Service

Use `SupabaseDatabaseService` (lib/core/supabase/supabase_database_service.dart) only **after** `SupabaseConfig.initialize()` in main:

- `SupabaseDatabaseService.from('table_name')` – select all rows (optional filter with `column`/`value`).
- `SupabaseDatabaseService.fromSingle('table_name', column: 'id', value: id)` – single row.
- `SupabaseDatabaseService.insert('table_name', data)` – insert.
- `SupabaseDatabaseService.update/delete` – update/delete by column/value.

All access goes through the anon key and respects RLS.
