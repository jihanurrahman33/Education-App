# EduFlow — Software Architecture & Engineering Standards

EduFlow is built on **Flutter Clean Architecture** with **Feature-First modularization**, ensuring separation of concerns, testability, maintainability, and horizontal scalability.

---

## 1. High-Level Architectural Overview

```mermaid
graph TD
    subgraph Presentation Layer
        UI[Screens & Widgets] -->|dispatches events| Bloc[BLoC State Controllers]
        Bloc -->|emits states| UI
    end

    subgraph Domain Layer
        Bloc -->|executes| UseCases[Single-Responsibility UseCases]
        UseCases -->|depends on contract| Repositories[Abstract Repository Contracts]
        UseCases -->|uses| Entities[Pure Domain Entities]
    end

    subgraph Data Layer
        Repositories -->|implements| RepoImpl[Repository Implementations]
        RepoImpl -->|calls| RemoteDS[Remote DataSource (Dio)]
        RepoImpl -->|calls| LocalDS[Local DataSource (SharedPreferences)]
        RemoteDS -->|serializes| Models[Data Models (DTOs)]
        LocalDS -->|caches| Models
    end
```

---

## 2. Directory & Modularization Standards

Every feature in [`lib/features/`](file:///c:/Users/jihan/Documents/projects/education_app/lib/features/) is organized into three distinct layers:

```
lib/features/<feature_name>/
├── domain/
│   ├── entities/       # Pure immutable Dart models (Equatable)
│   ├── repositories/   # Abstract repository contracts (ResultFuture / ResultVoid)
│   └── usecases/       # Single-responsibility use cases (implements UseCase<Type, Params>)
├── data/
│   ├── models/         # Data transfer objects with fromJson() / toJson() mapping
│   ├── datasources/    # Remote HTTP (Dio) & local persistence (SharedPreferences) datasources
│   └── repositories/   # Concrete repository implementations handling exceptions -> failures
├── presentation/
│   ├── bloc/ or cubit/ # State management controllers (Events, States, BLoCs)
│   ├── screens/        # Full-page UI views
│   └── widgets/        # Feature-specific reusable UI components
└── di.dart             # Feature-level GetIt dependency injection registrar
```

---

## 3. Layer Responsibilities

### A. Domain Layer (Pure Business Logic)
- **Zero External Framework Dependencies:** The domain layer contains no Flutter, Dio, or platform-specific packages (only Dart and Equatable/dartz).
- **Entities:** Immutable domain models representing business concepts.
- **Repository Contracts:** Abstract definitions of data contracts returning `Either<Failure, T>`.
- **Use Cases:** Atomic business actions implementing the `UseCase<Type, Params>` interface.

### B. Data Layer (Data Retrieval & Serialization)
- **Models:** Subclasses of domain entities containing `fromJson` and `toJson` serialization.
- **Data Sources:** Direct network HTTP calls (Dio with `AuthInterceptor`) and local storage operations.
- **Repository Implementations:** Maps exceptions (`DioException`, `ServerException`) to domain failures (`ServerFailure`, `NetworkFailure`, `UnauthorizedFailure`).

### C. Presentation Layer (UI & State Management)
- **BLoC (Business Logic Component):** Event-driven state machines managing UI states (`initial`, `loading`, `loaded`/`success`, `error`/`failure`).
- **Screens:** Responsive, accessible Flutter views that listen to BLoC states via `BlocConsumer` or `BlocBuilder`.
- **Widgets:** Reusable modular subcomponents extracted from full screens.

---

## 4. Dependency Injection (GetIt)

Dependencies are registered modularly via each feature's `di.dart` and orchestrated in [`lib/core/app/injection_container.dart`](file:///c:/Users/jihan/Documents/projects/education_app/lib/core/app/injection_container.dart):

```dart
Future<void> initGlobalDependencies() async {
  // 1. Core Services (Dio, SharedPreferences, Interceptors)
  await initCoreDependencies();

  // 2. Feature Dependencies
  await initAuthFeature();
  await initCoursesFeature();
  await initQuizzesFeature();
  await initProgressFeature();
  await initCertificatesFeature();
  await initAdminFeature();
}
```

---

## 5. Functional Error Handling (`Either<Failure, T>`)

EduFlow utilizes the functional `dartz` pattern:
- **`ResultFuture<T>`:** `Future<Either<Failure, T>>`
- **`ResultVoid`:** `Future<Either<Failure, void>>`

Repository implementations guarantee that errors are caught and transformed into domain `Failure` instances so UI screens never crash or experience unhandled runtime exceptions.

---

## 6. Declarative Routing (`GoRouter`)

Routing is configured declaratively in [`lib/core/routes/app_router.dart`](file:///c:/Users/jihan/Documents/projects/education_app/lib/core/routes/app_router.dart):
- **Role-Based Guards:** Automatically redirects unauthenticated users to `/login` and non-admin users attempting to access `/admin/...`.
- **Deep Linking:** Supports direct URL paths for web, desktop, and mobile forms (`/courses/:id`, `/learning/:courseId/lesson/:lessonId`, `/certificates/:id`).
