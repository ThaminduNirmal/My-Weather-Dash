# My Weather Dashboard

A beautiful weather dashboard application built with Flutter.

## Features

- Real-time weather information
- Location-based weather data
- Clean and modern UI
- Material Design 3

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/ThaminduNirmal/My-Weather-Dash.git
```

2. Navigate to the project directory:
```bash
cd My-Weather-Dash
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
My-Weather-Dash/
├── lib/
│   └── main.dart          # Main application entry point
├── test/                  # Unit and widget tests
├── android/               # Android-specific files
├── ios/                   # iOS-specific files
├── web/                   # Web-specific files
├── pubspec.yaml           # Project dependencies
└── analysis_options.yaml  # Dart analyzer configuration
```

## Dependencies

- `http` - For API calls
- `provider` - State management
- `shared_preferences` - Local storage
- `intl` - Internationalization
- `geolocator` - Location services
- `permission_handler` - Permission handling

## Testing

Run tests with:
```bash
flutter test
```

## Building

### Android
```bash
flutter build apk
```

### iOS
```bash
flutter build ios
```

### Web
```bash
flutter build web
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available under the MIT License.
