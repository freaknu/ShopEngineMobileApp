# 🛍️ ShopEngine - Flutter eCommerce Mobile App

A **production-ready** Flutter eCommerce application featuring real-time reviews, voice search, smart notifications, and complete order management. Built with clean architecture, BLoC state management, and Firebase integration.

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-00B4AB?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![GitHub](https://img.shields.io/badge/GitHub-freaknu-black?logo=github)](https://github.com/freaknu/ShopEngineMobileApp)

---

## 📱 Screenshots & Features

### ✨ Core Features

- 🛒 **Complete Product Catalog** - Browse products with advanced filtering and sorting
- 🎤 **Voice Search** - Hands-free product search using speech-to-text
- ⭐ **Real-time Review System** - View and post reviews with calculated average ratings
- 🔔 **Smart Notifications** - Push notifications with read/unread tracking
- 📦 **Order Management** - Complete order lifecycle tracking and management
- 🎨 **Beautiful UI** - Modern glassmorphic design with smooth animations
- 🔐 **Secure Authentication** - OTP-based login and account creation
- 💳 **Payment Integration** - Secure payment gateway integration
- 📍 **Address Management** - Multiple address support with default selection
- 🛍️ **Shopping Cart** - Add/remove products with quantity management
- ⏰ **IST Timezone Support** - Accurate timestamps for reviews and notifications

---

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **State Management**: BLoC (flutter_bloc)
- **Dependency Injection**: GetIt
- **Navigation**: GetX (get)
- **HTTP Client**: Dio

### Backend & Services
- **API**: RESTful API with Node.js/Express
- **Authentication**: Firebase Auth + OTP
- **Database**: Firebase Firestore
- **Push Notifications**: Firebase Cloud Messaging
- **Storage**: Firebase Storage

### Additional Libraries
- **Local Storage**: SharedPreferences
- **Voice Recognition**: speech_to_text
- **Permissions**: permission_handler
- **Loading States**: Shimmer animations
- **Date/Time**: intl package
- **UI Components**: Material Design 3

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.x or higher
- Dart SDK 3.x or higher
- Android SDK (for Android development)
- Xcode (for iOS development)
- Firebase Project setup

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/freaknu/ShopEngineMobileApp.git
cd ShopEngineMobileApp
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Firebase**
- Add `google-services.json` for Android
- Add `GoogleService-Info.plist` for iOS
- Update Firebase configuration in `lib/firebase_options.dart`

4. **Run the app**
```bash
flutter run
```

### For Release Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── auth/                    # Authentication & token management
│   ├── bloc/                    # Auth status BLoC
│   ├── constants/
│   │   ├── Api/                 # API endpoints & HTTP client
│   │   ├── theme/               # App colors & theme
│   │   └── widgets/             # Reusable widgets
│   ├── di/                      # Dependency injection setup
│   └── usecase/                 # Base usecase class
│
├── features/
│   ├── auth/                    # Authentication feature
│   │   ├── data/                # API & local data sources
│   │   ├── domain/              # Entities & repositories
│   │   └── presentation/        # Pages & widgets
│   │
│   ├── homepage/                # Home & product discovery
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── product/                 # Product detail page
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── review/                  # Review system
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── cart/                    # Shopping cart
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── order/                   # Order management
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── notification/            # Notification system
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── userdetails/             # User profile & addresses
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── main.dart                    # App entry point
└── firebase_options.dart        # Firebase configuration
```

---

## 🏗️ Architecture

This project follows **Clean Architecture** principles with separation of concerns:

```
Presentation Layer (BLoC + UI)
         ↓
Domain Layer (Entities + Repositories + Usecases)
         ↓
Data Layer (Models + Datasources + Repository Implementation)
```

### State Management Pattern
- **BLoC** (Business Logic Component) for complex features
- **Builder** for simple UI updates
- **Consumer** for side effects

### API Communication
- Centralized Dio client with interceptors
- Token-based authentication
- Error handling & retry logic
- Request/response logging in development

---

## 🔑 Key Features Deep Dive

### 🎤 Voice Search
- Speech-to-text conversion
- Runtime permission handling
- Real-time search results
- Works offline (falls back to text search)

### ⭐ Review System
- Dynamic average rating calculation
- IST timezone support for timestamps
- Review pagination (5 recent + all reviews page)
- User authentication validation
- Sorting by creation date (newest first)

### 🔔 Smart Notifications
- Firebase Cloud Messaging integration
- Read/unread status tracking
- Custom notification icons
- Tap-to-navigate functionality
- Persistent notification storage

### 🛒 Shopping Cart
- Add/remove products
- Quantity management
- Price calculation with discounts
- Address selection
- Order placement

---

## 🔐 Security Features

- ✅ Secure token storage with SharedPreferences
- ✅ OTP-based authentication
- ✅ API key protection (.gitignore)
- ✅ Environment variable management
- ✅ HTTPS only communication
- ✅ Permission-based access control

---

## 📦 Download APK

Download the latest version from Google Drive:
[ShopEngine APK](https://drive.google.com/file/d/1kc_KtMHJIsG0n6rSkfpvEYK3X5h80t0h/view?usp=sharing)

### Installation Instructions
1. Download the APK file
2. Enable "Install from Unknown Sources" in Settings
3. Open the APK file and tap Install
4. Launch the app and start shopping!

---

## 📝 Git Workflow

### Cloning & Setup
```bash
git clone https://github.com/freaknu/ShopEngineMobileApp.git
cd ShopEngineMobileApp
```

### Making Changes
```bash
# Create a feature branch
git checkout -b feature/your-feature

# Commit changes
git add .
git commit -m "Add your feature description"

# Push to GitHub
git push origin feature/your-feature
```

### Important
- Files in `.gitignore` are NOT committed (API keys, Firebase configs, etc.)
- Always pull before starting new work
- Write meaningful commit messages

---

## 🐛 Troubleshooting

### Common Issues

**Issue**: Firebase not initializing
- **Solution**: Ensure `google-services.json` and `GoogleService-Info.plist` are properly placed

**Issue**: Voice search not working
- **Solution**: Check microphone permissions in device settings

**Issue**: Notifications not appearing
- **Solution**: Verify Firebase setup and device notification permissions

**Issue**: Build fails with dependency conflicts
- **Solution**: Run `flutter clean` then `flutter pub get`

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**pk2239** (freaknu)
- 📧 Email: pk2239.29.jnv@gmail.com
- 🐙 GitHub: [@freaknu](https://github.com/freaknu)
- 🔗 LinkedIn: [pk2239](https://linkedin.com/in/pk2239)

---

## 📞 Support & Contact

For questions or issues:
- 📧 Email: pk2239.29.jnv@gmail.com
- 🐛 GitHub Issues: [Report an issue](https://github.com/freaknu/ShopEngineMobileApp/issues)
- 💬 Discussions: [Ask a question](https://github.com/freaknu/ShopEngineMobileApp/discussions)

---

## 🙏 Acknowledgments

- Flutter & Dart communities
- Firebase for excellent backend services
- BLoC pattern for state management best practices
- All contributors and testers

---

## 📊 Project Stats

- **Lines of Code**: 19,000+
- **Files**: 370+
- **Features**: 10+
- **Platforms**: Android, iOS, Web, Linux, macOS, Windows
- **Development Time**: Production-ready

---

## 🚀 Roadmap

- [ ] Add payment gateway (Stripe/PayPal)
- [ ] Wishlist feature
- [ ] Product recommendations
- [ ] Advanced search filters
- [ ] User profile customization
- [ ] Push notification scheduling
- [ ] Multi-language support
- [ ] Dark theme

---

**Made with ❤️ using Flutter**

⭐ Star this repository if you found it helpful!
