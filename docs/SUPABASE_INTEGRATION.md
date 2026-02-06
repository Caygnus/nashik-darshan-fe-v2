# Supabase Integration Summary

This document summarizes how Supabase is configured and used in the Nashik Darshan app.

## 1. Environment & Configuration

- **SUPABASE_URL** and **SUPABASE_PUBLISHABLE_KEY** (anon key only) are loaded from `.env` via `flutter_dotenv`.
- **No service_role key** is used anywhere in client code; the config rejects any key containing `service_role`.
- Env is loaded **before** Supabase: in `main.dart`, `await Config.instance` runs first (loads `.env`), then `await SupabaseConfig.initialize()`.

See `.env.example` and `docs/ENV_SETUP.md`.

## 2. Supabase Initialization

- **Single init**: `SupabaseConfig.initialize()` is called once in `main.dart` before `runApp()`.
- **Order**: `WidgetsFlutterBinding.ensureInitialized()` → `Config.instance` → `SupabaseConfig.initialize()` → `serviceLocatorInit()` → deep link init → `AppRouter.init()` → `runApp()`.
- Client is exposed via `SupabaseConfig.client` (wraps `Supabase.instance.client`).
- No auth or Supabase calls run before initialization completes; the app shows a bootstrap error screen if Config or Supabase init fails.

## 3. Authentication

- **Email/Password**: Sign-up, sign-in, password reset, email verification (OTP) are implemented in the auth data layer and use Supabase Auth.
- **Google OAuth**: `signInWithOAuth(Google)` with redirect; session is created when the app handles the deep link.

**Redirect URL (single, consistent):**

- `com.caygnus.nashikdarshan://login-callback/`
- Used in: Supabase Dashboard (Auth → URL Configuration), Flutter OAuth call (`auth_supabase_datasource.dart`), Android `AndroidManifest.xml` (intent-filter), and Google Cloud Console redirect URIs.

## 4. Google Sign-In (Mobile)

- `signInWithOAuth()` is called only after Supabase is initialized (auth flows are triggered from UI, which loads after init).
- Success: user is redirected back via deep link → OAuth callback page → `CompleteOAuthCallback` use case → session created, user synced to backend → `AuthCubit.loadCurrentUser()`.
- Errors/cancellation: logged via `SupabaseLogger`, errors surfaced to UI.
- **Session recovery**: On app restart, `AuthCubit._initializeAuthState()` runs and calls `GetCurrentUser`; if the backend returns a user (using stored token), the app restores the authenticated state. Supabase session is persisted by `supabase_flutter` and is also used for protected route checks.

## 5. Database

- **SupabaseDatabaseService** (`lib/core/supabase/supabase_database_service.dart`) provides select/insert/update/delete on Supabase Postgres.
- All tables must have **RLS enabled** and policies for authenticated/anon as needed. See `docs/SUPABASE_DATABASE_RLS.md`.

## 6. Storage

- **SupabaseStorageService** (`lib/core/supabase/supabase_storage_service.dart`) provides upload, download, public URL, signed URL, and remove.
- Buckets: `public` and `private` (names in `SupabaseStorageBuckets`). Create buckets and policies in Dashboard. See `docs/SUPABASE_STORAGE.md`.

## 7. Session Management

- **Persistent session**: Supabase Auth session is persisted by `supabase_flutter`. Backend API token is stored in `SecureTokenStorage` (encrypted).
- **Restore on restart**: `AuthCubit` calls `GetCurrentUser` on startup; success restores authenticated state.
- **Sign-out**: `SignOut` use case clears `SecureTokenStorage` and calls Supabase `signOut()` (data layer).
- **Protected routes**: `RouteRedirect.handleRedirect` checks `SupabaseConfig.client.auth.currentUser`; if null and route is in `protectedRoutes`, redirects to login.

## 8. Error Handling & Logging

- **SupabaseLogger** (`lib/core/supabase/supabase_logger.dart`): init, auth, OAuth, storage, DB, and error logging.
- Auth datasource logs sign-up/sign-in, Google OAuth, sign-out, and OAuth callback success/failure.
- Failures throw with clear messages; UI shows user-facing errors.

## 9. Clean Architecture

- **Config**: `lib/core/supabase/config.dart` (init, client access).
- **Auth**: `lib/features/auth/data/datasources/auth_supabase_datasource.dart` (Supabase Auth only; no business logic in UI).
- **Database**: `lib/core/supabase/supabase_database_service.dart`.
- **Storage**: `lib/core/supabase/supabase_storage_service.dart`.
- UI depends on domain use cases; no direct Supabase in presentation.

## 10. Final Checklist

- [ ] `.env` exists (copy from `.env.example`), contains `SUPABASE_URL` and `SUPABASE_PUBLISHABLE_KEY` (anon key).
- [ ] `.env` is listed under `flutter.assets` in `pubspec.yaml`.
- [ ] Supabase Dashboard: Auth → URL Configuration includes `com.caygnus.nashikdarshan://login-callback/`.
- [ ] Google OAuth: provider enabled in Supabase; Web Client ID/Secret set; redirect in Google Cloud Console matches Supabase callback.
- [ ] App launches without Supabase errors (check logs with tag `Supabase`).
- [ ] Google Sign-In works on a real device (OAuth redirect).
- [ ] Database/Storage: RLS and bucket policies set as in `SUPABASE_DATABASE_RLS.md` and `SUPABASE_STORAGE.md`.
