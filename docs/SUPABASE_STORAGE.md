# Supabase Storage Setup

Use Supabase Storage for file uploads and downloads. Configure buckets and policies in the Supabase Dashboard.

## 1. Create Buckets

In Supabase Dashboard → Storage:

1. **public** (or your chosen name)
   - Public bucket: files are readable by anyone via public URL.
   - Use for: avatars, place images, etc.

2. **private** (or your chosen name)
   - Private bucket: access only via signed URLs or authenticated requests.
   - Use for: user documents, private uploads.

## 2. Bucket Policies

### Public bucket (e.g. `public`)

- **Read**: Allow `anon` and `authenticated` to read.
- **Write**: Allow `authenticated` to upload (optionally restrict to own path, e.g. `user_id/*`).

In Dashboard → Storage → bucket → Policies, or SQL:

```sql
-- Allow public read
CREATE POLICY "Public read"
ON storage.objects FOR SELECT
TO public
USING (bucket_id = 'public');

-- Allow authenticated upload (optional: restrict path)
CREATE POLICY "Authenticated upload"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'public');
```

### Private bucket (e.g. `private`)

- **Read/Write**: Only `authenticated` users, and optionally only for their own path (`auth.uid()::text || '/*'`).

```sql
CREATE POLICY "Users read own files"
ON storage.objects FOR SELECT
TO authenticated
USING (bucket_id = 'private' AND (storage.foldername(name))[1] = auth.uid()::text);

CREATE POLICY "Users upload own files"
ON storage.objects FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'private' AND (storage.foldername(name))[1] = auth.uid()::text);
```

## 3. Flutter Usage

Use `SupabaseStorageService` (lib/core/supabase/supabase_storage_service.dart) only **after** `SupabaseConfig.initialize()`:

- **Upload file**: `SupabaseStorageService.uploadFile(bucket: 'public', path: 'avatars/user_id.jpg', file: file)`.
- **Upload bytes**: `SupabaseStorageService.uploadBytes(bucket: 'public', path: 'path', bytes: bytes)`.
- **Public URL**: `SupabaseStorageService.getPublicUrl('public', path)`.
- **Download**: `SupabaseStorageService.downloadBytes(bucket: 'private', path: path)`.
- **Signed URL** (private): `SupabaseStorageService.createSignedUrl(bucket: 'private', path: path, expiresIn: 3600)`.
- **Remove**: `SupabaseStorageService.remove(bucket: 'public', path: path)`.

Bucket names are defined in `SupabaseStorageBuckets` (public/private). Create buckets with these names in the Dashboard or adjust the constant to match your bucket names.
