# Android Release Build Setup Guide

This guide explains how to set up your local environment to build signed release versions of the Nashik Darshan Android app.

## Overview

The release keystore is **not stored in the repository** for security reasons. Each developer needs to set up their local environment with the keystore and credentials.

## Setup Steps for Developers

### 1. Get the Release Keystore

The release keystore should be shared securely with team members through:

- **Password manager** (1Password, LastPass, Bitwarden, etc.)
- **Encrypted file sharing** (encrypted ZIP with password sent via secure channel)
- **Secure team storage** (company secure drive, AWS Secrets Manager, etc.)
- **Direct secure transfer** (in-person USB, secure messaging)

**Keystore Details:**

- **Location**: `/Users/omkar/keys/myapp-release.jks` (or your local path)
- **Alias**: `nashikdarshan_release_key`
- **Password**: Contact team lead or check secure password manager

### 2. Place the Keystore on Your Machine

```bash
# Create the keys directory (if it doesn't exist)
mkdir -p ~/keys

# Copy the keystore file to your local machine
# (Use the secure method your team uses)
cp /path/to/shared/myapp-release.jks ~/keys/myapp-release.jks
```

### 3. Create Your Local `key.properties` File

Copy the example file and fill in your credentials:

```bash
cd android
cp key.properties.example key.properties
```

Edit `android/key.properties` with your local setup:

```properties
storePassword=your_keystore_password_here
keyPassword=your_key_password_here
keyAlias=nashikdarshan_release_key
storeFile=/Users/YOUR_USERNAME/keys/myapp-release.jks
```

**Important**:

- Update `storeFile` path to match your local keystore location
- Use the actual passwords (get from secure source)
- This file is gitignored and will NOT be committed

### 4. Verify Your Setup

Test that the keystore is accessible:

```bash
keytool -list -v -keystore ~/keys/myapp-release.jks -alias nashikdarshan_release_key
```

You should see the keystore details without errors.

### 5. Build Release APK/AAB

Once set up, you can build release versions:

```bash
# Build release APK
flutter build apk --release

# Build release App Bundle (for Play Store)
flutter build appbundle --release
```

The build system will automatically use your `key.properties` file to sign the release build.

## CI/CD Setup

For automated builds (GitHub Actions, GitLab CI, etc.), use **environment variables** or **secrets**:

### Option 1: Environment Variables in CI

Set these secrets in your CI/CD platform:

- `KEYSTORE_PASSWORD`
- `KEY_PASSWORD`
- `KEY_ALIAS`
- `KEYSTORE_FILE` (base64 encoded keystore)

Then modify `build.gradle.kts` to read from environment variables:

```kotlin
signingConfigs {
    create("release") {
        keyAlias = System.getenv("KEY_ALIAS") ?: keystoreProperties["keyAlias"] as String
        keyPassword = System.getenv("KEY_PASSWORD") ?: keystoreProperties["keyPassword"] as String
        storeFile = file(System.getenv("KEYSTORE_FILE") ?: keystoreProperties["storeFile"] as String)
        storePassword = System.getenv("KEYSTORE_PASSWORD") ?: keystoreProperties["storePassword"] as String
    }
}
```

### Option 2: Secure File Storage in CI

- Store keystore in CI secrets (GitHub Secrets, GitLab CI Variables, etc.)
- Decode and place it during build
- Use environment variables for passwords

## Troubleshooting

### Error: "Keystore file does not exist"

- Check that the `storeFile` path in `key.properties` is correct
- Verify the keystore file exists at that location
- Use absolute path (starting with `/`) for reliability

### Error: "Keystore was tampered with, or password was incorrect"

- Verify the passwords in `key.properties` are correct
- Check for extra spaces or special characters
- Ensure you're using the correct keystore file

### Build still uses debug signing

- Verify `key.properties` exists in `android/` directory
- Check that file permissions allow reading
- Ensure the file is not empty and has correct format

## Security Best Practices

1. **Never commit** `key.properties` or the keystore file
2. **Never share** keystore passwords in plain text (use secure channels)
3. **Back up** the keystore securely (encrypted backup, password manager)
4. **Rotate** keystore if compromised
5. **Limit access** to only developers who need to build releases

## Team Workflow

### For New Team Members

1. Request keystore access from team lead
2. Follow setup steps above
3. Verify with a test release build

### For Team Leads

1. Store keystore in secure location (password manager, encrypted storage)
2. Share keystore and passwords securely with authorized developers
3. Document the sharing process in team wiki/docs
4. Maintain a list of who has access

## Questions?

Contact the team lead or check the team's secure documentation for:

- Keystore download location
- Password access
- CI/CD configuration details
