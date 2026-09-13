# NOWNOWWW - Minimalist Social Platform

NOWNOWWW is a production-ready, text-first social platform built with Flutter and Firebase.

## 🚀 Status: READY FOR LAUNCH
The application has passed its final engineering audit. All 19 screens are implemented, and the backend is fully synchronized.

### 🔑 Key Features
- **Authentication**: Email, Google, Apple, and Phone Sign-in.
- **Feed**: Distinct "Need" and "Think" tabs with real-time cloud filtering.
- **Privacy**: One-tap anonymous posting with metadata scrubbing.
- **Messaging**: End-to-end real-time DMs with typing indicators.
- **Social**: Real-time following system and trending topics.
- **Performance**: Infinite scrolling, skeleton loaders, and optimized Firestore queries.
- **Safety**: Built-in reporting and blocking logic.

## 📦 Final Steps to Launch

### 1. Store Assets
- Replace `assets/icons/app_icon.png` with your professional logo.
- Generate native icons: `dart run flutter_launcher_icons`
- Generate splash screen: `dart run flutter_native_splash:create`

### 2. Legal Documents
- The placeholders for **Terms of Service** and **Privacy Policy** are in `lib/core/routing/app_router.dart`.
- Update these strings with your official legal text before publishing.

### 3. Production Deployment
1. **Security Rules**: `firebase deploy --only firestore:rules,storage:rules`
2. **Cloud Functions**: `firebase deploy --only functions` (Requires Firebase Blaze Plan).
3. **Android Release**: `flutter build apk --release`
4. **iOS Release**: Open Xcode and follow the standard Archive & Distribute flow.

## 🛠️ Technical Stack
- **Frontend**: Flutter & Riverpod 2.0
- **Backend**: Firebase (Auth, Firestore, Messaging, Functions v2)
- **Storage**: Cloudinary (Free Image Hosting)
- **Updates**: In-app Force Update system via Upgrader.

---
**NOWNOWWW is more than an app; it's a statement on authenticity.**
