# EduFlow - AI Agent & Engineering Guide

Welcome to the **EduFlow** codebase. This file establishes the architectural standards, API contracts, workflow procedures, and guidelines for AI coding agents and engineers working on this application.

---

## 1. Project Architecture & Standards

EduFlow strictly follows **Flutter Clean Architecture** with **Feature-First modularization**.

### Feature Folder Directory Convention
Every feature located under `lib/features/<feature_name>/` must maintain the following separation:
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
│   ├── bloc/ or cubit/ # State management controllers
│   ├── screens/        # Full-page UI views
│   └── widgets/        # Feature-specific reusable UI components
└── di.dart             # GetIt dependency injection initialization function for the feature
```

### Global Custom Widgets
- Global reusable components reside in [`lib/core/widgets/`](file:///c:/Users/jihan/Documents/projects/education_app/lib/core/widgets/).
- Do NOT delete or modify the global widgets folder as it holds application-wide design system elements.
- Always use feature-specific `presentation/widgets/` for component extraction within a given feature.

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
| `GET` | `/api/courses/courses/` | List all courses (with filters) | Authenticated |
| `GET` | `/api/courses/courses/approved/` | List approved courses for students | Authenticated |
| `POST` | `/api/courses/courses/` | Create a new course | Teacher / Admin |
| `GET` | `/api/courses/courses/{id}/` | Get full course details with chapters & lessons | Authenticated |
| `POST` | `/api/courses/courses/{id}/toggle-publish/` | Toggle course publish status | Teacher (Owner) / Admin |
| `GET` | `/api/courses/chapters/` | List course chapters (query: `course`, `page`) | Authenticated |
| `GET` | `/api/courses/chapters/{id}/` | Get single chapter details with lessons | Authenticated |
| `POST` | `/api/courses/chapters/` | Create chapter (`course`, `title`, `order`) | Teacher / Admin |
| `POST` | `/api/courses/lessons/` | Create lesson (supports multipart for video/PDF) | Teacher / Admin |
| `PATCH` | `/api/courses/lessons/{id}/` | Partial update lesson / upload media files | Teacher / Admin |

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
| `POST` | `/api/progress/complete/` | Mark lesson complete (`lesson_id`) | Student |
| `GET` | `/api/progress/course/{id}/` | Course progress percentage & lesson states | Student |
| `GET` | `/api/progress/my-progress/` | Overview of all enrolled courses progress | Student |
| `POST` | `/api/progress/certificate/{id}/` | Generate certificate upon 100% course completion | Student |
| `GET` | `/api/progress/certificates/` | Retrieve student earned certificates list | Student |

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

## 3. End-to-End User Workflows

### Student Journey:
1. **Register** (`POST /api/auth/register/`) with role `student`.
2. **Login** (`POST /api/auth/login/`) → save JWT tokens in `SharedPreferences`.
3. **Browse Approved Courses** (`GET /api/courses/courses/approved/`).
4. **Enroll** (`POST /api/progress/enroll/`).
5. **View Lessons** (`GET /api/courses/courses/{id}/`) and complete lessons (`POST /api/progress/complete/`).
6. **Take & Submit Quiz** (`GET /api/quizzes/quizzes/{id}/take/` → `POST /api/quizzes/quizzes/{id}/submit/`).
7. **Track Progress** (`GET /api/progress/my-progress/`).
8. **Claim Certificate** (`POST /api/progress/certificate/{id}/` when progress = 100%).

### Teacher Journey:
1. **Register** (`POST /api/auth/register/`) with role `teacher`.
2. **Wait for Admin Approval** (`teacher_pending_screen`).
3. **Login** once approved.
4. **Create Course** (`POST /api/courses/courses/`).
5. **Add Chapters** (`POST /api/courses/chapters/`).
6. **Add Lessons & Upload Media** (`POST /api/courses/lessons/` with multipart/form-data).
7. **Create Quiz & Questions** (`POST /api/quizzes/quizzes/` & `POST /api/quizzes/questions/`).
8. **Submit for Publication** (`POST /api/courses/courses/{id}/toggle-publish/`).
9. **Admin Reviews & Approves Course**.

### Admin Journey:
1. **Login** with admin credentials.
2. **Review Dashboard Statistics** (`GET /api/admin-panel/dashboard/`).
3. **Approve Pending Teachers** (`GET /api/admin-panel/teachers/pending/` → `POST /api/admin-panel/teachers/{id}/approve/`).
4. **Approve / Reject Courses** (`GET /api/admin-panel/courses/pending/` → `POST /api/admin-panel/courses/{id}/approve/`).
5. **Manage Users Directory** (CRUD operations on `/api/admin-panel/users/`).

---

## 4. Role-Based Permissions Matrix

| Feature / Action | Student | Teacher | Admin |
| :--- | :---: | :---: | :---: |
| Browse & View Courses | ✅ | ✅ | ✅ |
| Create & Edit Own Courses | ❌ | ✅ | ✅ |
| Upload Video / PDF Lessons | ❌ | ✅ | ✅ |
| Enroll in Courses | ✅ | ❌ | ❌ |
| Take Quizzes & Complete Lessons | ✅ | ❌ | ❌ |
| Earn & Download Certificates | ✅ | ❌ | ❌ |
| Review Student Quiz Submissions | ❌ | ✅ (Own Courses) | ✅ (All) |
| Approve Teachers & Courses | ❌ | ❌ | ✅ |
| Manage All User Accounts | ❌ | ❌ | ✅ |
| View System Dashboard Analytics | ❌ | ❌ | ✅ |

---

## 5. Coding & Contribution Rules for Agents

1. **Clean Architecture Enforcement**: Never call APIs directly from presentation screens or widgets. Always route through `UseCase` -> `Repository` -> `DataSource` -> `ApiClient`.
2. **Static Analysis & Diagnostics**: Always run `analyze_files` via `dart-mcp-server` to maintain **0 errors and 0 warnings**.
3. **Dependency Injection**: Every new usecase, repository, or datasource MUST be registered in its feature `di.dart` and called in `initGlobalDependencies()` inside [`lib/core/app/injection_container.dart`](file:///c:/Users/jihan/Documents/projects/education_app/lib/core/app/injection_container.dart).
4. **Error Handling**: Use `dartz`/`Either<Failure, T>` return types across repository and use case layers.
5. **Multipart Uploads**: When uploading videos or PDF files, use `FormData` and `MultipartFile.fromFile` rather than JSON payloads.
