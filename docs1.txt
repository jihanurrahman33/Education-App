# Education App — Complete API Documentation

This document organizes the complete API specification, application workflows, role-based permissions, authentication rules, file-upload requirements, and testing instructions provided for the Education App.

---

# 1. API Overview

The Education App provides APIs for:

1. **Authentication & User Management**
2. **Course Management**
3. **Quiz Management**
4. **Student Progress Tracking**
5. **Certificate Generation**
6. **Admin Management**
7. **Role-Based Access Control**

The application has three primary roles:

* **Student**
* **Teacher**
* **Admin**

Authentication is handled using **JWT (JSON Web Token)**.

---

# 2. User Roles

## 2.1 Student

Students can:

* Register
* Login
* View approved courses
* Enroll in courses
* View course chapters and lessons
* Take quizzes
* Submit quizzes
* View quiz results
* Mark lessons as completed
* Track course progress
* View overall progress
* Generate certificates after completing a course 100%
* View their certificates

Students cannot:

* Create courses
* Edit courses
* Create quizzes
* Create questions
* Approve teachers
* Approve/reject courses
* Access the admin dashboard

---

## 2.2 Teacher

Teachers can:

* Register as a teacher
* Login after approval
* Create courses
* Create chapters
* Create lessons
* Edit their lessons
* Upload lesson files
* Create quizzes
* Create quiz questions and choices
* View quiz results for their quizzes
* Publish/unpublish their courses

Teachers cannot:

* Take quizzes as students
* Enroll in courses
* Track student-style course progress
* Generate certificates
* Approve teachers
* Approve/reject courses
* Edit another teacher's course

A teacher can manage **only their own courses**.

---

## 2.3 Admin

Admins can:

* Login
* View users
* Approve teachers
* Approve courses
* Reject courses
* View dashboard statistics
* Manage users
* Manage courses

Admins have elevated permissions over the system.

---

# 3. Authentication API

Base path:

```text
/api/auth/
```

---

## 3.1 Register

### Endpoint

```http
POST /api/auth/register/
```

### Description

Creates a new user account.

Users can register as:

* Student
* Teacher

### Access

Public.

### Workflow

```text
Register
   ↓
Account Created
   ↓
If Teacher → Wait for Admin Approval
   ↓
Login
```

---

## 3.2 Login

### Endpoint

```http
POST /api/auth/login/
```

### Description

Authenticates a user and returns a JWT access token.

### Access

Public.

### Result

The returned access token is used to access protected APIs.

Example authorization header:

```http
Authorization: Bearer <access_token>
```

---

## 3.3 Current User Profile

### Endpoint

```http
GET /api/auth/me/
```

### Description

Returns information about the currently authenticated user.

### Access

Authenticated users.

### Authentication

```http
Authorization: Bearer <access_token>
```

---

## 3.4 Refresh Access Token

### Endpoint

```http
POST /api/auth/refresh/
```

### Description

Generates a new access token when the existing access token expires.

### Access

Authenticated users with a valid refresh token.

### Token Lifetime

The access token is valid for:

```text
6 hours
```

When the access token expires, use the refresh endpoint to obtain a new access token.

---

# 4. Course API

Base path:

```text
/api/courses/
```

Courses are primarily used by students for learning and by teachers/admins for course management.

---

## 4.1 Course List

### Endpoint

```http
GET /api/courses/courses/
```

### Description

Returns the course list.

### Access

* Student
* Teacher
* Admin

---

## 4.2 Approved Courses

### Endpoint

```http
GET /api/courses/courses/approved/
```

### Description

Returns courses that have been approved and are available for students.

### Access

Primarily intended for students.

### Student Workflow

```text
Login
   ↓
GET /api/courses/courses/approved/
   ↓
Browse available courses
```

---

## 4.3 Create Course

### Endpoint

```http
POST /api/courses/courses/
```

### Description

Creates a new course.

### Access

Teacher/Admin.

### Teacher Requirement

The teacher must be approved by an administrator.

### Ownership Rule

A teacher creates and manages their own courses.

---

## 4.4 Course Details

### Endpoint

```http
GET /api/courses/courses/{id}/
```

### Description

Returns complete course details.

The response includes:

* Course information
* Chapters
* Lessons

Conceptually:

```text
Course
 ├── Chapter 1
 │    ├── Lesson 1
 │    ├── Lesson 2
 │    └── Lesson 3
 │
 ├── Chapter 2
 │    ├── Lesson 1
 │    └── Lesson 2
 │
 └── Chapter 3
      └── Lesson 1
```

---

## 4.5 Publish / Unpublish Course

### Endpoint

```http
POST /api/courses/courses/{id}/toggle-publish/
```

### Description

Toggles the publishing status of a course.

Possible states:

```text
Published
```

or

```text
Unpublished
```

### Access

Teacher/Admin.

### Important Rule

A teacher can only publish/unpublish their own course.

---

# 5. Chapter API

## 5.1 Create Chapter

### Endpoint

```http
POST /api/courses/chapters/
```

### Description

Creates a new chapter for a course.

### Access

Teacher.

### Ownership

The teacher should only be able to create chapters for their own courses.

---

# 6. Lesson API

## 6.1 Create Lesson

### Endpoint

```http
POST /api/courses/lessons/
```

### Description

Creates a lesson under a chapter/course.

### Access

Teacher.

### Possible Lesson Content

Lessons may contain uploaded learning materials such as:

* Video
* PDF
* Other supported lesson files

---

## 6.2 Edit Lesson / Upload Files

### Endpoint

```http
PATCH /api/courses/lessons/{id}/
```

### Description

Used to:

* Edit lesson information
* Upload lesson files
* Update lesson content

### Access

Teacher.

### Ownership Rule

Teachers can only edit lessons belonging to their own courses.

Attempting to modify another teacher's lesson/course should return:

```http
403 Forbidden
```

---

# 7. Quiz API

Base path:

```text
/api/quizzes/
```

The quiz system allows teachers to create quizzes and students to take them and receive scores.

---

## 7.1 Create Quiz

### Endpoint

```http
POST /api/quizzes/quizzes/
```

### Description

Creates a new quiz.

### Access

Teacher.

### Typical Workflow

```text
Teacher
   ↓
Create Course
   ↓
Create Chapters
   ↓
Create Lessons
   ↓
Create Quiz
```

---

## 7.2 Create Questions & Choices

### Endpoint

```http
POST /api/quizzes/questions/
```

### Description

Creates a quiz question together with its choices.

### Access

Teacher.

### Conceptual Structure

```text
Question
 ├── Choice A
 ├── Choice B
 ├── Choice C
 └── Choice D
```

The correct answer should be stored by the system but should **not be exposed to students when taking the quiz**.

---

# 8. Take Quiz

### Endpoint

```http
GET /api/quizzes/quizzes/{id}/take/
```

### Description

Returns the quiz questions and choices that the student needs to answer.

### Access

Student.

### Important Security Requirement

The correct answers must remain hidden from the student.

The API response used for taking a quiz must not expose the correct choice/answer.

### Workflow

```text
Student
   ↓
Open Quiz
   ↓
GET /api/quizzes/quizzes/{id}/take/
   ↓
Receive questions + choices
   ↓
Select answers
```

---

# 9. Submit Quiz

### Endpoint

```http
POST /api/quizzes/quizzes/{id}/submit/
```

### Description

Submits the student's answers.

The backend evaluates the answers and calculates the score.

### Access

Student.

### Workflow

```text
Take Quiz
   ↓
Select Answers
   ↓
Submit
   ↓
Backend Checks Answers
   ↓
Score Calculated
```

The resulting score is stored as the student's quiz result.

---

# 10. Student Quiz Results

### Endpoint

```http
GET /api/quizzes/quizzes/my-results/
```

### Description

Returns the authenticated student's own quiz results.

### Access

Student.

### Student can see

* Quizzes they have taken
* Their scores/results

A student should not be able to access another student's private results.

---

# 11. Teacher Quiz Results

### Endpoint

```http
GET /api/quizzes/quizzes/{id}/results/
```

### Description

Returns quiz results for a particular quiz.

### Access

Teacher.

### Ownership Rule

A teacher should only be able to view results for quizzes belonging to their own courses.

---

# 12. Progress & Certificate API

Base path:

```text
/api/progress/
```

This module manages:

* Course enrollment
* Lesson completion
* Course progress
* Certificates

These features are primarily for students.

---

# 13. Enroll in Course

### Endpoint

```http
POST /api/progress/enroll/
```

### Description

Enrolls the authenticated student in a course.

### Access

Student.

### Workflow

```text
Browse Approved Courses
   ↓
Select Course
   ↓
Enroll
   ↓
Course Added to Student's Learning
```

---

# 14. Complete Lesson

### Endpoint

```http
POST /api/progress/complete/
```

### Description

Marks a lesson as completed by the student.

### Access

Student.

### Workflow

```text
Student watches/reads lesson
   ↓
Mark lesson complete
   ↓
Progress updated
```

The lesson completion contributes to the overall course progress percentage.

---

# 15. Course Progress

### Endpoint

```http
GET /api/progress/course/{id}/
```

### Description

Returns the student's progress for a specific course.

The progress is represented as a percentage.

Example:

```text
Course Progress: 75%
```

### Access

Student.

---

# 16. My Progress

### Endpoint

```http
GET /api/progress/my-progress/
```

### Description

Returns progress information for all courses associated with the authenticated student.

Example conceptual result:

```text
Course A → 100%
Course B → 75%
Course C → 40%
```

### Access

Student.

---

# 17. Generate Certificate

### Endpoint

```http
POST /api/progress/certificate/{id}/
```

### Description

Generates a certificate for a completed course.

### Access

Student.

### Requirement

The student must complete the course **100%** before a certificate can be generated.

### Workflow

```text
Enroll
   ↓
Complete Lessons
   ↓
Progress = 100%
   ↓
Request Certificate
   ↓
Certificate Generated
```

If the course is not 100% complete, certificate generation should not be allowed.

---

# 18. My Certificates

### Endpoint

```http
GET /api/progress/certificates/
```

### Description

Returns the authenticated student's certificate list.

### Access

Student.

---

# 19. Admin API

Base path:

```text
/api/admin-panel/
```

Admin APIs are restricted to administrators.

---

# 20. User List

### Endpoint

```http
GET /api/admin-panel/users/
```

### Description

Returns the list of users registered in the system.

### Access

Admin.

### Admin Use Cases

The admin can use this endpoint to manage/monitor:

* Students
* Teachers
* Other users

---

# 21. Approve Teacher

### Endpoint

```http
POST /api/admin-panel/teachers/{id}/approve/
```

### Description

Approves a teacher account.

### Access

Admin.

### Teacher Workflow

```text
Teacher Registers
   ↓
Teacher Account Pending
   ↓
Admin Reviews
   ↓
Admin Approves
   ↓
Teacher Can Use Teacher Features
```

---

# 22. Approve Course

### Endpoint

```http
POST /api/admin-panel/courses/{id}/approve/
```

### Description

Approves a course created by a teacher.

### Access

Admin.

### Workflow

```text
Teacher Creates Course
   ↓
Course Pending Approval
   ↓
Admin Reviews Course
   ↓
Admin Approves
   ↓
Course Can Become Available
```

---

# 23. Reject Course

### Endpoint

```http
POST /api/admin-panel/courses/{id}/reject/
```

### Description

Rejects a course submitted by a teacher.

### Access

Admin.

### Workflow

```text
Teacher Creates Course
   ↓
Admin Reviews
   ↓
Reject
   ↓
Course Remains Unapproved
```

---

# 24. Admin Dashboard

### Endpoint

```http
GET /api/admin-panel/dashboard/
```

### Description

Returns system statistics for the admin dashboard.

### Access

Admin.

The dashboard is intended to provide an overview of the platform's current statistics.

---

# 25. Complete Student Workflow

The complete student journey is:

```text
1. Register
      ↓
2. Login
      ↓
3. Browse Approved Courses
      ↓
4. Select Course
      ↓
5. Enroll
      ↓
6. View Course
      ↓
7. View Chapters
      ↓
8. View Lessons
      ↓
9. Complete Lessons
      ↓
10. Take Quiz
      ↓
11. Submit Quiz
      ↓
12. Receive Score
      ↓
13. Check Course Progress
      ↓
14. Complete Course 100%
      ↓
15. Generate Certificate
      ↓
16. View Certificate
```

---

# 26. Complete Teacher Workflow

The complete teacher journey is:

```text
1. Register as Teacher
      ↓
2. Wait for Admin Approval
      ↓
3. Admin Approves Teacher
      ↓
4. Login
      ↓
5. Create Course
      ↓
6. Add Chapters
      ↓
7. Add Lessons
      ↓
8. Upload Video/PDF
      ↓
9. Create Quiz
      ↓
10. Create Questions + Choices
      ↓
11. Submit Course for Approval
      ↓
12. Admin Reviews Course
      ↓
13. Admin Approves Course
      ↓
14. Publish Course
      ↓
15. Students Can Access Course
```

---

# 27. Complete Admin Workflow

```text
1. Login
      ↓
2. View Users
      ↓
3. Review Teacher Applications
      ↓
4. Approve Teachers
      ↓
5. Review Courses
      ↓
6. Approve / Reject Courses
      ↓
7. View Dashboard Statistics
      ↓
8. Manage Users
```

---

# 28. Role-Based Access Matrix

| Action                        | Student | Teacher | Admin |
| ----------------------------- | :-----: | :-----: | :---: |
| Register                      |    ✅    |    ✅    |   —   |
| Login                         |    ✅    |    ✅    |   ✅   |
| View Courses                  |    ✅    |    ✅    |   ✅   |
| View Approved Courses         |    ✅    |    ✅    |   ✅   |
| Create Course                 |    ❌    |    ✅    |   ✅   |
| Edit Own Course               |    ❌    |    ✅    |   ✅   |
| Edit Another Teacher's Course |    ❌    |    ❌    |   ✅   |
| Publish/Unpublish Own Course  |    ❌    |    ✅    |   ✅   |
| Create Chapter                |    ❌    |    ✅    |   ✅   |
| Create Lesson                 |    ❌    |    ✅    |   ✅   |
| Edit Own Lesson               |    ❌    |    ✅    |   ✅   |
| Upload Lesson Files           |    ❌    |    ✅    |   ✅   |
| Create Quiz                   |    ❌    |    ✅    |   ❌   |
| Create Questions              |    ❌    |    ✅    |   ❌   |
| Take Quiz                     |    ✅    |    ❌    |   ❌   |
| Submit Quiz                   |    ✅    |    ❌    |   ❌   |
| View Own Quiz Results         |    ✅    |    ❌    |   ❌   |
| View Course Quiz Results      |    ❌    |    ✅    |   ❌   |
| Enroll in Course              |    ✅    |    ❌    |   ❌   |
| Complete Lessons              |    ✅    |    ❌    |   ❌   |
| View Course Progress          |    ✅    |    ❌    |   ❌   |
| View All Own Progress         |    ✅    |    ❌    |   ❌   |
| Generate Certificate          |    ✅    |    ❌    |   ❌   |
| View Certificates             |    ✅    |    ❌    |   ❌   |
| View Users                    |    ❌    |    ❌    |   ✅   |
| Approve Teacher               |    ❌    |    ❌    |   ✅   |
| Approve Course                |    ❌    |    ❌    |   ✅   |
| Reject Course                 |    ❌    |    ❌    |   ✅   |
| View Dashboard                |    ❌    |    ❌    |   ✅   |

---

# 29. Authentication & Authorization

The application uses **JWT-based authentication**.

After login, the client receives an access token.

Protected requests should include:

```http
Authorization: Bearer <access_token>
```

The server uses the token to determine:

1. Whether the user is authenticated.
2. Which user is making the request.
3. Which role the user has.
4. Whether the user is authorized to perform the requested operation.

---

# 30. JWT Token Lifecycle

```text
Login
  ↓
Access Token + Refresh Token
  ↓
Use Access Token
  ↓
Access Token Valid for 6 Hours
  ↓
Token Expires
  ↓
Call /api/auth/refresh/
  ↓
Receive New Access Token
  ↓
Continue API Requests
```

---

# 31. API Authorization Header

For protected endpoints:

```http
Authorization: Bearer <access_token>
```

Example:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

The actual token should never be hardcoded into the application source code.

---

# 32. Swagger API Documentation

The API provides Swagger UI for interactive API testing.

Open:

```text
/swagger/
```

### Authentication

Click:

```text
Authorize
```

Then enter:

```text
Bearer <access_token>
```

After authorization, protected endpoints can be tested directly from Swagger.

---

# 33. File Upload Requirements

Lesson file uploads must use:

```text
multipart/form-data
```

Do **not** send file uploads using:

```http
Content-Type: application/json
```

Instead, the frontend should create a `FormData` object.

Conceptually:

```text
FormData
 ├── Lesson Information
 ├── Video File
 └── PDF File
```

This applies particularly to:

```http
PATCH /api/courses/lessons/{id}/
```

when uploading or replacing lesson files.

---

# 34. Course Ownership & Permissions

Teacher ownership is an important security requirement.

A teacher may:

* Create their own course
* Edit their own course
* Create chapters for their own course
* Create lessons for their own course
* Edit their own lessons
* Upload files to their own lessons
* Create quizzes for their own courses
* View results for their own quizzes
* Publish/unpublish their own courses

A teacher may **not** modify another teacher's course.

Unauthorized ownership access should return:

```http
403 Forbidden
```

Example:

```text
Teacher A
   ↓
Attempts to edit
   ↓
Teacher B's Course
   ↓
403 Forbidden
```

---

# 35. Course Approval Flow

Course creation and course approval are separate operations.

```text
Teacher
   ↓
Create Course
   ↓
Course Pending
   ↓
Admin Reviews
   ├── Approve
   │     ↓
   │   Course Approved
   │
   └── Reject
         ↓
       Course Rejected
```

Only approved courses should be exposed through the approved-course endpoint intended for students.

---

# 36. Teacher Approval Flow

Teacher accounts also require administrative approval.

```text
Teacher Registration
        ↓
Teacher Account
        ↓
Pending Approval
        ↓
Admin Reviews
        ↓
Approve
        ↓
Teacher Can Manage Courses
```

---

# 37. Quiz Security Flow

The quiz system should keep correct answers hidden.

### Student

```text
GET /api/quizzes/quizzes/{id}/take/
```

Student receives:

```text
Question
 ├── Choice A
 ├── Choice B
 ├── Choice C
 └── Choice D
```

The correct answer is **not exposed**.

Then:

```text
POST /api/quizzes/quizzes/{id}/submit/
```

The backend evaluates the submitted answers against the stored correct answers.

```text
Student Answers
      ↓
Backend
      ↓
Compare With Correct Answers
      ↓
Calculate Score
      ↓
Save Result
```

---

# 38. Progress Calculation

Student progress is based on completed lessons.

Conceptually:

```text
Progress % =
Completed Lessons / Total Lessons × 100
```

Example:

```text
Total Lessons = 20
Completed = 15

Progress = 15 / 20 × 100
         = 75%
```

When:

```text
Completed Lessons = Total Lessons
```

the course reaches:

```text
100%
```

At 100%, the student becomes eligible to generate the course certificate.

---

# 39. Certificate Flow

```text
Student Enrolls
      ↓
Completes Lessons
      ↓
Progress Updates
      ↓
Progress = 100%
      ↓
POST /api/progress/certificate/{id}/
      ↓
Certificate Generated
      ↓
GET /api/progress/certificates/
      ↓
Student Views Certificate
```

Certificate generation must not be available before the course reaches 100% completion.

---

# 40. Complete API Endpoint Reference

## Authentication

| Method | Endpoint              | Role          | Purpose                  |
| ------ | --------------------- | ------------- | ------------------------ |
| POST   | `/api/auth/register/` | Public        | Register student/teacher |
| POST   | `/api/auth/login/`    | Public        | Login and receive JWT    |
| GET    | `/api/auth/me/`       | Authenticated | Current user profile     |
| POST   | `/api/auth/refresh/`  | Authenticated | Refresh access token     |

## Courses

| Method | Endpoint                                    | Role                  | Purpose                  |
| ------ | ------------------------------------------- | --------------------- | ------------------------ |
| GET    | `/api/courses/courses/`                     | Student/Teacher/Admin | Course list              |
| GET    | `/api/courses/courses/approved/`            | Student               | Approved courses         |
| POST   | `/api/courses/courses/`                     | Teacher/Admin         | Create course            |
| GET    | `/api/courses/courses/{id}/`                | Authenticated         | Course details           |
| POST   | `/api/courses/courses/{id}/toggle-publish/` | Teacher/Admin         | Publish/unpublish        |
| POST   | `/api/courses/chapters/`                    | Teacher               | Create chapter           |
| POST   | `/api/courses/lessons/`                     | Teacher               | Create lesson            |
| PATCH  | `/api/courses/lessons/{id}/`                | Teacher               | Edit lesson/upload files |

## Quiz

| Method | Endpoint                             | Role    | Purpose                   |
| ------ | ------------------------------------ | ------- | ------------------------- |
| POST   | `/api/quizzes/quizzes/`              | Teacher | Create quiz               |
| POST   | `/api/quizzes/questions/`            | Teacher | Create question + choices |
| GET    | `/api/quizzes/quizzes/{id}/take/`    | Student | Take quiz                 |
| POST   | `/api/quizzes/quizzes/{id}/submit/`  | Student | Submit quiz               |
| GET    | `/api/quizzes/quizzes/my-results/`   | Student | Own results               |
| GET    | `/api/quizzes/quizzes/{id}/results/` | Teacher | Quiz results              |

## Progress & Certificate

| Method | Endpoint                          | Role    | Purpose              |
| ------ | --------------------------------- | ------- | -------------------- |
| POST   | `/api/progress/enroll/`           | Student | Enroll in course     |
| POST   | `/api/progress/complete/`         | Student | Complete lesson      |
| GET    | `/api/progress/course/{id}/`      | Student | Course progress      |
| GET    | `/api/progress/my-progress/`      | Student | All progress         |
| POST   | `/api/progress/certificate/{id}/` | Student | Generate certificate |
| GET    | `/api/progress/certificates/`     | Student | Certificate list     |

## Admin

| Method | Endpoint                                  | Role  | Purpose              |
| ------ | ----------------------------------------- | ----- | -------------------- |
| GET    | `/api/admin-panel/users/`                 | Admin | User list            |
| POST   | `/api/admin-panel/teachers/{id}/approve/` | Admin | Approve teacher      |
| POST   | `/api/admin-panel/courses/{id}/approve/`  | Admin | Approve course       |
| POST   | `/api/admin-panel/courses/{id}/reject/`   | Admin | Reject course        |
| GET    | `/api/admin-panel/dashboard/`             | Admin | Dashboard statistics |

---

# 41. Key Business Rules

The following rules should be enforced by the backend:

1. Users can register as **Student** or **Teacher**.
2. Teacher accounts require **Admin approval**.
3. Teachers can create courses only after appropriate authorization/approval.
4. Teachers can manage **only their own courses**.
5. Teachers cannot modify another teacher's courses.
6. Unauthorized ownership access must return **403 Forbidden**.
7. Only approved courses should be available through the approved-course endpoint for students.
8. Students can enroll in courses.
9. Students can mark lessons as completed.
10. Course progress is calculated based on completed lessons.
11. Students can take quizzes.
12. Correct quiz answers must remain hidden from students.
13. Quiz scores are calculated on the backend after submission.
14. Students can see their own quiz results.
15. Teachers can view results for their own quizzes.
16. Students can generate certificates only after reaching **100% course completion**.
17. Students can view their own certificates.
18. Only admins can approve teachers.
19. Only admins can approve courses.
20. Only admins can reject courses.
21. Only admins can access the admin dashboard.
22. Protected APIs require JWT authentication.
23. Access tokens are valid for **6 hours**.
24. Expired access tokens can be renewed using the refresh endpoint.
25. File uploads must use **FormData / multipart/form-data**, not JSON.
26. Swagger UI is available at `/swagger/` for API testing.

---

# 42. Recommended End-to-End Testing Order

For testing the complete system, follow this sequence.

### Phase 1 — Student

```text
Register Student
↓
Login
↓
Get /me
↓
View Approved Courses
↓
Enroll
↓
View Course Details
↓
Take Quiz
↓
Submit Quiz
↓
Mark Lessons Complete
↓
Check Course Progress
↓
Reach 100%
↓
Generate Certificate
↓
View Certificates
```

### Phase 2 — Teacher

```text
Register Teacher
↓
Admin Approves Teacher
↓
Teacher Login
↓
Create Course
↓
Create Chapter
↓
Create Lesson
↓
Upload Video/PDF
↓
Create Quiz
↓
Create Questions + Choices
↓
Admin Approves Course
↓
Publish Course
↓
View Quiz Results
```

### Phase 3 — Admin

```text
Login
↓
View Users
↓
Approve Teacher
↓
View Course
↓
Approve Course
OR
Reject Course
↓
View Dashboard
```

This gives you a complete, organized specification covering **all endpoints, workflows, roles, permissions, authentication, file uploads, quiz security, progress, certificates, admin operations, business rules, and API testing guidance** from the requirements you provided.
