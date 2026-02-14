# TotalX Machine Test - Flutter Application

A Flutter application demonstrating clean architecture, OTP authentication, and user management with persistent storage.

## 📱 Project Overview

This project was developed as a machine test for TotalX, showcasing a complete authentication flow with OTP verification and a user management system. The application follows clean architecture principles with proper separation of concerns.

## ✨ Features

### Authentication
- **Phone Number Authentication**: Secure login using phone number
- **OTP Verification**: MSG91 integration for OTP delivery
- **Session Persistence**: Auto-login on app restart
- **Secure Logout**: Clear session data on logout

### User Management
- **Add Users**: Create users with name, age, and profile picture
- **Image Upload**: Support for both camera and gallery
- **Search Functionality**: Real-time search by name
- **Age Filtering**: Filter users by age groups (60+, below 60)
- **Lazy Loading**: Efficient pagination for large user lists
- **Data Isolation**: Each phone number has separate user data

### UI/UX
- **Clean Design**: Modern, intuitive interface
- **Responsive Layout**: Adapts to different screen sizes
- **Loading States**: Visual feedback during operations
- **Error Handling**: User-friendly error messages
- **Empty States**: Helpful messages when no data exists

## 🏗️ Architecture

The project follows **Clean Architecture** principles with clear separation of layers:

```
lib/
├── core/
│   ├── constants/        # API constants, storage keys
│   ├── di/              # Dependency injection (GetIt)
│   ├── error/           # Error handling
│   ├── services/        # Core services (Auth)
│   ├── theme/           # App theme and colors
│   └── usecases/        # Base use case
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/    # Local & Remote data sources
│   │   │   ├── models/         # Data models
│   │   │   └── repositories/   # Repository implementations
│   │   ├── domain/
│   │   │   ├── entities/       # Business entities
│   │   │   ├── repositories/   # Repository interfaces
│   │   │   └── usecases/       # Business logic
│   │   └── presentation/
│   │       ├── providers/      # State management
│   │       ├── screens/        # UI screens
│   │       └── widgets/        # Reusable widgets
│   └── home/
│       └── [similar structure]
└── main.dart
```

## 🔧 Technologies Used

- **Flutter SDK**: ^3.11.0
- **State Management**: Provider
- **Dependency Injection**: GetIt
- **Local Storage**: Hive, SharedPreferences
- **OTP Service**: MSG91 SDK
- **Image Picker**: image_picker
- **HTTP**: http package

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_dotenv: ^5.1.0
  shared_preferences: ^2.5.4
  sendotp_flutter_sdk: ^0.0.2
  provider: ^6.1.5+1
  http: ^1.2.2
  get_it: ^8.0.3
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  image_picker: ^1.2.1
  path_provider: ^2.1.5
  uuid: ^4.5.2
  intl: ^0.20.2
  equatable: ^2.0.8
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.11.0 or higher)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/0xsreejith/totalx_mechine_test.git
   cd totalx_mechine_test
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up environment variables**
   
   Create a `.env` file in the root directory:
   ```env
   WIDGET_ID=your_msg91_widget_id
   AUTH_TOKEN=your_msg91_auth_token
   SERVER_AUTH_KEY=your_msg91_server_auth_key
   ```

4. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Flow

1. **Launch**: App checks for existing session
2. **Login**: Enter 10-digit phone number
3. **OTP Verification**: Enter 6-digit OTP
4. **Home Screen**: View and manage users
5. **Add User**: Create new user with details
6. **Search/Filter**: Find users easily
7. **Logout**: Clear session and return to login

## 🔐 Authentication Flow

```
Login Screen → Enter Phone Number → Send OTP
     ↓
OTP Screen → Enter OTP → Verify
     ↓
Home Screen (Session Saved)
     ↓
App Restart → Auto Login (if session exists)
```

## 💾 Data Persistence

- **Session Data**: SharedPreferences (phone number, access token, login status)
- **User Data**: Hive (phone-specific boxes for data isolation)
- **Images**: Local file system

## 🎨 Design Patterns

- **Repository Pattern**: Data layer abstraction
- **Provider Pattern**: State management
- **Factory Pattern**: Dependency injection
- **Singleton Pattern**: Service instances

## 📝 OTP Delivery Note (Important)

**MSG91 OTP integration is working correctly and API responses return success.**

However, due to **TRAI DLT telecom regulations in India**, SMS delivery works only for:
- ✅ Whitelisted numbers
- ✅ Approved DLT templates

**This limitation is related to SMS provider restrictions and not Flutter implementation.**

### Testing OTP Flow

The app includes a **Demo Mode** that allows testing without actual SMS delivery:
- Demo phone numbers use fixed OTP codes
- All API calls are made to MSG91 (visible in logs)
- OTP verification works with demo credentials

Check the console logs to see:
```
🔵 [OTP] Sending OTP to: 919876543210
✅ [OTP] OTP sent successfully
   ReqId: abc123xyz
   Demo OTP: 123456
```

## 🧪 Testing

### Demo Credentials
Demo mode is enabled by default for testing purposes. Check `lib/core/constants/demo_credentials.dart` for demo phone numbers and OTP codes.

### Test Scenarios
1. ✅ Login with valid phone number
2. ✅ OTP verification
3. ✅ Session persistence
4. ✅ Add user with image
5. ✅ Search functionality
6. ✅ Age filtering
7. ✅ Logout and re-login
8. ✅ Data isolation between accounts

## 📊 Key Features Implementation

### Clean Code Practices
- ✅ Separation of concerns
- ✅ Reusable widgets
- ✅ Proper error handling
- ✅ Consistent naming conventions
- ✅ Comprehensive logging

### Performance Optimizations
- ✅ Lazy loading for user lists
- ✅ Image compression
- ✅ Efficient state management
- ✅ Minimal rebuilds

### Security
- ✅ Secure token storage
- ✅ Session management
- ✅ Data isolation per user
- ✅ Input validation

## 🐛 Known Issues

None at the moment. All features are working as expected.

## 📄 License

This project is created for TotalX machine test evaluation.

## 📞 Contact

For any queries regarding this project, please contact through the provided channels.

---

**Note**: This is a demonstration project showcasing Flutter development skills, clean architecture, and best practices in mobile app development.
