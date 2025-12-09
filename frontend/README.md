# Ethical AI Credit Scoring - Frontend (Flutter)

This repository contains the Flutter frontend for the Ethical AI Credit Scoring demo application.

Quick start

1. Install Flutter (stable channel) and ensure `flutter` is on your PATH.
2. From the project root run:

```powershell
flutter pub get
flutter run -d chrome
```

Run analyzer:

```powershell
flutter analyze
```

Run tests:

```powershell
flutter test
```

Notes

- Lottie placeholder assets are included in `assets/lottie`. Replace them with real Lottie JSONs for a richer onboarding experience.
- API service classes are stubs located in `lib/src/services/`. Replace with real HTTP logic when back-end endpoints are available.
- Theme tokens: uses Material 3 color tokens. Some deprecation suggestions may appear for old tokens; we keep the modern tokens.
