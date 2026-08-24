# EduFlow - Modern Flutter Learning & Course Management Platform

**EduFlow** is an enterprise-grade, full-featured online education and learning management platform built with **Flutter** following strict **Clean Architecture** and **Feature-First modularization**.

---

## 🌟 Key Features

### 🎓 For Students
- **Course Discovery**: Browse approved and published courses with search and category filtering.
- **Interactive Learning**: Stream high-definition video lectures and review integrated PDF study documents.
- **Progress Tracking**: Real-time progress monitoring per enrolled course and across all active enrollments.
- **Assessments & Quizzes**: Take course-associated quizzes with timer support, instant grading, and answer breakdowns.
- **Verifiable Certificates**: Earn and download official certificates upon achieving 100% course curriculum completion.

### 👨‍🏫 For Teachers & Instructors
- **Course Authoring**: Create, update, and manage courses with pricing, categories, and custom cover thumbnails.
- **Curriculum Builder**: Organize syllabus into structured chapters and upload multimedia lessons (MP4/WebM video lectures, PDF notes).
- **Quiz Creator**: Design interactive multi-choice quizzes and link them to chapters or full courses.
- **Student Progress Analytics**: Monitor real-time student completion rates and curriculum engagement for all authored courses.
- **Publication Workflow**: Submit courses for administrative moderation and approval.

### 🛡️ For Administrators
- **Platform Analytics**: High-level dashboard statistics (active users, course catalog volume, total quizzes, system-wide average scores).
- **Teacher Moderation**: Review pending instructor registration applications and grant teaching privileges.
- **Course Moderation**: Review curriculum submissions and approve/reject course publication.
- **User Directory Management**: Complete CRUD operations for platform users (search, role filtering, activating/deactivating, editing, and deleting accounts).

---

## 🏗️ Architecture & Project Structure

EduFlow adheres strictly to **Clean Architecture** with **Feature-First modularization**. Every domain entity is pure and decoupled from data transfer objects and UI frameworks.

```
lib/
├── core/
│   ├── app/                      # Global app initialization & dependency container
│   ├── constants/                # App colors, typography, and API endpoints
│   ├── error/                    # Custom failure and exception definitions
│   ├── networking/               # Dio HTTP client, JWT auth interceptor, token refresh
│   ├── router/                   # GoRouter configuration & role-based navigation guards
│   ├── theme/                    # Light & dark theme palettes
│   ├── usecases/                 # Base UseCase contract interfaces
│   ├── utils/                    # Either functional error handling & typedefs
│   └── widgets/                  # Application-wide reusable UI components (Buttons, Inputs, Dialogs, Cards)
│
└── features/
    ├── admin/                    # Admin dashboard, teacher approvals, course moderation, user CRUD
    ├── auth/                     # Authentication, JWT login, registration, splash & auth state
    ├── certificates/             # Certificate view, verification, download & claim
    ├── courses/                  # Course catalog, details, teacher curriculum builder, lesson player
    ├── dashboard/                # Role-tailored dashboards (Student, Teacher, Admin)
    ├── notifications/            # In-app notifications & announcement center
    ├── progress/                 # Course progress tracking, lesson completion, enrollment records
    ├── quizzes/                  # Quiz taking, question authoring, student scores & answer review
    └── settings/                 # App preferences, dark mode, offline cache, notifications
```

### Feature Module Separation
Each feature under `lib/features/<feature_name>/` contains:
- **`domain/`**: Pure entities, repository interfaces, single-responsibility use cases.
- **`data/`**: Data models (`fromJson`/`toJson`), remote HTTP/Dio datasources, local persistence, concrete repository implementations.
- **`presentation/`**: BLoC / Cubit state management, full-page screen views, and feature-specific `widgets/`.
- **`di.dart`**: Feature dependency injection registration function.

---

## 🛠️ Technology Stack

| Layer / Concern | Technology |
| :--- | :--- |
| **Framework** | Flutter 3.x (Dart 3.x) |
| **Architecture** | Flutter Clean Architecture (Feature-First) |
| **State Management** | `flutter_bloc` / BLoC pattern |
| **Dependency Injection** | `get_it` |
| **Networking** | `dio` with JWT bearer interceptor & auto token refresh |
| **Navigation** | `go_router` with declarative routing & role guards |
| **Functional Error Handling** | `dartz` / Custom `Either<Failure, T>` |
| **Typography & UI** | Google Fonts (Outfit, Plus Jakarta Sans), Material 3 |
| **Local Storage** | `shared_preferences` for JWT tokens and app settings |

---

## 🚀 Getting Started

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version >= 3.3.0)
- [Dart SDK](https://dart.dev/get-dart) (version >= 3.0.0)
- Android Studio / Xcode / VS Code with Flutter extensions

### 2. Installation
```bash
# Clone the repository
git clone https://github.com/jihanurrahman33/Education-App.git
cd Education-App

# Fetch dependencies
flutter pub get
```

### 3. Running the Application
```bash
# Run on connected device or emulator
flutter run
```

### 4. Running Static Analysis
```bash
# Verify code health and architecture compliance
flutter analyze
```

---

## 📡 Backend API Integration

The app connects to the EduFlow REST backend hosted at `http://144.79.133.208:8000`. All requests route through `/api/...` endpoints with JWT Bearer authentication.

For detailed endpoint contracts and agent procedures, refer to [`AGENTS.md`](file:///c:/Users/jihan/Documents/projects/education_app/AGENTS.md).
