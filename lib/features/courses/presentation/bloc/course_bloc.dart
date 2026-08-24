import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/usecases/create_chapter_usecase.dart';
import '../../domain/usecases/create_course_usecase.dart';
import '../../domain/usecases/create_lesson_usecase.dart';
import '../../domain/usecases/delete_chapter_usecase.dart';
import '../../domain/usecases/delete_course_usecase.dart';
import '../../domain/usecases/delete_lesson_usecase.dart';
import '../../domain/usecases/enroll_course_usecase.dart';
import '../../domain/usecases/get_approved_courses_usecase.dart';
import '../../domain/usecases/get_course_details_usecase.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import '../../domain/usecases/get_teacher_courses_usecase.dart';
import '../../domain/usecases/toggle_publish_course_usecase.dart';
import '../../domain/usecases/update_chapter_usecase.dart';
import '../../domain/usecases/update_course_usecase.dart';
import 'course_event.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCoursesUseCase getCoursesUseCase;
  final GetApprovedCoursesUseCase getApprovedCoursesUseCase;
  final GetTeacherCoursesUseCase getTeacherCoursesUseCase;
  final GetCourseDetailsUseCase getCourseDetailsUseCase;
  final CreateCourseUseCase createCourseUseCase;
  final UpdateCourseUseCase updateCourseUseCase;
  final DeleteCourseUseCase deleteCourseUseCase;
  final TogglePublishCourseUseCase togglePublishCourseUseCase;
  final CreateChapterUseCase createChapterUseCase;
  final UpdateChapterUseCase updateChapterUseCase;
  final DeleteChapterUseCase deleteChapterUseCase;
  final CreateLessonUseCase createLessonUseCase;
  final DeleteLessonUseCase deleteLessonUseCase;
  final EnrollCourseUseCase enrollCourseUseCase;

  CourseBloc({
    required this.getCoursesUseCase,
    required this.getApprovedCoursesUseCase,
    required this.getTeacherCoursesUseCase,
    required this.getCourseDetailsUseCase,
    required this.createCourseUseCase,
    required this.updateCourseUseCase,
    required this.deleteCourseUseCase,
    required this.togglePublishCourseUseCase,
    required this.createChapterUseCase,
    required this.updateChapterUseCase,
    required this.deleteChapterUseCase,
    required this.createLessonUseCase,
    required this.deleteLessonUseCase,
    required this.enrollCourseUseCase,
  }) : super(const CourseState()) {
    on<FetchCoursesRequested>(_onFetchCoursesRequested);
    on<FetchApprovedCoursesRequested>(_onFetchApprovedCoursesRequested);
    on<FetchTeacherCoursesRequested>(_onFetchTeacherCoursesRequested);
    on<FetchCourseDetailsRequested>(_onFetchCourseDetailsRequested);
    on<CreateCourseRequested>(_onCreateCourseRequested);
    on<UpdateCourseRequested>(_onUpdateCourseRequested);
    on<TogglePublishCourseRequested>(_onTogglePublishCourseRequested);
    on<DeleteCourseRequested>(_onDeleteCourseRequested);
    on<CreateChapterRequested>(_onCreateChapterRequested);
    on<UpdateChapterRequested>(_onUpdateChapterRequested);
    on<DeleteChapterRequested>(_onDeleteChapterRequested);
    on<CreateLessonRequested>(_onCreateLessonRequested);
    on<DeleteLessonRequested>(_onDeleteLessonRequested);
    on<EnrollCourseRequested>(_onEnrollCourseRequested);
  }

  Future<void> _onFetchCoursesRequested(
    FetchCoursesRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(
      status: CourseStatus.loading,
      clearMessages: true,
    ));

    final result = await getCoursesUseCase(
      GetCoursesParams(
        category: event.category,
        searchQuery: event.searchQuery,
        page: event.page,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: CourseStatus.error,
        errorMessage: failure.message,
      )),
      (courses) => emit(state.copyWith(
        status: CourseStatus.loaded,
        courses: courses,
        clearMessages: true,
      )),
    );
  }

  Future<void> _onFetchApprovedCoursesRequested(
    FetchApprovedCoursesRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(
      status: CourseStatus.loading,
      clearMessages: true,
    ));

    final result = await getApprovedCoursesUseCase(event.page);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CourseStatus.error,
        errorMessage: failure.message,
      )),
      (courses) => emit(state.copyWith(
        status: CourseStatus.loaded,
        approvedCourses: courses,
        clearMessages: true,
      )),
    );
  }

  Future<void> _onFetchTeacherCoursesRequested(
    FetchTeacherCoursesRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(
      status: CourseStatus.loading,
      clearMessages: true,
    ));

    final result = await getTeacherCoursesUseCase(event.page);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CourseStatus.error,
        errorMessage: failure.message,
      )),
      (courses) => emit(state.copyWith(
        status: CourseStatus.loaded,
        teacherCourses: courses,
        clearMessages: true,
      )),
    );
  }

  Future<void> _onFetchCourseDetailsRequested(
    FetchCourseDetailsRequested event,
    Emitter<CourseState> emit,
  ) async {
    final isDifferentCourse = state.selectedCourse != null &&
        state.selectedCourse!.id != event.courseId;

    emit(state.copyWith(
      status: CourseStatus.loading,
      selectedCourse: isDifferentCourse ? null : state.selectedCourse,
      curriculum: isDifferentCourse ? const [] : state.curriculum,
      clearMessages: true,
    ));

    final result = await getCourseDetailsUseCase(
      GetCourseDetailsParams(courseId: event.courseId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: CourseStatus.error,
        errorMessage: failure.message,
      )),
      (course) => emit(state.copyWith(
        status: CourseStatus.loaded,
        selectedCourse: course,
        curriculum: course.chapters,
        clearMessages: true,
      )),
    );
  }

  Future<void> _onCreateCourseRequested(
    CreateCourseRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(status: CourseStatus.loading, clearMessages: true));

    final result = await createCourseUseCase(CreateCourseParams(
      title: event.title,
      description: event.description,
      isPublished: event.isPublished,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: CourseStatus.error,
        errorMessage: failure.message,
      )),
      (newCourse) {
        final updated = [newCourse, ...state.teacherCourses];
        emit(state.copyWith(
          status: CourseStatus.loaded,
          teacherCourses: updated,
          selectedCourse: newCourse,
          curriculum: const [],
          successMessage: 'Course created successfully!',
        ));
      },
    );
  }

  Future<void> _onUpdateCourseRequested(
    UpdateCourseRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(clearMessages: true));

    final result = await updateCourseUseCase(UpdateCourseParams(
      id: event.courseId,
      title: event.title,
      description: event.description,
      isPublished: event.isPublished,
    ));

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (updatedCourse) {
        final mergedCourse = updatedCourse.copyWith(
          chapters: state.curriculum.isNotEmpty
              ? state.curriculum
              : updatedCourse.chapters,
        );
        final updatedList = state.teacherCourses
            .map((c) => c.id == event.courseId ? mergedCourse : c)
            .toList();
        emit(state.copyWith(
          teacherCourses: updatedList,
          selectedCourse: mergedCourse,
          successMessage: 'Course details updated!',
        ));
      },
    );
  }

  Future<void> _onTogglePublishCourseRequested(
    TogglePublishCourseRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(clearMessages: true));

    final result = await togglePublishCourseUseCase(event.courseId);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (updatedCourse) {
        final mergedCourse = updatedCourse.copyWith(
          chapters: state.curriculum.isNotEmpty
              ? state.curriculum
              : updatedCourse.chapters,
        );
        final updatedList = state.teacherCourses
            .map((c) => c.id == event.courseId ? mergedCourse : c)
            .toList();
        emit(state.copyWith(
          teacherCourses: updatedList,
          selectedCourse: mergedCourse,
          successMessage: mergedCourse.isPublished
              ? 'Course submitted for admin moderation approval!'
              : 'Course un-published back to draft.',
        ));
        add(FetchCourseDetailsRequested(event.courseId));
      },
    );
  }

  Future<void> _onDeleteCourseRequested(
    DeleteCourseRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(clearMessages: true));

    final result = await deleteCourseUseCase(event.courseId);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        final updated =
            state.teacherCourses.where((c) => c.id != event.courseId).toList();
        emit(state.copyWith(
          teacherCourses: updated,
          successMessage: 'Course deleted successfully.',
        ));
      },
    );
  }

  Future<void> _onCreateChapterRequested(
    CreateChapterRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(clearMessages: true));

    final result = await createChapterUseCase(CreateChapterParams(
      courseId: event.courseId,
      title: event.title,
      order: event.order,
    ));

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(successMessage: 'Chapter added successfully!'));
        add(FetchCourseDetailsRequested(event.courseId));
      },
    );
  }

  Future<void> _onUpdateChapterRequested(
    UpdateChapterRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(clearMessages: true));

    final result = await updateChapterUseCase(UpdateChapterParams(
      id: event.chapterId,
      courseId: event.courseId,
      title: event.title,
      order: event.order,
    ));

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(successMessage: 'Chapter updated!'));
        add(FetchCourseDetailsRequested(event.courseId));
      },
    );
  }

  Future<void> _onDeleteChapterRequested(
    DeleteChapterRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(clearMessages: true));

    final result = await deleteChapterUseCase(event.chapterId);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(successMessage: 'Chapter deleted!'));
        add(FetchCourseDetailsRequested(event.courseId));
      },
    );
  }

  Future<void> _onCreateLessonRequested(
    CreateLessonRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(clearMessages: true));

    final result = await createLessonUseCase(CreateLessonParams(
      chapterId: event.chapterId,
      title: event.title,
      lessonType: event.lessonType,
      textContent: event.textContent,
      durationMinutes: event.durationMinutes,
      order: event.order,
      videoFilePath: event.videoFilePath,
      pdfFilePath: event.pdfFilePath,
    ));

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(successMessage: 'Lesson created successfully!'));
        if (state.selectedCourse != null) {
          add(FetchCourseDetailsRequested(state.selectedCourse!.id));
        }
      },
    );
  }

  Future<void> _onDeleteLessonRequested(
    DeleteLessonRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(clearMessages: true));

    final result = await deleteLessonUseCase(event.lessonId);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(successMessage: 'Lesson deleted!'));
        add(FetchCourseDetailsRequested(event.courseId));
      },
    );
  }

  Future<void> _onEnrollCourseRequested(
    EnrollCourseRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(isEnrolling: true, clearMessages: true));

    final result = await enrollCourseUseCase(
      EnrollCourseParams(courseId: event.courseId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isEnrolling: false,
        errorMessage: failure.message,
      )),
      (_) {
        CourseEntity? updatedSelectedCourse;
        if (state.selectedCourse != null &&
            state.selectedCourse!.id == event.courseId) {
          updatedSelectedCourse =
              state.selectedCourse!.copyWith(isEnrolled: true);
        }

        final updatedCourses = state.courses.map((c) {
          if (c.id == event.courseId) {
            return c.copyWith(isEnrolled: true);
          }
          return c;
        }).toList();

        final updatedApprovedCourses = state.approvedCourses.map((c) {
          if (c.id == event.courseId) {
            return c.copyWith(isEnrolled: true);
          }
          return c;
        }).toList();

        emit(state.copyWith(
          isEnrolling: false,
          selectedCourse: updatedSelectedCourse ?? state.selectedCourse,
          courses: updatedCourses,
          approvedCourses: updatedApprovedCourses,
          successMessage: 'Successfully enrolled in course! Happy learning!',
        ));
      },
    );
  }
}
