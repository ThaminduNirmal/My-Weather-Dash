# Copilot Instructions for My-Weather-Dash

## Project Overview
My-Weather-Dash is a Flutter-based weather dashboard application that provides weather information and forecasts.

## Technology Stack
- **Framework**: Flutter
- **Language**: Dart
- **Platform**: Cross-platform (Android, iOS, Web, Desktop)

## Code Style and Conventions

### Dart/Flutter Best Practices
- Follow the official [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `lowerCamelCase` for variables, methods, and parameters
- Use `UpperCamelCase` for classes, enums, typedefs, and type parameters
- Prefer `const` constructors where possible for better performance
- Use `final` for variables that won't be reassigned
- Always use trailing commas in Flutter widget trees for better formatting

### File Organization
- Place models in `lib/models/`
- Place screens/pages in `lib/screens/` or `lib/pages/`
- Place widgets in `lib/widgets/`
- Place services (API calls, etc.) in `lib/services/`
- Place utilities in `lib/utils/`
- Place constants in `lib/constants/`

### Widget Structure
- Prefer stateless widgets over stateful widgets when state management is not needed
- Extract complex widget trees into separate widget classes
- Keep widget build methods concise and readable
- Use proper widget composition over deep nesting

### State Management
- Follow the chosen state management pattern consistently (Provider, Riverpod, Bloc, etc.)
- Keep business logic separate from UI code
- Use appropriate state management for the scope (local vs global state)

### API and Data Handling
- Handle API errors gracefully with user-friendly error messages
- Implement proper loading states for asynchronous operations
- Cache weather data appropriately to reduce unnecessary API calls
- Validate and sanitize data from external sources (weather APIs)

### Testing
- Write unit tests for business logic and utilities
- Write widget tests for custom widgets
- Test error handling and edge cases
- Mock external dependencies (APIs, services) in tests

## Weather App Specific Guidelines

### Weather Data
- Display temperature in both Celsius and Fahrenheit with user preference
- Show appropriate weather icons based on conditions
- Handle different weather conditions (sunny, rainy, cloudy, snowy, etc.)
- Display relevant metrics (humidity, wind speed, pressure, UV index, etc.)

### Location Services
- Handle location permissions properly
- Provide fallback for denied location permissions
- Allow manual location search/selection
- Cache last known location

### UI/UX
- Use weather-appropriate color schemes and themes
- Implement smooth transitions and animations
- Ensure responsive design for different screen sizes
- Support both light and dark themes
- Show loading indicators during data fetch

### Performance
- Optimize image assets (weather icons, backgrounds)
- Lazy load data where appropriate
- Implement efficient list rendering for forecasts
- Minimize unnecessary rebuilds

## Security Considerations
- Never commit API keys or secrets to the repository
- Use environment variables or secure storage for sensitive data
- Validate and sanitize all user inputs
- Use HTTPS for all API calls

## Code Review Checklist
- [ ] Code follows Dart/Flutter style guide
- [ ] No hardcoded API keys or sensitive data
- [ ] Error handling is implemented
- [ ] Loading states are shown to users
- [ ] Code is properly documented with comments where necessary
- [ ] UI is responsive and works on different screen sizes
- [ ] Tests are included for new functionality

## Common Commands
```bash
# Get dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .

# Build for Android
flutter build apk

# Build for iOS
flutter build ios

# Build for Web
flutter build web
```

## Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Flutter Widget Catalog](https://docs.flutter.dev/ui/widgets)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
