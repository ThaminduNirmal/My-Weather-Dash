# My Weather Dash

A beautiful weather dashboard application built with Flutter.

## Features

- Display current weather information
- Location-based weather data
- Clean and intuitive user interface
- Cross-platform support (Android, iOS, Web)

## Getting Started

This project is a Flutter application.

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (included with Flutter)
- Android Studio / Xcode for mobile development
- A code editor (VS Code, Android Studio, IntelliJ, etc.)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/ThaminduNirmal/My-Weather-Dash.git
cd My-Weather-Dash
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Build

To build the app for different platforms:

- **Android**: `flutter build apk`
- **iOS**: `flutter build ios`
- **Web**: `flutter build web`

## Project Structure

```
lib/
  main.dart           # Application entry point
test/
  widget_test.dart    # Widget tests
android/              # Android-specific files
ios/                  # iOS-specific files
web/                  # Web-specific files
```

## Dependencies

- **http**: For API calls
- **provider**: State management
- **intl**: Internationalization
- **geolocator**: Location services
- **permission_handler**: Handle permissions
- **shared_preferences**: Local storage

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.
