# EduFlow — Complete API Specification & Contracts

This document contains the complete REST API specification for **EduFlow**, including endpoints, HTTP methods, request headers, payload bodies, response codes, role permissions, and error handling contracts.

---

## 1. Backend Server & Base URL

* **Server Host:** `http://144.79.133.208:8000`
* **API Prefix:** `/api/...`
* **Swagger Documentation:** `http://144.79.133.208:8000/swagger/`
* **ReDoc Documentation:** `http://144.79.133.208:8000/redoc/`
* **OpenAPI Specification JSON:** `http://144.79.133.208:8000/swagger.json`

---

## 2. Authentication & Authorization

All authenticated endpoints require a valid JWT Bearer token in the `Authorization` header:
```http
Authorization: Bearer <access_token>
```

### 2.1 Register User
* **Endpoint:** `POST /api/auth/register/`
* **Auth Required:** No
* **Request Body:**
```json
{
  "username": "johndoe",
  "email": "john@example.com",
  "password": "SecurePassword123!",
  "first_name": "John",
  "last_name": "Doe",
  "role": "student" // "student" | "teacher"
}
```
* **Success Response (`201 Created`):**
```json
{
  "id": 12,
  "username": "johndoe",
  "email": "john@example.com",
  "role": "student",
  "is_approved_teacher": false
}
```

### 2.2 Login
* **Endpoint:** `POST /api/auth/login/`
* **Auth Required:** No
* **Request Body:**
```json
{
  "username": "johndoe",
  "password": "SecurePassword123!"
}
```
* **Success Response (`200 OK`):**
```json
{
  "access": "<jwt_access_token>",
  "refresh": "<jwt_refresh_token>",
  "user": {
    "id": 12,
    "username": "johndoe",
    "email": "john@example.com",
    "role": "student",
    "is_approved_teacher": false,
    "first_name": "John",
    "last_name": "Doe"
  }
}
```

### 2.3 Get Current User Profile
* **Endpoint:** `GET /api/auth/me/`
* **Auth Required:** Yes (`Bearer`)
* **Success Response (`200 OK`):**
```json
{
  "id": 12,
  "username": "johndoe",
  "email": "john@example.com",
  "role": "student",
  "is_approved_teacher": false,
  "first_name": "John",
  "last_name": "Doe"
}
```

### 2.4 Refresh Access Token
* **Endpoint:** `POST /api/auth/refresh/`
* **Auth Required:** No
* **Request Body:**
```json
{
  "refresh": "<jwt_refresh_token>"
}
```
* **Success Response (`200 OK`):**
```json
{
  "access": "<new_jwt_access_token>"
}
```

---

## 3. Courses & Curriculum

### 3.1 List Approved Courses (Student Discovery)
* **Endpoint:** `GET /api/courses/courses/approved/`
* **Query Parameters:** `page` (int), `category` (string), `search` (string)
* **Auth Required:** Yes
* **Success Response (`200 OK`):**
```json
{
  "count": 24,
  "next": "http://144.79.133.208:8000/api/courses/courses/approved/?page=2",
  "previous": null,
  "results": [
    {
      "id": 1,
      "title": "Flutter Clean Architecture Masterclass",
      "description": "Comprehensive guide to BLoC, GetIt, and Clean Architecture.",
      "teacher": 5,
      "teacher_name": "Sarah Connor",
      "thumbnail": "http://144.79.133.208:8000/media/thumbnails/flutter.png",
      "status": "approved",
      "is_published": true,
      "category": "Computer Science",
      "price": 0.0,
      "is_enrolled": false,
      "chapters_count": 4,
      "lessons_count": "18"
    }
  ]
}
```

### 3.2 List Teacher Authored Courses
* **Endpoint:** `GET /api/courses/courses/my-courses/`
* **Auth Required:** Teacher / Admin
* **Success Response (`200 OK`):** List of courses authored by the current authenticated teacher.

### 3.3 Create Course
* **Endpoint:** `POST /api/courses/courses/`
* **Auth Required:** Approved Teacher / Admin
* **Request Body:**
```json
{
  "title": "Advanced Dart Generics & Macros",
  "description": "Master deep type-system concepts in Dart 3.",
  "is_published": false
}
```
* **Success Response (`201 Created`):** Created course object.

### 3.4 Retrieve Full Course Details (with Syllabus)
* **Endpoint:** `GET /api/courses/courses/{id}/`
* **Auth Required:** Yes
* **Success Response (`200 OK`):**
```json
{
  "id": 1,
  "title": "Flutter Clean Architecture Masterclass",
  "description": "Comprehensive guide to BLoC, GetIt, and Clean Architecture.",
  "teacher": 5,
  "teacher_name": "Sarah Connor",
  "status": "approved",
  "is_published": true,
  "is_enrolled": true,
  "chapters": [
    {
      "id": 10,
      "course": 1,
      "title": "Module 1: Domain Entities & Repositories",
      "order": 1,
      "lessons": [
        {
          "id": 101,
          "chapter": 10,
          "title": "Understanding Immutable Entities with Equatable",
          "lesson_type": "video",
          "video_file": "http://144.79.133.208:8000/media/videos/lesson1.mp4",
          "duration_minutes": 15,
          "order": 1,
          "is_completed": true
        }
      ]
    }
  ]
}
```

### 3.5 Submit / Toggle Course Publication
* **Endpoint:** `POST /api/courses/courses/{id}/toggle-publish/`
* **Auth Required:** Teacher (Owner) / Admin
* **Description:** Toggles course between unpublished draft and submitted for admin approval.

### 3.6 Chapters CRUD
* `POST /api/courses/chapters/` — Create chapter (`course`, `title`, `order`)
* `PUT /api/courses/chapters/{id}/` — Update chapter
* `DELETE /api/courses/chapters/{id}/` — Delete chapter

### 3.7 Lessons CRUD (Multipart Uploads)
* `POST /api/courses/lessons/` — Create lesson with media files
* **Content-Type:** `multipart/form-data`
* **Form Fields:** `chapter` (int), `title` (string), `lesson_type` (`video`|`pdf`|`text`), `order` (int), `duration_minutes` (int), `video_file` (binary MP4), `pdf_file` (binary PDF), `text_content` (string).

---

## 4. Quizzes & Assessments

### 4.1 Create Quiz
* **Endpoint:** `POST /api/quizzes/quizzes/`
* **Auth Required:** Teacher / Admin
* **Payload:** `{"course": 1, "title": "Module 1 Evaluation", "pass_percentage": 70}`

### 4.2 Create Quiz Question & Choices
* **Endpoint:** `POST /api/quizzes/questions/`
* **Payload:**
```json
{
  "quiz": 1,
  "text": "Which layer holds abstract repository contracts?",
  "choices": [
    {"text": "Domain Layer", "is_correct": true},
    {"text": "Presentation Layer", "is_correct": false},
    {"text": "Data Layer", "is_correct": false}
  ]
}
```

### 4.3 Student Take Quiz (Masked Answers)
* **Endpoint:** `GET /api/quizzes/quizzes/{id}/take/`
* **Auth Required:** Student

### 4.4 Submit Quiz Answers
* **Endpoint:** `POST /api/quizzes/quizzes/{id}/submit/`
* **Payload:**
```json
{
  "answers": [
    {"question": 101, "choice": 502},
    {"question": 102, "choice": 506}
  ]
}
```
* **Success Response (`200 OK`):**
```json
{
  "score": 8,
  "total": 10,
  "percentage": 80,
  "passed": true
}
```

---

## 5. Student Progress & Certification

### 5.1 Enroll in Course
* **Endpoint:** `POST /api/progress/enroll/`
* **Payload:** `{"course_id": 1}`
* **Auth Required:** Student

### 5.2 Mark Lesson Completed
* **Endpoint:** `POST /api/progress/complete/`
* **Payload:** `{"lesson": 101}`
* **Auth Required:** Student

### 5.3 Student Learning Progress Overview
* **Endpoint:** `GET /api/progress/my-progress/`
* **Auth Required:** Student

### 5.4 Generate Official Certificate (100% Completion)
* **Endpoint:** `POST /api/progress/certificate/{course_id}/`
* **Auth Required:** Student (Progress must be 100%)
* **Success Response (`201 Created`):**
```json
{
  "id": 4,
  "certificate_id": "EDU-CERT-8849-0004",
  "student": 12,
  "student_name": "John Doe",
  "course": 1,
  "course_title": "Flutter Clean Architecture Masterclass",
  "progress_percent": 100.0,
  "issued_at": "2026-08-24T12:00:00Z"
}
```

### 5.5 List Earned Certificates
* **Endpoint:** `GET /api/progress/certificates/`
* **Auth Required:** Student

---

## 6. Admin Panel Management

### 6.1 Dashboard Statistics
* **Endpoint:** `GET /api/admin-panel/dashboard/`
* **Auth Required:** Admin
* **Response:** Total users, total courses, total enrollments, pending teachers, pending courses, average quiz scores.

### 6.2 Top Courses Leaderboard
* **Endpoint:** `GET /api/admin-panel/top-courses/`
* **Auth Required:** Admin

### 6.3 Pending Teacher Account Moderation
* `GET /api/admin-panel/teachers/pending/` — List teachers awaiting approval
* `POST /api/admin-panel/teachers/{id}/approve/` — Approve teacher account

### 6.4 Pending Course Moderation
* `GET /api/admin-panel/courses/pending/` — List courses awaiting publication
* `POST /api/admin-panel/courses/{id}/approve/` — Approve & publish course
* `POST /api/admin-panel/courses/{id}/reject/` — Reject course submission

### 6.5 User Directory CRUD
* `GET /api/admin-panel/users/` — List users (search, filter, pagination)
* `POST /api/admin-panel/users/` — Create user directly
* `GET /api/admin-panel/users/{id}/` — View user details
* `PUT /api/admin-panel/users/{id}/` / `PATCH /api/admin-panel/users/{id}/` — Update user
* `DELETE /api/admin-panel/users/{id}/` — Delete user
