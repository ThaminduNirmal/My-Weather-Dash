# 🌦️ My Weather Dash

A modern, feature-rich Flutter weather dashboard application that derives geographic coordinates from student index numbers and displays real-time weather information with offline caching support and light/dark theme modes.

[![Flutter](https://img.shields.io/badge/Flutter-3.32.7-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8.1-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Core Logic](#core-logic)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [API Reference](#api-reference)
- [Dependencies](#dependencies)
- [Development](#development)
- [Testing](#testing)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

---

## 🎯 Overview

**My Weather Dash** is a sophisticated Flutter application designed to demonstrate modern mobile app development practices. It transforms student index numbers into geographic coordinates using a mathematical formula and fetches real-time weather data from the Open-Meteo API.

### Key Highlights

- 🌍 **Coordinate Derivation**: Automatically calculates latitude/longitude from student index
- 🌐 **Real-time Weather**: Fetches current weather data from Open-Meteo API
- 💾 **Offline Support**: Caches weather data for offline access
- 🎨 **Dual Themes**: Beautiful light and dark mode with persistent preference
- 📱 **Responsive UI**: Premium, modern interface with smooth animations
- 🔄 **State Management**: Efficient state handling using Provider pattern
- 🎯 **Clean Architecture**: Well-organized, maintainable codebase

---

## ✨ Features

### Core Features

#### 1. **Smart Coordinate Derivation**
- Converts student index (e.g., `194174B`) to geographic coordinates
- Formula: 
  - `latitude = 5 + (first_two_digits / 10.0)`
  - `longitude = 79 + (next_two_digits / 10.0)`
- Validates input format before processing

#### 2. **Real-Time Weather Data**
- Temperature (°C)
- Wind Speed (km/h)
- Weather Code (WMO standard)
- Last Updated Time
- Complete API Request URL

#### 3. **Offline Caching System**
- Automatically caches successful API responses
- Shows cached data when offline
- Visual "CACHED" badge indicator
- Persists across app restarts

#### 4. **Light/Dark Theme**
- Toggle between light and dark modes
- Persistent theme preference
- Smooth animated transitions
- Optimized contrast for both themes

#### 5. **Premium UI/UX**
- Animated splash screen with cloud layers
- Gradient backgrounds
- Glassmorphism card effects
- Color-coded metric tiles
- Interactive search functionality
- Loading indicators
- Error handling with user feedback

---

## 📸 Screenshots

### Dark Mode
```
┌─────────────────────────────────┐
│        My Weather Dash          │
│   Enter your student index      │
│                                 │
│     [194174B]                   │
│   [Search Weather Button]       │
└─────────────────────────────────┘
```

### Light Mode
```
┌─────────────────────────────────┐
│     Weather Details             │
│  Last Updated: 16:25:12         │
│                                 │
│  [Student Index: 194174B]       │
│                                 │
│  [Temp]  [Coords]               │
│  [Wind]  [Weather]              │
│                                 │
│  API: https://api.open-...     │
└─────────────────────────────────┘
```

---

## 🏗️ Architecture

### Design Pattern: **Clean Architecture + Provider State Management**

```
┌─────────────────────────────────────────┐
│              Presentation               │
│  (Screens, Widgets, UI Components)      │
├─────────────────────────────────────────┤
│           State Management              │
│          (Provider Pattern)             │
├─────────────────────────────────────────┤
│            Business Logic               │
│      (Services, Repositories)           │
├─────────────────────────────────────────┤
│            Data Layer                   │
│   (Models, Local Storage, API)          │
└─────────────────────────────────────────┘
```

### Key Architectural Decisions

1. **Separation of Concerns**: Each layer has a single responsibility
2. **Provider Pattern**: Centralized state management for theme
3. **Service Layer**: Isolated business logic from UI
4. **Model Layer**: Immutable data classes with factory constructors
5. **Widget Composition**: Reusable, composable UI components

---

## 📁 Project Structure

```
my_weather_dash/
├── lib/
│   ├── main.dart                          # App entry point, Provider wrapper
│   │
│   ├── models/                            # Data models
│   │   └── weather_data.dart              # Weather data model with JSON parsing
│   │
│   ├── providers/                         # State management
│   │   └── theme_provider.dart            # Theme state & persistence
│   │
│   ├── screens/                           # Screen components
│   │   ├── home_screen.dart               # Initial search screen
│   │   └── weather_details_screen.dart    # Weather display screen
│   │
│   ├── services/                          # Business logic
│   │   ├── weather_service.dart           # API calls, coordinate derivation
│   │   └── storage_service.dart           # Local cache management
│   │
│   └── widgets/                           # Reusable components
│       ├── data_card.dart                 # Generic data display card
│       ├── gradient_button.dart           # Animated gradient button
│       └── theme_toggle_button.dart       # Theme switcher button
│
├── android/                               # Android-specific files
│   ├── app/
│   │   ├── build.gradle                   # App-level Gradle config
│   │   └── src/main/
│   │       ├── AndroidManifest.xml        # Android manifest
│   │       └── kotlin/                    # Kotlin source files
│   └── build.gradle                       # Project-level Gradle config
│
├── ios/                                   # iOS-specific files
│   └── Runner/                            # iOS runner configuration
│
├── test/                                  # Unit & widget tests
│
├── pubspec.yaml                           # Dependencies & app metadata
├── pubspec.lock                           # Locked dependency versions
└── README.md                              # This file
```

---

## 🧠 Core Logic

### 1. Coordinate Derivation Algorithm

**Purpose**: Convert student index to geographic coordinates

**Location**: `lib/services/weather_service.dart`

```dart
// Example: "194174B" → lat: 6.9, lon: 83.1

Step 1: Extract numeric part → "194174"
Step 2: Get first two digits → "19"
Step 3: Get next two digits → "41"
Step 4: Calculate latitude → 5 + (19 / 10.0) = 6.9
Step 5: Calculate longitude → 79 + (41 / 10.0) = 83.1
```

**Formula**:
```dart
firstTwo = int.parse(index[0..1])     // Extract 1st & 2nd digits
nextTwo = int.parse(index[2..3])      // Extract 3rd & 4th digits
latitude = 5 + (firstTwo / 10.0)      // Range: 5.0 to 14.9
longitude = 79 + (nextTwo / 10.0)     // Range: 79.0 to 88.9
```

**Validation**:
- Requires at least 4 numeric digits
- Throws exception if invalid format
- Range covers South Asian region

---

### 2. Weather Fetching Flow

**Location**: `lib/services/weather_service.dart`, `lib/screens/home_screen.dart`

```
User Input (Index)
       ↓
Derive Coordinates
       ↓
Build API URL
       ↓
HTTP GET Request
       ↓
   [Success?]
   ↙        ↘
 YES        NO
  ↓          ↓
Parse      Try
JSON      Cache
  ↓          ↓
Save      Load
Cache     Cache
  ↓          ↓
Display   Display
 Live     Cached
 Data      Data
```

**API Endpoint**:
```
https://api.open-meteo.com/v1/forecast
  ?latitude={lat}
  &longitude={lon}
  &current_weather=true
```

**Response Parsing**:
```dart
{
  "latitude": 6.9,
  "longitude": 83.1,
  "current_weather": {
    "temperature": 27.2,
    "windspeed": 11.5,
    "weathercode": 95
  }
}
```

---

### 3. Caching Strategy

**Location**: `lib/services/storage_service.dart`

**Storage Mechanism**: `SharedPreferences` (key-value pairs)

**Cached Data**:
- `last_weather_data`: Raw JSON response
- `last_weather_index`: Student index
- `last_updated_time`: Timestamp (HH:mm:ss)
- `last_api_url`: Complete API request URL

**Cache Flow**:
```
API Success
    ↓
Save to SharedPreferences
    ↓
[Offline Request]
    ↓
Load from SharedPreferences
    ↓
Display with "CACHED" badge
```

**Benefits**:
- Instant offline access
- No re-fetch on app restart
- Graceful degradation when offline

---

### 4. Theme Management

**Location**: `lib/providers/theme_provider.dart`

**Pattern**: Provider + ChangeNotifier

```dart
ThemeProvider (ChangeNotifier)
    ↓
   State: isDarkMode (bool)
    ↓
   Persist: SharedPreferences
    ↓
   Notify: UI rebuilds on change
```

**Theme Properties**:
- Dark Mode: Deep blue/purple gradient, white text
- Light Mode: Light gray/blue gradient, dark text
- Persistent: Saved to local storage
- Reactive: Instant UI update on toggle

**Color Schemes**:

| Property | Dark Mode | Light Mode |
|----------|-----------|------------|
| Background | #0F0F1E → #1A1A2E | #F5F7FA → #E8EBF0 |
| Cards | #1A1A2E (60-70%) | #FFFFFF (90-95%) |
| Text | White | #1A1A2E |
| Borders | White 12% | Dark 10% |

---

### 5. Navigation Flow

```
App Launch
    ↓
main.dart (Provider setup)
    ↓
HomeScreen (Search)
    ↓
   User Input
    ↓
[Fetch Weather]
    ↓
Navigator.push()
    ↓
WeatherDetailsScreen
    ↓
   Display Data
    ↓
[Back Button]
    ↓
Return to HomeScreen
```

**Navigation Method**: `MaterialPageRoute` with `Navigator.push()`

---

## 🚀 Installation

### Prerequisites

- **Flutter SDK**: 3.32.7 or higher
- **Dart**: 3.8.1 or higher
- **Android Studio**: 2025.1.2+ (for Android development)
- **Xcode**: 15.0+ (for iOS development, macOS only)
- **JDK**: 21 (configured for Flutter)

### Environment Setup

1. **Verify Flutter Installation**:
   ```bash
   flutter doctor -v
   ```
   Ensure all checkmarks are green.

2. **Check Flutter Version**:
   ```bash
   flutter --version
   ```

3. **Configure JDK** (if needed):
   ```bash
   flutter config --jdk-dir="C:\Program Files\Java\jdk-21"
   ```

### Installation Steps

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/my-weather-dash.git
   cd my-weather-dash
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify Project**:
   ```bash
   flutter analyze
   ```

4. **Run on Device/Emulator**:
   ```bash
   # List available devices
   flutter devices

   # Run on specific device
   flutter run -d <device-id>

   # Run on all devices
   flutter run
   ```

5. **Build Release APK** (Android):
   ```bash
   flutter build apk --release
   ```
   Output: `build/app/outputs/flutter-apk/app-release.apk`

6. **Build iOS App** (macOS only):
   ```bash
   flutter build ios --release
   ```

---

## ⚙️ Configuration

### Android Configuration

**File**: `android/app/build.gradle`

```gradle
android {
    compileSdk = 35
    
    defaultConfig {
        applicationId "com.example.my_weather_dash"
        minSdk = 21
        targetSdk = 35
        versionCode = 1
        versionName = "1.0.0"
    }
}
```

**Permissions** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### iOS Configuration

**File**: `ios/Runner/Info.plist`

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

### Gradle Configuration

**Recommended Versions**:
- Android Gradle Plugin: 8.3.2
- Gradle: 7.6+
- Kotlin: 1.9.0+

---

## 📖 Usage

### Basic Workflow

1. **Launch App**: Opens home screen with pre-filled index
2. **Enter Index**: Type student index (e.g., `194174B`)
3. **Search**: Tap "Search Weather" button
4. **View Data**: Navigate to weather details screen
5. **Toggle Theme**: Tap sun/moon icon (top-right)
6. **Go Back**: Use back arrow or system back button

### Example Inputs

| Student Index | Latitude | Longitude | Location Approx. |
|---------------|----------|-----------|------------------|
| 194174B | 6.9 | 83.1 | Sri Lanka |
| 205280B | 7.0 | 84.8 | Sri Lanka |
| 154526B | 6.5 | 84.3 | Sri Lanka |
| 999900B | 14.9 | 88.0 | Bay of Bengal |

### Offline Usage

1. Fetch weather while online (automatically cached)
2. Turn off internet/enable airplane mode
3. Search again with same index
4. App displays cached data with "CACHED" badge
5. Shows friendly "You're offline" notification

### Theme Toggle

- **Location**: Top-right corner (both screens)
- **Action**: Single tap switches theme
- **Persistence**: Preference saved automatically
- **Animation**: Smooth 300ms transition

---

## 🌐 API Reference

### Open-Meteo Weather API

**Base URL**: `https://api.open-meteo.com/v1/forecast`

**Endpoint**: `/forecast`

**Parameters**:
- `latitude` (float): Latitude coordinate (5.0 to 14.9)
- `longitude` (float): Longitude coordinate (79.0 to 88.9)
- `current_weather` (bool): Set to `true` for current conditions

**Example Request**:
```
https://api.open-meteo.com/v1/forecast?latitude=6.9&longitude=83.1&current_weather=true
```

**Response Format** (JSON):
```json
{
  "latitude": 6.9,
  "longitude": 83.1,
  "generationtime_ms": 0.123,
  "utc_offset_seconds": 0,
  "timezone": "GMT",
  "timezone_abbreviation": "GMT",
  "elevation": 123.0,
  "current_weather": {
    "temperature": 27.2,
    "windspeed": 11.5,
    "winddirection": 180,
    "weathercode": 95,
    "is_day": 1,
    "time": "2025-11-16T10:00"
  }
}
```

**Rate Limits**: 
- Free tier: 10,000 requests/day
- No API key required

**Error Handling**:
- `200 OK`: Success
- `400 Bad Request`: Invalid parameters
- `500 Server Error`: API issue
- Timeout: Network error

---

## 📦 Dependencies

### Production Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | SDK | Core Flutter framework |
| `http` | ^1.1.0 | HTTP client for API calls |
| `shared_preferences` | ^2.2.2 | Local key-value storage |
| `intl` | ^0.18.1 | Date/time formatting |
| `provider` | ^6.1.1 | State management |

### Development Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_test` | SDK | Testing framework |
| `flutter_lints` | ^3.0.0 | Linting rules |

### Dependency Details

#### **http**
- **Purpose**: Makes HTTP GET requests to Open-Meteo API
- **Usage**: `await http.get(Uri.parse(url))`
- **Features**: Async/await support, proper error handling

#### **shared_preferences**
- **Purpose**: Persistent key-value storage
- **Usage**: Cache weather data, theme preference
- **Platform**: Android (XML), iOS (NSUserDefaults)

#### **intl**
- **Purpose**: Internationalization and date formatting
- **Usage**: `DateFormat('HH:mm:ss').format(DateTime.now())`
- **Format**: 24-hour time display

#### **provider**
- **Purpose**: State management solution
- **Pattern**: ChangeNotifier + Consumer
- **Benefits**: Reactive UI updates, minimal boilerplate

---

## 🛠️ Development

### Code Style

**Follows**: [Effective Dart](https://dart.dev/guides/language/effective-dart)

**Linting**: `flutter_lints` package

**Key Conventions**:
- PascalCase for classes: `WeatherService`
- camelCase for variables: `weatherData`
- snake_case for files: `weather_service.dart`
- Private members: `_isLoading`
- Constants: `const Color(0xFF6C63FF)`

### Project Setup

```bash
# Clone repository
git clone <repo-url>

# Install dependencies
flutter pub get

# Run code analysis
flutter analyze

# Format code
flutter format lib/

# Run app in debug mode
flutter run

# Run with verbose logging
flutter run -v

# Hot reload: Press 'r' in terminal
# Hot restart: Press 'R' in terminal
```

### Adding New Features

1. **Create Feature Branch**:
   ```bash
   git checkout -b feature/new-feature
   ```

2. **Implement Feature**:
   - Add models in `lib/models/`
   - Add services in `lib/services/`
   - Add screens in `lib/screens/`
   - Add widgets in `lib/widgets/`

3. **Test Feature**:
   ```bash
   flutter test
   ```

4. **Commit Changes**:
   ```bash
   git add .
   git commit -m "Add: New feature description"
   ```

5. **Push & Create PR**:
   ```bash
   git push origin feature/new-feature
   ```

### Debug Tools

**Flutter DevTools**:
```bash
flutter pub global activate devtools
flutter pub global run devtools
```

**Common Commands**:
- `flutter logs`: View device logs
- `flutter screenshot`: Take screenshot
- `flutter doctor`: Check setup
- `flutter clean`: Clean build cache

---

## 🧪 Testing

### Unit Tests

**Location**: `test/`

**Run Tests**:
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/services/weather_service_test.dart

# Run with coverage
flutter test --coverage
```

**Example Test**:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_weather_dash/services/weather_service.dart';

void main() {
  group('WeatherService', () {
    test('deriveCoordinates returns correct values', () {
      final coords = WeatherService.deriveCoordinates('194174B');
      
      expect(coords['latitude'], 6.9);
      expect(coords['longitude'], 83.1);
    });

    test('deriveCoordinates throws on invalid input', () {
      expect(
        () => WeatherService.deriveCoordinates('ABC'),
        throwsException,
      );
    });
  });
}
```

### Widget Tests

**Test UI Components**:
```dart
testWidgets('HomeScreen displays correctly', (WidgetTester tester) async {
  await tester.pumpWidget(MyWeatherDashApp());
  
  expect(find.text('My Weather Dash'), findsOneWidget);
  expect(find.byType(TextField), findsOneWidget);
});
```

### Integration Tests

**Location**: `integration_test/`

**Setup**:
```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

**Run**:
```bash
flutter test integration_test/app_test.dart
```

---

## 🐛 Troubleshooting

### Common Issues

#### 1. **API Call Fails**

**Symptoms**: Error message, no weather data

**Causes**:
- No internet connection
- Invalid coordinates (out of range)
- API server down

**Solutions**:
```dart
✅ Check internet connection
✅ Verify coordinates are valid (5-15 lat, 79-89 lon)
✅ Try loading cached data
✅ Check API status: https://open-meteo.com
```

#### 2. **Build Fails (Android)**

**Error**: `Execution failed for task ':app:processDebugResources'`

**Solutions**:
```bash
# Clean build
flutter clean
flutter pub get

# Update Gradle
# In android/gradle/wrapper/gradle-wrapper.properties:
distributionUrl=https\://services.gradle.org/distributions/gradle-7.6-all.zip

# Rebuild
flutter run
```

#### 3. **Theme Not Persisting**

**Symptoms**: Theme resets on app restart

**Causes**:
- SharedPreferences not initialized
- Async loading issue

**Solutions**:
```dart
✅ Ensure ThemeProvider constructor calls _loadTheme()
✅ Check SharedPreferences permissions
✅ Verify await/async usage in toggleTheme()
```

#### 4. **Cached Data Not Loading**

**Symptoms**: Offline shows error instead of cached data

**Causes**:
- No previous successful fetch
- Cache cleared/corrupted

**Solutions**:
```dart
✅ Fetch weather while online first
✅ Check StorageService.saveWeatherData() is called
✅ Verify SharedPreferences keys match
```

#### 5. **IDE Errors (False Positives)**

**Error**: `The method 'WeatherDetailsScreen' isn't defined`

**Cause**: IDE analyzer cache issue

**Solutions**:
```bash
# Restart Dart Analysis Server
Tools → Flutter → Restart Dart Analysis Server

# Or invalidate caches
File → Invalidate Caches / Restart

# Or clean and rebuild
flutter clean && flutter pub get
```

### Debug Mode

**Enable Debug Logging**:
```dart
// In main.dart
void main() {
  debugPrint('App starting...');
  runApp(MyWeatherDashApp());
}

// In services
print('API Response: $response');
```

**Check Device Logs**:
```bash
flutter logs
```

### Performance Issues

**Symptoms**: Slow UI, janky animations

**Solutions**:
```bash
# Build release version
flutter build apk --release

# Profile mode
flutter run --profile

# Check performance overlay
# In app: Press 'P' in terminal
```

---

## 🤝 Contributing

We welcome contributions! Please follow these guidelines:

### Contribution Process

1. **Fork Repository**
2. **Create Feature Branch**: `git checkout -b feature/AmazingFeature`
3. **Commit Changes**: `git commit -m 'Add: Amazing feature'`
4. **Push to Branch**: `git push origin feature/AmazingFeature`
5. **Open Pull Request**

### Commit Message Format

```
<type>: <description>

Types:
- Add: New feature
- Fix: Bug fix
- Update: Update existing feature
- Refactor: Code refactoring
- Docs: Documentation changes
- Style: Code style changes
- Test: Add/update tests
```

### Code Review Checklist

- [ ] Code follows project style guide
- [ ] All tests pass (`flutter test`)
- [ ] No linting errors (`flutter analyze`)
- [ ] Documentation updated
- [ ] Changelog updated (if applicable)

---

## 📄 License

This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2025 My Weather Dash

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## 🙏 Acknowledgments

- **Open-Meteo**: Free weather API (https://open-meteo.com)
- **Flutter Team**: Amazing framework
- **Provider Package**: Simple state management
- **Material Design**: UI/UX guidelines

---

## 📞 Contact & Support

- **Email**: your.email@example.com
- **GitHub Issues**: https://github.com/yourusername/my-weather-dash/issues
- **Documentation**: https://github.com/yourusername/my-weather-dash/wiki

---

## 🗺️ Roadmap

### Version 1.0.0 (Current) ✅
- [x] Basic weather fetching
- [x] Coordinate derivation
- [x] Offline caching
- [x] Light/dark themes
- [x] Premium UI

### Version 1.1.0 (Planned) 🚀
- [ ] Weather forecast (7 days)
- [ ] Location search by city name
- [ ] Multiple locations support
- [ ] Weather alerts/notifications
- [ ] Custom unit selection (°F/°C)

### Version 2.0.0 (Future) 🌟
- [ ] Weather maps
- [ ] Historical data charts
- [ ] Widget support
- [ ] Share weather data
- [ ] Multi-language support

---

## 📊 Project Stats

- **Lines of Code**: ~2,500
- **Files**: 10 Dart files + configs
- **Screens**: 2 main screens
- **Widgets**: 3 reusable components
- **Services**: 2 (Weather, Storage)
- **State Management**: Provider
- **Build Size**: ~18 MB (APK)

---

## 🎓 Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Provider Package](https://pub.dev/packages/provider)
- [Open-Meteo API Docs](https://open-meteo.com/en/docs)
- [Material Design Guidelines](https://material.io/design)

---

## ⚡ Quick Start Commands

```bash
# Setup
git clone <repo-url>
cd my-weather-dash
flutter pub get

# Run
flutter run

# Build
flutter build apk --release

# Test
flutter test

# Format
flutter format lib/

# Analyze
flutter analyze
```

---

<div align="center">

**Made with ❤️ using Flutter**

⭐ Star this repo if you find it helpful!

[Report Bug](https://github.com/yourusername/my-weather-dash/issues) · [Request Feature](https://github.com/yourusername/my-weather-dash/issues)

</div>

---

**Last Updated**: November 16, 2025  
**Version**: 1.0.0  
**Status**: Production Ready ✅

