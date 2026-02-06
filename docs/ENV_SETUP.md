# Environment & Supabase Setup

This doc describes where credentials are used in the project and how to add them via a `.env` file.

---

## Where credentials are used (project scan)

| Variable | Used in | Purpose |
|----------|---------|---------|
| `API_BASE_URL` | `lib/core/env/config.dart` → `Config.baseUrl` | Backend API base URL. `DioClient` (core/dio) uses it when Config is initialized. Auth/API calls use `ApiClient` (core/network) which can use `ApiEndpoints.baseUrl` until you switch to env. |
| `SUPABASE_URL` | `lib/core/supabase/config.dart` → `SupabaseConfig.initialize()` | Supabase project URL (e.g. `https://xxxx.supabase.co`). |
| `SUPABASE_PUBLISHABLE_KEY` | `lib/core/supabase/config.dart` → `SupabaseConfig.initialize()` | Supabase **anon** (public) key for client-side auth. |
| `GOOGLE_WEB_CLIENT_ID` | `lib/core/env/config.dart` → `Config.googleWebClientId` | Optional. For Supabase Google OAuth you configure Web Client ID + Secret in **Supabase Dashboard** (Authentication → Providers → Google), not in `.env`. |

**Deep links** (no env; hardcoded in data layer):

- `com.caygnus.nashikdarshan://login-callback/` — OAuth callback  
- `com.caygnus.nashikdarshan://verify-email/` — Email verification  
- `com.caygnus.nashikdarshan://reset-password/` — Password reset  

Configure these in Supabase Dashboard → Authentication → URL Configuration.

---

## Example files

- **`.env.example`** (project root) — Full example: API + Supabase + optional Google. Copy to `.env` and fill in real values.
- **`env/supabase.env.example`** — Supabase-only example; copy those lines into your `.env` if you prefer.

---

## Steps to use `.env`

1. Copy the example:  
   `cp .env.example .env`
2. Edit `.env` and set:
   - `API_BASE_URL` — your Nashik Darshan API base URL (e.g. `https://5p9ubi66hh.execute-api.ap-south-1.amazonaws.com/v1`).
   - `SUPABASE_URL` — from Supabase Dashboard → Project Settings → API → Project URL.
   - `SUPABASE_PUBLISHABLE_KEY` — from Project Settings → API → anon public key.
3. Add `.env` to Flutter assets in **`pubspec.yaml`**:
   ```yaml
   flutter:
     assets:
       - .env   # uncomment this line
   ```
4. In **`lib/main.dart`**, uncomment:
   - `await Config.instance;`
   - `await SupabaseConfig.initialize();`
5. Rebuild:  
   `flutter clean && flutter pub get && flutter run`

`.env` is in `.gitignore`; do not commit it.

---

## Supabase Dashboard

- **API keys**: Project Settings → API → Project URL + anon public key.
- **Google OAuth**: Authentication → Providers → Google → Web Client ID + Client Secret (from Google Cloud Console).
- **Redirect URLs**: Authentication → URL Configuration → add `com.caygnus.nashikdarshan://login-callback/`, `://verify-email/`, `://reset-password/`.

For full auth/deep-link setup see **`docs/NATIVE_AUTH_SETUP.md`**.
