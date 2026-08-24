# EduFlow — AI Agent & Engineering Standards Guide

Welcome to the **EduFlow** codebase. This document establishes the architectural standards, API contracts, workflow procedures, and contribution rules for AI coding agents and software engineers working on this application.

---

## 1. Project Architecture & Standards

EduFlow strictly follows **Flutter Clean Architecture** with **Feature-First modularization**.

### Feature Folder Directory Convention
Every feature located under [`lib/features/<feature_name>/`](file:///c:/Users/jihan/Documents/projects/education_app/lib/features/) must maintain the following separation:
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
└── di.dart             # GetIt dependency injection initialization function for the feature
```

### Global Custom Widgets Rule
- Global reusable components reside in [`lib/core/widgets/`](file:///c:/Users/jihan/Documents/projects/education_app/lib/core/widgets/).
- **DO NOT** delete or modify the global widgets folder as it holds application-wide design system elements.
- Always use feature-specific `presentation/widgets/` for component extraction within a given feature to keep screens modular and reusable.

---

## 2. API Endpoints & Contract Catalog

The backend server is hosted at `http://144.79.133.208:8000`. All endpoints MUST use the `/api/...` path prefix.

### A. Authentication
| Method | Endpoint | Description | Auth Required |
| :--- | :--- | :--- | :---: |
| `POST` | `/api/auth/register/` | Register new student or teacher | No |
| `POST` | `/api/auth/login/` | User login returning JWT tokens (`access`, `refresh`) & user record | No |
| `GET` | `/api/auth/me/` | Fetch authenticated user profile | Yes (`Bearer`) |
| `POST` | `/api/auth/refresh/` | Refresh expired access token | No |

### B. Courses & Curriculum
| Method | Endpoint | Description | Role / Auth |
| :--- | :--- | :--- | :---: |
| `GET` | `/api/courses/courses/` | List all courses (query: `page`, `category`, `search`) | Authenticated |
| `GET` | `/api/courses/courses/approved/` | List approved courses for students (query: `page`) | Authenticated |
| `GET` | `/api/courses/courses/my-courses/` | List courses created by the current teacher (query: `page`) | Teacher / Admin |
| `POST` | `/api/courses/courses/` | Create a new course (`title`, `description`, `is_published`) | Teacher / Admin |
| `GET` | `/api/courses/courses/{id}/` | Get full course details with chapters & nested lessons | Authenticated |
| `PUT` | `/api/courses/courses/{id}/` | Full update course details | Teacher (Owner) / Admin |
| `PATCH` | `/api/courses/courses/{id}/` | Partial update course details | Teacher (Owner) / Admin |
| `DELETE` | `/api/courses/courses/{id}/` | Delete a course | Teacher (Owner) / Admin |
| `POST` | `/api/courses/courses/{id}/toggle-publish/` | Toggle course publish / submission status | Teacher (Owner) / Admin |
| `GET` | `/api/courses/chapters/` | List chapters (query: `course`, `page`) | Authenticated |
| `GET` | `/api/courses/chapters/{id}/` | Get single chapter details with lessons | Authenticated |
| `POST` | `/api/courses/chapters/` | Create chapter (`course`, `title`, `order`) | Teacher / Admin |
| `PUT` | `/api/courses/chapters/{id}/` | Full update chapter (`course`, `title`, `order`) | Teacher / Admin |
| `PATCH` | `/api/courses/chapters/{id}/` | Partial update chapter (`title`, `order`) | Teacher / Admin |
| `DELETE` | `/api/courses/chapters/{id}/` | Delete chapter | Teacher / Admin |
| `GET` | `/api/courses/lessons/` | List lessons (query: `chapter`, `page`) | Authenticated |
| `GET` | `/api/courses/lessons/{id}/` | Get single lesson details | Authenticated |
| `POST` | `/api/courses/lessons/` | Create lesson (supports multipart `video_file`/`pdf_file` or text) | Teacher / Admin |
| `PUT` | `/api/courses/lessons/{id}/` | Full update lesson | Teacher / Admin |
| `PATCH` | `/api/courses/lessons/{id}/` | Partial update lesson / upload media files | Teacher / Admin |
| `DELETE` | `/api/courses/lessons/{id}/` | Delete lesson | Teacher / Admin |

### C. Quizzes & Assessments
| Method | Endpoint | Description | Role / Auth |
| :--- | :--- | :--- | :---: |
| `POST` | `/api/quizzes/quizzes/` | Create quiz for a course | Teacher / Admin |
| `POST` | `/api/quizzes/questions/` | Create questions with choice answers | Teacher / Admin |
| `GET` | `/api/quizzes/quizzes/{id}/take/` | Student take quiz (answers masked) | Student |
| `POST` | `/api/quizzes/quizzes/{id}/submit/` | Submit quiz responses → calculate score | Student |
| `GET` | `/api/quizzes/quizzes/my-results/` | Student retrieve personal quiz submission history | Student |
| `GET` | `/api/quizzes/quizzes/{id}/results/` | Teacher review all student quiz results | Teacher / Admin |

### D. Progress & Certification
| Method | Endpoint | Description | Role / Auth |
| :--- | :--- | :--- | :---: |
| `POST` | `/api/progress/enroll/` | Enroll student into a course (`course_id`) | Student |
| `GET` | `/api/progress/enrollments/` | List student active course enrollments (query: `page`) | Student |
| `POST` | `/api/progress/complete/` | Mark lesson complete (`lesson`) | Student |
| `GET` | `/api/progress/completed/` | List completed lessons history (query: `page`) | Student |
| `GET` | `/api/progress/course/{id}/` | Course progress percentage & lesson states | Student |
| `GET` | `/api/progress/my-progress/` | Overview of all enrolled courses progress | Student |
| `POST` | `/api/progress/certificate/{course_id}/` | Generate certificate upon 100% course completion | Student |
| `GET` | `/api/progress/certificates/` | Retrieve student earned certificates list (query: `page`) | Student |
| `GET` | `/api/progress/teacher/course/{course_id}/students/` | View enrolled students progress for a course | Teacher / Admin |

### E. Admin Panel
| Method | Endpoint | Description | Role / Auth |
| :--- | :--- | :--- | :---: |
| `GET` | `/api/admin-panel/dashboard/` | Platform statistics (users, courses, quizzes, avg score) | Admin |
| `GET` | `/api/admin-panel/top-courses/` | Leaderboard of top enrolled courses | Admin |
| `GET` | `/api/admin-panel/users/` | User directory (search, role filters, pagination) | Admin |
| `POST` | `/api/admin-panel/users/` | Create user account directly | Admin |
| `GET` | `/api/admin-panel/users/{id}/` | Retrieve single user details | Admin |
| `PUT` | `/api/admin-panel/users/{id}/` | Full update user profile | Admin |
| `PATCH` | `/api/admin-panel/users/{id}/` | Partial update user (e.g. toggle active/inactive) | Admin |
| `DELETE` | `/api/admin-panel/users/{id}/` | Permanently delete user record | Admin |
| `GET` | `/api/admin-panel/teachers/pending/` | List teachers awaiting platform approval | Admin |
| `POST` | `/api/admin-panel/teachers/{id}/approve/` | Approve teacher account | Admin |
| `GET` | `/api/admin-panel/courses/pending/` | List submitted courses awaiting moderation | Admin |
| `POST` | `/api/admin-panel/courses/{id}/approve/` | Approve course publication | Admin |
| `POST` | `/api/admin-panel/courses/{id}/reject/` | Reject course publication | Admin |

---

## 3. Role-Based Permissions Matrix

| Feature / Action | Student | Teacher | Admin |
| :--- | :---: | :---: | :---: |
| Browse & View Approved Courses | ✅ | ✅ | ✅ |
| Create, Edit & Delete Own Courses | ❌ | ✅ | ✅ |
| Manage Chapters & Lessons (CRUD) | ❌ | ✅ (Own) | ✅ (All) |
| Upload Video / PDF Lessons | ❌ | ✅ | ✅ |
| Enroll in Courses | ✅ | ❌ | ❌ |
| Take Quizzes & Complete Lessons | ✅ | ❌ | ❌ |
| Earn & Download Certificates | ✅ | ❌ | ❌ |
| View Enrolled Student Progress | ❌ | ✅ (Own Courses) | ✅ (All) |
| Review Student Quiz Submissions | ❌ | ✅ (Own Courses) | ✅ (All) |
| Approve Teachers & Courses | ❌ | ❌ | ✅ |
| Manage All User Accounts (CRUD) | ❌ | ❌ | ✅ |
| View Platform Dashboard Analytics | ❌ | ❌ | ✅ |

---

## 4. Coding & Contribution Rules for Agents

1. **Clean Architecture Enforcement:** Never call APIs directly from presentation screens or widgets. Always route through `UseCase` -> `Repository` -> `DataSource` -> `ApiClient`.
2. **Static Analysis & Diagnostics:** Always run `analyze_files` via `dart-mcp-server` to maintain **0 errors and 0 warnings**.
3. **Dependency Injection:** Every new use case, repository, or datasource MUST be registered in its feature `di.dart` and initialized in `initGlobalDependencies()` inside [`lib/core/app/injection_container.dart`](file:///c:/Users/jihan/Documents/projects/education_app/lib/core/app/injection_container.dart).
4. **Error Handling:** Use `dartz`/`Either<Failure, T>` return types across repository and use case layers. Catch all `DioException` in datasources and map to `ServerException`, `NetworkException`, or `UnauthorizedException`.
5. **Multipart Uploads:** When uploading videos or PDF files, use `FormData` and `MultipartFile.fromFile` rather than JSON payloads.
6. **No Ad-Hoc Styling:** Use predefined tokens from [`AppColors`](file:///c:/Users/jihan/Documents/projects/education_app/lib/core/constants/app_colors.dart) and global custom widgets.
7. **Documentation Reference:** Check [`docs/README.md`](file:///c:/Users/jihan/Documents/projects/education_app/docs/README.md) for detailed architecture, API, and design system contracts.
