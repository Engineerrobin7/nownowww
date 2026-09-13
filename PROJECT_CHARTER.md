# PROJECT CHARTER: NOWNOWWW

## 1. Project Overview
**NOWNOWWW** is a minimalist, text-first, real-time social platform designed to encourage authentic human conversations by removing traditional social media distractions (no reels, no algorithms, no influencer metrics).

## 2. Mission Statement
To create the simplest real-time platform where people can instantly express what they **NEED** or what they **THINK** and connect with other humans without friction.

## 3. SDLC Model: Agile-DevOps Hybrid
The project was developed using a modern hybrid lifecycle to ensure speed, quality, and adaptability:
- **Agile:** Iterative development with immediate pivots based on stakeholder feedback and UI/UX refinements.
- **Incremental:** Features were delivered in functional blocks (Auth -> Feed -> Interactions -> Safety -> Messaging).
- **Iterative:** Core systems (Storage, UI components) were refined through multiple cycles to reach pixel-perfection.
- **DevOps:** Infrastructure (Firebase Rules, Cloud Functions, CI/CD) was built as code and integrated into the development flow.

## 4. Technical Stack
- **Frontend:** Flutter (Latest Stable), Dart.
- **State Management:** Riverpod 2.0 (Code Generation).
- **Navigation:** GoRouter (Declarative routing with Auth guards).
- **Backend:** Firebase (Auth, Firestore, Messaging, Cloud Functions v2).
- **Image Hosting:** Cloudinary (25GB Free tier, no credit card required).
- **Observability:** Firebase Crashlytics & Analytics, custom LoggerService.
- **CI/CD:** GitHub Actions.

## 5. System Architecture
The application follows **Clean Architecture** principles:
- **Data Layer:** Firebase repositories handling network calls and local DTO mapping.
- **Domain Layer:** Immutable Freezed models and repository interfaces.
- **Presentation Layer:** Atomic widgets and state-aware Controllers (Notifiers).
- **Feature-First Structure:** Each module (auth, posts, comments, etc.) is self-contained.

## 6. Security & Moderation
- **Firestore Rules:** Multi-layered security ensuring users can only edit their own data.
- **Content Safety:** Integrated Reporting and Real-time Blocking logic.
- **Data Privacy:** Full Account Deletion flow (GDPR/Apple compliant).

## 7. Key Features Implemented
- [x] Multi-provider Auth (Email, Google).
- [x] Dynamic Profile Onboarding & Setup.
- [x] "Think" & "Need" Dual-Post System.
- [x] Threaded Comments with Author Identification.
- [x] Global Search (Users, Posts, Trending Topics).
- [x] Real-time Messaging (DMs) with unread counts.
- [x] Regex-based Mention (@) and Topic (#) Linking.
- [x] Background Notifications via Cloud Functions.
- [x] Infinite Scroll Pagination & Skeleton Shimmers.

## 8. Development Standards
- **Imports:** 100% Absolute package imports for scalability.
- **Types:** Strict null-safety and typed responses across all layers.
- **UI:** 1:1 Pixel-match with production high-fidelity mockups.
