# NutriLink

Seamlessly connect surplus food from providers with beneficiaries and delivery agents through a modern, multilingual Flutter experience.

![Flutter](https://img.shields.io/badge/Flutter-3.27+-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.+-0175C2?logo=dart&logoColor=white)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-34A853)

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Architecture & Tech Stack](#architecture--tech-stack)
- [Folder Structure](#folder-structure)
- [Getting Started](#getting-started)
- [Localization](#localization)
- [Theming](#theming)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview
NutriLink is a role-based food redistribution platform built with Flutter. It empowers food providers to share surplus meals, lets beneficiaries discover and request nearby food, and enables delivery agents to manage pickups and drop-offs. The project showcases production-ready UX niceties such as guest mode, dark/light theme toggles, multilingual copy (English/French), and fully localized dashboards.

## Features
- **Multi-role experience**: Dedicated dashboards and workflows for providers, beneficiaries, delivery agents, and admins.
- **Guest access**: Explore each role without signing up, directly from the login screen.
- **Provider tools**: Add, edit, filter, and delete listings with expiry scheduling, food categories, and impact stats.
- **Beneficiary flows**: Browse localized food feeds, submit serving-specific requests, track request statuses, and save search radius preferences.
- **Delivery management**: Claim available tasks, transition through pickup/delivery states, and access detailed contact information.
- **Admin insights**: View platform-level metrics (users, listings, impact stats) via the admin dashboard.
- **Bilingual UI**: App strings and dashboards are fully localized via ARB files (English/French) with runtime toggling.
- **Dynamic theming**: Instant theme switches (light/dark/system) accessible within auth screens and persisted across the app.

## Architecture & Tech Stack
- **Flutter + Dart** for cross-platform UI.
- **Provider** for lightweight state management (`AuthProvider`, `FoodProvider`, `RequestProvider`, `DeliveryProvider`, etc.).
- **Material 3 theming** wrapped in `ThemeProvider` with custom palettes from `AppColors`.
- **Localization** through Flutter's `gen_l10n` pipeline using `app_en.arb` and `app_fr.arb`.
- **Mock services** simulate backend APIs for listings, requests, and deliveries, keeping the project self-contained.

## Folder Structure
```
lib/
├─ l10n/                  # Localization resources (ARB files)
├─ models/                # Data models (User, FoodListing, Delivery, etc.)
├─ providers/             # State management using Provider
├─ screens/
│  ├─ auth/               # Login, register, onboarding, splash
│  ├─ provider/           # Provider dashboards, add/manage/profile
│  ├─ beneficiary/        # Feed, request tracking, profile
│  ├─ delivery/           # Delivery dashboards, tasks, active/detail
│  └─ admin/              # Admin dashboard
├─ services/              # Mock data + storage helpers
├─ theme/                 # Material theme + custom colors
└─ widgets/               # Reusable UI components (cards, buttons, etc.)
```

## Getting Started
### Prerequisites
- Flutter SDK 3.27+ (`flutter --version`)
- Dart 3+
- Android Studio/Xcode or VS Code with Flutter extension

### Installation
```bash
git clone https://github.com/<your-org>/NutriLink.git
cd NutriLink
flutter pub get
```

### Run the app
```bash
flutter run    # defaults to connected device/emulator

# Example: run for Chrome
flutter run -d chrome
```

### Run static analysis & tests
```bash
flutter analyze
flutter test
```

## Localization
NutriLink ships with English (`app_en.arb`) and French (`app_fr.arb`).

1. Add/update strings in both ARB files under `lib/l10n/`.
2. Regenerate l10n outputs:
	```bash
	flutter gen-l10n
	```
3. Strings become available via `AppLocalizations.of(context)`.

## Theming
- Themes live in `lib/theme/app_theme.dart` with color tokens in `AppColors`.
- Users can switch between light/dark/system modes from auth screens (persisted via `ThemeProvider`).

## Troubleshooting
| Issue | Fix |
| --- | --- |
| `OnBackInvokedCallback is not enabled` warning on Android 13+ | Add `android:enableOnBackInvokedCallback="true"` inside `AndroidManifest.xml` application tag (already configured for release builds). |
| RenderFlex overflow during layout tweaks | Use `flutter run --profile` to spot offending widgets; most common fixes include wrapping content in `Expanded`/`Flexible` or swapping rows for `Wrap` (see `FoodListingCard`). |
| Localization not updating | Ensure `flutter gen-l10n` ran after editing ARB files and restart hot reload if necessary. |

## Contributing
1. Fork the repository and create a topic branch off `main`.
2. Keep changes focused; update or add tests where applicable.
3. Run `flutter analyze` before opening a PR.
4. Submit a pull request with screenshots/gifs for UI updates.

## License
Add your preferred license (MIT, Apache 2.0, etc.) before distributing the app. Create a `LICENSE` file at the project root so contributors know the terms.
