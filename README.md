# TugendeApp - Community-Driven Ride-Sharing Platform

TugendeApp is a comprehensive Flutter mobile application that provides a community-driven ride-sharing platform designed to help Rwandan's daily commuters and students find safe, affordable, and reliable rides by connecting with nearby drivers or fellow riders.

## 🚗 Features

### Core Functionality
- **User Authentication**: Complete registration flow with phone number verification, OTP confirmation, and personal details setup
- **Role-Based Access**: Support for both riders and drivers with role selection during onboarding
- **Google Sign-In Integration**: Quick authentication option using Google accounts
- **Profile Management**: Comprehensive user profile editing with avatar, personal information, and preferences
- **Real-Time Ride Booking**: Interactive map-based ride booking with location selection
- **Ride History**: Track and view past rides and activities
- **Promotional System**: Apply promo codes and access special offers
- **FAQ Support**: Built-in help system with categorized frequently asked questions

### User Interface
- **Modern Design**: Clean, intuitive interface with light/dark theme support
- **Tab-Based Navigation**: Easy access to Home, Bookings, Activity, Promos, and Profile sections
- **Interactive Maps**: Google Maps integration for location selection and ride tracking
- **Responsive Layout**: Optimized for various screen sizes and orientations

### Technical Features
- **State Management**: Riverpod for efficient state management
- **Firebase Integration**: Authentication, Firestore database, and cloud storage
- **Real-Time Updates**: Live ride status and location updates
- **Offline Support**: Core features work with limited connectivity

## 📱 Screenshots

The app includes various screens for:
- Splash and Welcome screens with onboarding flow
- Phone input and OTP verification
- Personal details and role selection
- Home dashboard with ride statistics
- Interactive booking with map integration
- Profile management and settings

## 🛠️ Tech Stack

- **Framework**: Flutter 3.7.2+
- **Language**: Dart
- **State Management**: Riverpod (flutter_riverpod, hooks_riverpod)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **Maps**: Google Maps Flutter
- **UI Components**: Material Design 3
- **Authentication**: Firebase Auth + Google Sign-In
- **Storage**: SharedPreferences for local data

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: Version 3.7.2 or higher
- **Dart SDK**: Included with Flutter
- **Android Studio** or **VS Code** with Flutter extensions
- **Xcode** (for iOS development on macOS)
- **Git** for version control
- **Firebase CLI** (optional, for Firebase management)

### Platform-Specific Requirements

#### Android
- Android SDK (API level 21+)
- Android device or emulator running Android 5.0+

#### iOS
- iOS 11.0+
- Valid Apple Developer account (for device testing)
- Xcode 12.0+

## 🚀 Installation & Setup

### 1. Clone the Repository
```bash
git clone https://github.com/degide/tugende.git
cd tugende
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Firebase Configuration

#### Android Setup
1. Download `google-services.json` from your Firebase project
2. Place it in `android/app/google-services.json`
3. The file is already configured in the project

#### iOS Setup
1. Download `GoogleService-Info.plist` from your Firebase project
2. Add it to the iOS project in Xcode under `ios/Runner/`

#### Web Setup (if needed)
1. Add your Firebase web configuration to `web/index.html`

### 4. Google Maps API Setup

#### Android
1. Get a Google Maps API key from Google Cloud Console
2. The key is already configured in `android/app/src/main/AndroidManifest.xml`
3. Replace with your own API key if needed

#### iOS
1. Add your Google Maps API key to `ios/Runner/AppDelegate.swift`
2. The key is already configured in the file
3. Replace with your own API key if needed

### 5. Environment Configuration

Create a `.env` file in the root directory (optional):
```env
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
FIREBASE_PROJECT_ID=tugende-14fee
```

## 🏃‍♂️ Running the Application

### Development Mode
```bash
# Run on connected device/emulator
flutter run

# Run with specific flavor (if configured)
flutter run --flavor development

# Run in debug mode with hot reload
flutter run --debug
```

### Platform-Specific Commands
```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d web-server --web-port 8080
```

### Release Mode
```bash
# Build APK for Android
flutter build apk --release

# Build App Bundle for Android
flutter build appbundle --release

# Build for iOS
flutter build ios --release
```

## 🧪 Testing

### Run Unit Tests
```bash
flutter test
```

### Run Widget Tests
```bash
flutter test test/widget_test.dart
```

### Run Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## 📁 Project Structure

```
lib/
├── main.dart                          # Application entry point
├── firebase_options.dart              # Firebase configuration
├── config/
│   ├── routes_config.dart             # App routing configuration
│   └── theme_config.dart              # App theme configuration
├── providers/
│   └── theme_provider.dart            # Theme state management
└── screens/
    ├── splash_screen.dart             # App splash screen
    ├── welcome_screen.dart            # Onboarding screens
    ├── phone_input_screen.dart        # Phone number input
    ├── otp_verification_screen.dart   # OTP verification
    ├── personal_details_screen.dart   # User details input
    ├── email_verification_screen.dart # Email verification
    ├── role_selection_screen.dart     # Driver/Rider selection
    ├── login_screen.dart              # User login
    ├── home_screen.dart               # Main app home
    ├── edit_profile_screen.dart       # Profile editing
    ├── faqs_screen.dart               # FAQ support
    ├── redeem_promo_screen.dart       # Promo code redemption
    ├── verification_screen.dart       # Account verification
    └── tabs/
        ├── home_tab.dart              # Home dashboard
        ├── bookings_tab.dart          # Ride booking with maps
        ├── activity_tab.dart          # Ride history
        ├── promos_tab.dart            # Promotional offers
        └── profile_tab.dart           # User profile
```

## 🔧 Configuration

### Theme Configuration
The app supports both light and dark themes. Configure themes in:
- `lib/config/theme_config.dart`
- `lib/providers/theme_provider.dart`

### Routes Configuration
All app routes are defined in:
- `lib/config/routes_config.dart`

### Firebase Configuration
Firebase settings are in:
- `lib/firebase_options.dart`
- `firebase.json`

## 📱 Key Dependencies

### Core Dependencies
```yaml
flutter_riverpod: ^2.6.1          # State management
hooks_riverpod: ^2.6.1            # Hooks for Riverpod
firebase_core: ^3.15.2            # Firebase core
firebase_auth: ^5.7.0             # Firebase authentication
cloud_firestore: ^5.6.12          # Firestore database
google_maps_flutter: ^2.12.3      # Google Maps
google_sign_in: ^7.1.1            # Google authentication
shared_preferences: ^2.0.15       # Local storage
carousel_slider: ^5.0.0           # Image carousel
font_awesome_flutter: ^10.7.0     # Font Awesome icons
```

### Development Dependencies
```yaml
flutter_test:                     # Testing framework
flutter_lints: ^5.0.0            # Linting rules
riverpod_generator: ^2.6.3       # Code generation for Riverpod
riverpod_lint: ^2.6.3            # Linting for Riverpod
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Firebase Configuration Error
```bash
Error: Firebase project not configured
```
**Solution**: Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are properly placed and configured.

#### 2. Google Maps Not Loading
```bash
Error: Google Maps API key not valid
```
**Solution**: 
- Verify your Google Maps API key is correct
- Enable required APIs in Google Cloud Console
- Check platform-specific configurations

#### 3. Build Failures
```bash
Error: Gradle build failed
```
**Solution**:
```bash
flutter clean
flutter pub get
flutter build apk
```

#### 4. iOS Build Issues
```bash
Error: CocoaPods not installed
```
**Solution**:
```bash
sudo gem install cocoapods
cd ios && pod install
```

### Getting Help

1. **Check Flutter Doctor**: `flutter doctor`
2. **Clear Cache**: `flutter clean && flutter pub get`
3. **Update Dependencies**: `flutter pub upgrade`
4. **Check Logs**: `flutter logs`

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit your changes**: `git commit -m 'Add some amazing feature'`
4. **Push to the branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

### Development Guidelines

- Follow Dart/Flutter coding conventions
- Write tests for new features
- Update documentation as needed
- Use meaningful commit messages
- Ensure code passes linting: `flutter analyze`

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:

- **Email**: support@tugendeapp.com
- **GitHub Issues**: [Create an issue](https://github.com/degide/tugende/issues)
- **Documentation**: [Flutter Documentation](https://docs.flutter.dev/)

## 🗺️ Roadmap

### Upcoming Features
- [ ] Real-time chat between riders and drivers
- [ ] Payment integration (Mobile Money, Card payments)
- [ ] Advanced ride matching algorithms
- [ ] Driver rating and review system
- [ ] Push notifications for ride updates
- [ ] Offline mode improvements
- [ ] Multi-language support

### Version History
- **v1.0.0** - Initial release with core features
- **Current**: Development version with enhanced UI and Firebase integration

## 🙏 Acknowledgments

- **Flutter Team** for the amazing framework
- **Firebase** for backend services
- **Google Maps** for mapping services
- **Riverpod** for state management
- **Contributors** who helped build this project

---

**Made with ❤️ using Flutter**

*TugendeApp - Making ride-sharing accessible for everyone*
