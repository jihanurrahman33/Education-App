# EduFlow — End-to-End User Workflows & Journey Guides

This document outlines the complete user journeys, business flows, and interaction sequences for all three roles in EduFlow: **Student**, **Teacher**, and **Admin**.

---

## 1. Student Journey

```mermaid
sequenceDiagram
    autonumber
    actor Student
    participant Auth as AuthBloc & API
    participant Catalog as CoursesBloc & Catalog
    participant Learning as Lesson Player
    participant Assessment as QuizBloc
    participant Progress as ProgressBloc
    participant Cert as CertificatesBloc

    Student->>Auth: Register (role: 'student') & Login
    Auth-->>Student: JWT Access & Refresh Tokens stored in SharedPreferences
    Student->>Catalog: Browse Approved Courses Catalog
    Student->>Catalog: Enroll in Course (POST /api/progress/enroll/)
    Catalog-->>Student: Enrollment Confirmed & Curriculum Unlocked
    Student->>Learning: Watch Video / Read PDF Lesson
    Student->>Progress: Complete Lesson (POST /api/progress/complete/)
    Progress-->>Student: Progress updated in real-time
    Student->>Assessment: Take Course Assessment Quiz
    Assessment->>Assessment: Submit Answers (POST /api/quizzes/{id}/submit/)
    Assessment-->>Student: Score & Pass/Fail Evaluation
    Student->>Progress: Complete 100% of Curriculum
    Student->>Cert: Generate Certificate (POST /api/progress/certificate/{course_id}/)
    Cert-->>Student: Verified Official Certificate PDF & Credential ID
```

### Key Student Milestones:
1. **Authentication:** Registration and Login with automatic token refresh.
2. **Discovery & Enrollment:** Browse approved catalog, view course syllabus, and confirm enrollment.
3. **Interactive Learning:** Watch video lectures, download lesson PDFs, and read textual guides.
4. **Lesson Progression:** Automatically track completed lessons and progress percentages.
5. **Quiz Assessments:** Take timed modular quizzes and review detailed performance breakdowns.
6. **Credentialing:** Claim and download official certificates of completion upon reaching 100% course progress.

---

## 2. Teacher Journey

```mermaid
sequenceDiagram
    autonumber
    actor Teacher
    participant Auth as AuthBloc
    participant Admin as Admin Moderation
    participant Builder as Course Builder
    participant Curriculum as Curriculum Manager
    participant QuizManager as Quiz Manager

    Teacher->>Auth: Register (role: 'teacher')
    Auth-->>Teacher: Account Created (status: is_approved_teacher = false)
    Teacher->>Teacher: Wait on Pending Teacher Screen
    Admin->>Admin: Review Teacher & Approve Account
    Teacher->>Auth: Login as Approved Teacher
    Teacher->>Builder: Create Course Draft (Title, Description, Category)
    Builder->>Curriculum: Navigate to Curriculum Manager
    Teacher->>Curriculum: Add Chapters (Module 1, Module 2)
    Teacher->>Curriculum: Add Lessons & Upload Media (MP4 Video / PDF Notes)
    Teacher->>QuizManager: Create Assessment Quiz & Question Bank
    Teacher->>Curriculum: Submit for Publication (POST /api/courses/{id}/toggle-publish/)
    Curriculum-->>Teacher: Status updated to 'Submitted for Moderation'
    Admin->>Admin: Review Curriculum Quality & Approve Course
    Curriculum-->>Teacher: Course is Live in Student Catalog
```

### Key Teacher Milestones:
1. **Registration & Approval:** Register as instructor and await administrator account approval.
2. **Course Creation:** Define course title, description, category, and pricing.
3. **Curriculum Design:** Organize course into structured chapters and modules.
4. **Content Uploads:** Upload high-definition video lectures (MP4) and downloadable reading guides (PDF).
5. **Assessment Authoring:** Create quizzes with customizable question choices and pass criteria.
6. **Publication Submission:** Submit finalized curriculum for administrative quality moderation.
7. **Student Analytics:** Review enrolled students' completion rates and quiz results.

---

## 3. Administrator Journey

```mermaid
sequenceDiagram
    autonumber
    actor Admin
    participant Dashboard as Admin Dashboard
    participant Moderation as Moderation Hub
    participant UserDir as Users Directory

    Admin->>Admin: Login with Administrator Credentials
    Admin->>Dashboard: Review Platform Analytics & Enrollment Metrics
    Admin->>Moderation: Review Pending Teacher Applications
    Admin->>Moderation: Approve / Reject Teacher Accounts
    Admin->>Moderation: Review Submitted Course Curriculum Drafts
    Admin->>Moderation: Inspect Lessons & Verify Quality
    Admin->>Moderation: Approve Course for Publication / Reject with Feedback
    Admin->>UserDir: Full User Management (Search, Edit Roles, Toggle Status, Delete)
```

### Key Admin Milestones:
1. **Platform Analytics:** Monitor total registered learners, published courses, quiz completion stats, and top course leaderboards.
2. **Teacher Account Moderation:** Review instructor credentials and grant platform publishing rights.
3. **Curriculum Moderation:** Inspect course syllabus, verify lesson videos and PDFs, and approve or reject submissions.
4. **User Directory Governance:** Search, filter, inspect profiles, update user roles, and deactivate or delete accounts.
