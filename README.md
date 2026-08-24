# EduFlow — Modern Clean Architecture Education App

EduFlow is an enterprise-grade learning management application built with **Flutter**, **Clean Architecture**, and **BLoC (Business Logic Component)**. It features role-based access control for **Students**, **Teachers**, and **Administrators**, comprehensive course curriculum authoring, video/PDF lecture playback, interactive assessments, real-time progress tracking, and digital certificate generation.

---

## 🔐 Demo Credentials / Test Accounts

You can log in to explore different user roles using the pre-configured credentials below:

| Role | Username | Password | Key Permissions & Capabilities |
| :--- | :--- | :--- | :--- |
| 🎓 **Student** | `john` | `123456` | Browse courses, enroll, watch video/PDF lectures, take quizzes, view certificates |
| 👨‍🏫 **Teacher** | `teacher` | `123456` | Author courses, organize curriculum chapters/lessons, upload videos & PDFs, create quizzes |
| 🛡️ **Admin** | `admin` | `admin12345` | Platform analytics, approve instructor registrations, moderate & publish courses, manage users |

---

## 📸 Key Features & Capabilities

### 🎓 1. Student Learning Journey
* **Course Discovery:** Browse approved courses with category filtering, search, and detailed syllabus previews.
* **Instant Course Enrollment:** One-tap course enrollment synchronized with personal progress tracking.
* **Rich Media Player:** Seamless playback of video lectures (MP4), reading PDF study guides, and text lessons.
* **Progress Tracking:** Automatic lesson completion updates, course percentage counters, and progress overview.
* **Assessment Quizzes:** Timed single-choice modular quizzes with instant scoring and answer breakdowns.
* **Verified Certificates:** Automatically unlock and download official completion certificates upon reaching 100% course progress.

### 👨‍🏫 2. Teacher Course & Curriculum Studio
* **Course Builder:** Draft and configure course metadata, category tags, descriptions, and pricing.
* **Curriculum Management:** Organize content into structured chapters and lessons with reordering support.
* **Media Uploads:** Upload high-definition video lectures and PDF lecture notes via `multipart/form-data`.
* **Quiz Creator:** Create assessment quizzes attached directly to specific lessons with custom pass marks.
* **Moderation Pipeline:** Submit completed drafts for administrative quality approval.

### 🛡️ 3. Administrator Moderation & Analytics Hub
* **Dashboard Analytics:** Live statistics on registered learners, published courses, quiz results, and top enrollments.
* **Teacher Account Moderation:** Review instructor credentials and grant platform teaching privileges.
* **Course Quality Moderation:** Review submitted curriculum drafts, inspect lessons, and approve or reject submissions.
* **User Management Directory:** Full CRUD operations across all user accounts with role assignments and activation toggles.

---

## 🏗️ Technical Stack & Architecture

* **Framework:** [Flutter](https://flutter.dev) (Dart 3.13+)
* **Architecture:** Clean Architecture with Feature-First Modularization
* **State Management:** [flutter_bloc](https://pub.dev/packages/flutter_bloc) (BLoC / Cubit)
* **Dependency Injection:** [get_it](https://pub.dev/packages/get_it)
* **Networking:** [dio](https://pub.dev/packages/dio) with JWT Auth Interceptor
* **Routing:** [go_router](https://pub.dev/packages/go_router) with role-based auth guards
* **Functional Programming:** [dartz](https://pub.dev/packages/dartz) (`Either<Failure, T>`)
* **Styling & Theme:** Custom Dark Theme (`#121414` Canvas, `#F59E0B` Gold, `#10B981` Emerald)

---

## 📂 Project Directory Structure

```
lib/
├── core/
│   ├── app/                # Application entrypoint & global dependency injection
│   ├── constants/          # AppColors, ApiEndpoints, AppTheme tokens
│   ├── errors/             # Failure models and Server/Network Exceptions
│   ├── network/            # Dio ApiClient & JWT Bearer Interceptors
│   ├── routes/             # GoRouter configuration & role guards
│   ├── usecases/           # Generic UseCase<Type, Params> interface
│   ├── utils/              # Token manager & storage helpers
│   └── widgets/            # Application-wide reusable UI components
└── features/
    ├── admin/              # Admin dashboard, moderation hub & user directory
    ├── auth/               # Registration, Login, Profile & JWT session state
    ├── certificates/       # Digital certificate viewer & PDF generator
    ├── courses/            # Catalog, curriculum manager, lesson player & builder
    ├── dashboard/          # Role-tailored home dashboards
    ├── progress/           # Lesson completion & progress percentage tracking
    └── quizzes/            # Quiz taking, question authoring & score evaluations
```

---

## 🚀 Getting Started

### 1. Prerequisites
* [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.13 or higher)
* [Dart SDK](https://dart.dev/get-dart) (v3.0 or higher)

### 2. Installation
```bash
# Clone the repository
git clone https://github.com/jihanurrahman33/Education-App.git
cd Education-App

# Install dependencies
flutter pub get

# Generate launcher icons & native splash screen
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

### 3. Running the Application
```bash
# Run on connected device or simulator
flutter run

# Run on specific platform
flutter run -d chrome
flutter run -d windows
```

### 4. Running Tests & Static Analysis
```bash
# Run all unit and widget tests
flutter test

# Run static code analysis
flutter analyze
```

---

## 📚 Detailed Documentation

Detailed technical documentation is available in the [`docs/`](docs/) directory:
* **[API Specification](docs/API_DOCUMENTATION.md)** — Complete endpoint catalog, request payloads, and response models.
* **[Architecture Guide](docs/ARCHITECTURE.md)** — Clean Architecture layer responsibilities and GetIt wiring.
* **[User Workflows](docs/WORKFLOWS.md)** — Step-by-step user journeys and sequence diagrams.
* **[Design System](docs/DESIGN_SYSTEM.md)** — Color palette tokens, typography rules, and custom widgets.

---

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.
