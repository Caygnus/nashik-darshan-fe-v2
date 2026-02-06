# Nashik Darshan

A Flutter application for exploring Nashik.

## Documentation

- [Android Release Build Setup](./docs/ANDROID_RELEASE_BUILD_SETUP.md) - Guide for setting up release builds
- [Native Auth Setup](./docs/NATIVE_AUTH_SETUP.md) - Google Sign-In and deep linking setup
- [Clean Architecture Guide](./docs/CLEAN_ARCHITECTURE_GUIDE.md) - Architecture documentation

## Code Formatting and IDE Configuration

The project uses Dart's built-in formatter and additional linting rules:

- **Linting Rules**: Custom rules are defined in `analysis_options.yaml`
- **Dart Code Metrics**: Advanced static analysis for better code quality
- **Cursor IDE Configuration**: Specific settings for Cursor IDE in `.cursor.config.json`

### Dart Formatter Setup

The project is configured to use Dart's built-in formatter with the following settings:

- **Line Length**: 80 characters (configured in `.cursor.config.json`)
- **Indentation**: 2 spaces
- **Auto-format on Save**: Enabled in Cursor IDE
- **Auto-format on Paste**: Enabled in Cursor IDE

#### Manual Formatting

To format all Dart files in the project:

```bash
dart format .
```

To format only the `lib` directory:

```bash
dart format lib/
```

To check if files are formatted without modifying them (useful for CI):

```bash
dart format --set-exit-if-changed .
```

#### IDE Configuration

The Cursor IDE is configured to automatically format Dart files:

- **Format on Save**: Enabled
- **Format on Paste**: Enabled
- **Format on Type**: Enabled

These settings are defined in `.cursor.config.json`.
