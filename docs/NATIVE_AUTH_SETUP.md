# Google Authentication Setup Guide

This guide explains how to set up Google Sign-In with Supabase and deep linking for email verification in the Nashik Darshan app.

## Features Implemented

1. **Google Sign-In with Supabase OAuth**: Uses Supabase's built-in OAuth flow for Google authentication
2. **Deep Linking**: Handles OAuth callbacks, email verification, and password reset links within the app
3. **Session Management**: Supabase automatically handles token management and session creation

## Authentication Method

**Current Implementation: Supabase OAuth (Browser-based)**

The app now uses Supabase's built-in `signInWithOAuth()` method which:

- Opens a browser/WebView for Google sign-in
- Handles the entire OAuth flow automatically
- Redirects back to the app via deep link
- Creates the session automatically

**Advantages:**

- ✅ Simpler setup (no `google_sign_in` package needed)
- ✅ No need for Web OAuth Client ID in `.env` file
- ✅ Supabase handles all token management
- ✅ Works consistently across platforms
- ✅ No SHA-1 fingerprint issues

**Trade-offs:**

- Uses browser/WebView instead of native dialog (slightly less native feel)
- Requires internet connection for OAuth flow

## Important: Understanding OAuth Client Configuration for Supabase

**This app uses Supabase (NOT Firebase)**, so you don't need Firebase configuration files.

When you create an OAuth client ID in Google Cloud Console, you might see options to download:

- **Client Secret JSON** (e.g., `client_secret_xxx.json`) - This is for **server-side** OAuth flows, **NOT needed** for this Flutter app
- **google-services.json** - This is only needed if you're using **Firebase**, which this app does **NOT** use (we use Supabase instead)

**What you actually need for Supabase:**

1. Create OAuth client IDs in Google Cloud Console:
   - **Web OAuth Client ID** (REQUIRED - used by Supabase for OAuth flow)
   - **Android OAuth Client ID** (optional - for better UX on Android)
   - **iOS OAuth Client ID** (optional - for better UX on iOS)
2. Copy the **OAuth Client ID** and **Client Secret** values
3. Add Web Client ID and Secret to Supabase under Authentication → Providers → Google
4. Add Android/iOS Client IDs to Supabase if created (optional)
5. **No environment variables needed** - everything is configured in Supabase Dashboard
6. **No JSON files need to be downloaded or added to your project**

**How the flow works:**

1. User taps "Sign in with Google" in your app
2. App calls Supabase's `signInWithOAuth()` which opens browser/WebView
3. User signs in with Google in the browser
4. Google redirects back to app via deep link: `com.caygnus.nashikdarshan://login-callback/`
5. App handles the deep link and Supabase exchanges the OAuth code for tokens
6. Supabase creates/updates user session automatically
7. User is authenticated in your app via Supabase

## Setup Instructions

### 1. Google Sign-In Configuration

#### Step 1: Create OAuth Clients in Google Cloud Console

You need to create at least **ONE** OAuth Client ID (Web is required):

**a) Web OAuth Client ID (REQUIRED):**

- Go to [Google Cloud Console](https://console.cloud.google.com/)
- Create a new project or select existing one
- Go to "APIs & Services" → "Credentials"
- Click "Create Credentials" → "OAuth client ID"
- If prompted, configure the OAuth consent screen first
- Select "Web application" application type
- Enter a name (e.g., "Nashik Darshan Web Client")
- Under "Authorized redirect URIs", add:
  - `https://YOUR_PROJECT_REF.supabase.co/auth/v1/callback`
  - (Replace YOUR_PROJECT_REF with your Supabase project reference - you can find this in your Supabase project URL)
- Click "Create"
- Copy the **Client ID** and **Client Secret** (you'll need both for Supabase)

**b) Android OAuth Client ID (Optional - for better UX):**

- In the same "Credentials" page, click "Create Credentials" → "OAuth client ID" again
- Select "Android" application type
- Enter your package name: `com.caygnus.nashikdarshan`
- Enter the SHA-1 fingerprint (get it using the command below)
- Click "Create"
- Copy the **Client ID** (you'll need this for Supabase)

**To get SHA-1 fingerprint (for Android OAuth Client ID):**

```bash
# Debug keystore
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Release keystore (if you have one)
keytool -list -v -keystore /path/to/your/keystore.jks -alias your-key-alias
```

**c) iOS OAuth Client ID (Optional - for better UX):**

- In the same "Credentials" page, click "Create Credentials" → "OAuth client ID" again
- Select "iOS" application type
- Enter your Bundle ID: `com.caygnus.nashikdarshan`
- Click "Create"
- Copy the **Client ID** (you'll need this for Supabase)

**Important Notes:**

- The Web OAuth Client ID is REQUIRED - Supabase uses it for the OAuth flow
- Android/iOS Client IDs are optional but recommended for better user experience
- You don't need `google-services.json` (that's only for Firebase)
- You don't need to add anything to your `.env` file
- The client_secret JSON file you might see is for server-side OAuth flows, ignore it

### 2. Supabase Configuration

Since you're using Supabase for authentication, configure the following in your Supabase Dashboard:

1. **Configure Redirect URLs in Supabase Dashboard**:

   - Go to your Supabase project → Authentication → URL Configuration
   - Under "Redirect URLs", add these deep link URLs:
     - `com.caygnus.nashikdarshan://login-callback/`
     - `com.caygnus.nashikdarshan://reset-password/`
     - `com.caygnus.nashikdarshan://verify-email/`
   - Click "Save" to apply changes

2. **Enable Google Provider in Supabase**:

   - Go to Authentication → Providers
   - Find "Google" in the list of providers
   - Toggle it to **Enabled**
   - You'll see fields for OAuth configuration:
     - **Client ID (for OAuth)**: Paste your **Web OAuth Client ID** here (REQUIRED)
     - **Client Secret (for OAuth)**: Paste your **Web OAuth Client Secret** here (REQUIRED)
     - **Client ID (for Android)**: Paste your Android OAuth Client ID here (optional)
     - **Client ID (for iOS)**: Paste your iOS OAuth Client ID here (optional)
   - **How to find your OAuth credentials from Google Cloud Console**:
     1. Go to [Google Cloud Console](https://console.cloud.google.com/)
     2. Select your project
     3. Go to "APIs & Services" → "Credentials"
     4. Find your OAuth 2.0 Client IDs in the list
     5. Click on the **Web** client ID you created
     6. Copy the **Client ID** and **Client Secret** values
     7. Paste these into the corresponding fields in Supabase
   - **Important Notes**:
     - ✅ **REQUIRED**: Web OAuth Client ID and Client Secret (used by Supabase for OAuth flow)
     - ✅ **Optional**: Android OAuth Client ID (for better UX on Android)
     - ✅ **Optional**: iOS OAuth Client ID (for better UX on iOS)
     - The Web Client ID and Secret are used by Supabase to handle the OAuth flow
     - Android/iOS Client IDs are only used if you want platform-specific optimizations
   - Click "Save" to apply changes

### 3. Deep Linking Configuration

#### Android

Deep linking is already configured in `android/app/src/main/AndroidManifest.xml`:

- `com.caygnus.nashikdarshan://login-callback/`
- `com.caygnus.nashikdarshan://reset-password/`
- `com.caygnus.nashikdarshan://verify-email/`

#### iOS

Deep linking is already configured in `ios/Runner/Info.plist` with URL scheme: `com.caygnus.nashikdarshan`

### 4. Email Verification Setup

1. **Configure Email Templates in Supabase**:

   - Go to Authentication → Email Templates
   - Update confirmation email template to use deep link:
     ```
     {{ .ConfirmationURL }}?token={{ .Token }}&type=email&email={{ .Email }}
     ```
   - Update password reset email template:
     ```
     {{ .ConfirmationURL }}?token={{ .Token }}&type=recovery&email={{ .Email }}
     ```

2. **Set Site URL in Supabase**:
   - Go to Authentication → URL Configuration
   - Set Site URL to: `com.caygnus.nashikdarshan://`

## How It Works

### Google Sign-In Flow (with Supabase OAuth)

1. User taps "Sign in with Google" in your app
2. App calls `SupabaseConfig.client.auth.signInWithOAuth()` which opens browser/WebView
3. User signs in with Google in the browser
4. Google redirects to Supabase's OAuth callback URL
5. Supabase exchanges the OAuth code for tokens and creates a session
6. Supabase redirects back to app via deep link: `com.caygnus.nashikdarshan://login-callback/`
7. App handles the deep link and calls `getSessionFromUrl()` to complete authentication
8. Supabase session is created (access token, refresh token, user data)
9. Auth state listener detects the session change and updates the app state
10. User is authenticated in your app via Supabase

**Key Point**: The entire OAuth flow is handled by Supabase. The app just initiates the flow and handles the callback.

### Email Verification Flow

1. User signs up with email
2. Supabase sends verification email with deep link
3. User clicks link in email
4. Deep link opens app: `com.caygnus.nashikdarshan://verify-email/?token=xxx&type=email&email=xxx`
5. `DeepLinkService` handles the link
6. App verifies email using token
7. User is authenticated automatically

### Password Reset Flow

1. User requests password reset
2. Supabase sends reset email with deep link
3. User clicks link in email
4. Deep link opens app: `com.caygnus.nashikdarshan://reset-password/?token=xxx&type=recovery&email=xxx`
5. App navigates to password reset screen
6. User enters new password
7. Password is reset using token

## Testing

### Test Google Sign-In

1. Run the app
2. Tap "Sign in with Google"
3. Select a Google account
4. Verify you're signed in

### Test Email Verification

1. Sign up with a new email
2. Check email for verification link
3. Click the link (should open app)
4. Verify email is confirmed

### Test Deep Links

You can test deep links using ADB (Android) or Xcode (iOS):

**Android**:

```bash
adb shell am start -W -a android.intent.action.VIEW -d "com.caygnus.nashikdarshan://verify-email/?token=test&type=email&email=test@example.com" com.caygnus.nashikdarshan
```

**iOS**:

```bash
xcrun simctl openurl booted "com.caygnus.nashikdarshan://verify-email/?token=test&type=email&email=test@example.com"
```

## Troubleshooting

### Google Sign-In Issues

- **"Failed to initiate Google Sign-In"**:
  - ✅ **Most common cause**: Missing Web OAuth Client ID or Secret in Supabase
  - Check that Web OAuth Client ID and Secret are configured in Supabase Dashboard
  - Verify you created a Web OAuth Client ID in Google Cloud Console
  - Make sure the redirect URI is added in Google Cloud Console: `https://YOUR_PROJECT_REF.supabase.co/auth/v1/callback`
- **"OAuth callback error"**:
  - Verify the redirect URL is configured in Supabase: `com.caygnus.nashikdarshan://login-callback/`
  - Check that deep linking is properly configured in AndroidManifest.xml and Info.plist
  - Ensure the app can handle the deep link callback
- **Browser opens but sign-in fails**:
  - Check that the OAuth consent screen is configured in Google Cloud Console
  - Verify the redirect URI in Google Cloud Console matches Supabase's callback URL
  - Ensure the Web OAuth Client ID and Secret in Supabase match Google Cloud Console
- **"Sign in failed"**:
  - Verify package name matches exactly: `com.caygnus.nashikdarshan`
  - Check that Google provider is enabled in Supabase Dashboard
  - Ensure all OAuth credentials are correctly configured

### Deep Link Issues

- **Links not opening app**: Verify URL scheme in AndroidManifest.xml and Info.plist
- **Email verification not working**: Check Supabase email template configuration
- **Token expired**: Email verification links expire after 24 hours by default

## Security Notes

1. **Access Tokens**: Stored securely by Supabase SDK
2. **Deep Links**: Validate tokens server-side before processing
3. **OAuth**: Use PKCE flow for enhanced security (already configured)
4. **Email Links**: Tokens are single-use and time-limited

## Additional Resources

- [Google Sign-In Flutter Plugin](https://pub.dev/packages/google_sign_in)
- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Deep Linking Guide](https://docs.flutter.dev/development/ui/navigation/deep-linking)
