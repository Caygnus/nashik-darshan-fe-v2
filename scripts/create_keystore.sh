#!/bin/bash

# Script to create Android release keystore
# This will prompt you for:
# - Keystore password (min 6 characters)
# - Key password (can be same as keystore password)
# - Your name and organizational details

KEYSTORE_PATH="$HOME/keys/myapp-release.jks"
KEY_ALIAS="myapp_release_key"

echo "Creating Android release keystore..."
echo "Keystore will be saved to: $KEYSTORE_PATH"
echo ""
echo "You will be prompted for:"
echo "1. Keystore password (minimum 6 characters)"
echo "2. Key password (press Enter to use same as keystore password)"
echo "3. Your name and organizational details"
echo ""

keytool -genkey -v \
  -keystore "$KEYSTORE_PATH" \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias "$KEY_ALIAS" \
  -storetype JKS

if [ $? -eq 0 ]; then
  echo ""
  echo "✓ Keystore created successfully!"
  echo "Location: $KEYSTORE_PATH"
  echo "Alias: $KEY_ALIAS"
  echo ""
  echo "IMPORTANT: Keep your keystore password safe! You'll need it to sign your app for release."
else
  echo ""
  echo "✗ Failed to create keystore. Please try again."
  exit 1
fi

