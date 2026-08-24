import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../certificates/domain/entities/certificate_entity.dart';
import '../../domain/entities/progress_entity.dart';
import '../../domain/usecases/enroll_in_course_usecase.dart';
import '../../domain/usecases/generate_certificate_usecase.dart';
import '../../domain/usecases/get_certificates_usecase.dart';
import '../../domain/usecases/get_completed_lessons_usecase.dart';
import '../../domain/usecases/get_course_progress_usecase.dart';
import '../../domain/usecases/get_enrollments_usecase.dart';
import '../../domain/usecases/get_my_progress_usecase.dart';
import '../../domain/usecases/get_progress_summary_usecase.dart';
import '../../domain/usecases/get_teacher_course_students_progress_usecase.dart';
import '../../domain/usecases/mark_lesson_completed_usecase.dart';
import 'progress_event.dart';
import 'progress_state.dart';

class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final GetProgressSummaryUseCase getProgressSummaryUseCase;
  final GetMyProgressUseCase getMyProgressUseCase;
  final GetCourseProgressUseCase getCourseProgressUseCase;
  final EnrollInCourseUseCase enrollInCourseUseCase;
  final GetEnrollmentsUseCase getEnrollmentsUseCase;
  final MarkLessonCompletedUseCase markLessonCompletedUseCase;
  final GetCompletedLessonsUseCase getCompletedLessonsUseCase;
  final GenerateCertificateUseCase generateCertificateUseCase;
  final GetCertificatesUseCase getCertificatesUseCase;
  final GetTeacherCourseStudentsProgressUseCase getTeacherCourseStudentsProgressUseCase;

  ProgressBloc({
    required this.getProgressSummaryUseCase,
    required this.getMyProgressUseCase,
    required this.getCourseProgressUseCase,
    required this.enrollInCourseUseCase,
    required this.getEnrollmentsUseCase,
    required this.markLessonCompletedUseCase,
    required this.getCompletedLessonsUseCase,
    required this.generateCertificateUseCase,
    required this.getCertificatesUseCase,
    required this.getTeacherCourseStudentsProgressUseCase,
  }) : super(const ProgressState()) {
    on<LoadProgressSummaryEvent>(_onLoadProgressSummary);
    on<LoadMyProgressEvent>(_onLoadMyProgress);
    on<LoadCourseProgressEvent>(_onLoadCourseProgress);
    on<EnrollCourseProgressEvent>(_onEnrollCourse);
    on<CompleteLessonProgressEvent>(_onCompleteLesson);
    on<LoadCompletedLessonsEvent>(_onLoadCompletedLessons);
    on<LoadEnrollmentsEvent>(_onLoadEnrollments);
    on<GenerateCertificateProgressEvent>(_onGenerateCertificate);
    on<LoadTeacherCourseStudentsProgressEvent>(_onLoadTeacherCourseStudentsProgress);
  }

  Future<void> _onLoadProgressSummary(
    LoadProgressSummaryEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(state.copyWith(status: ProgressStatus.loading, clearMessages: true));

    final result = await getProgressSummaryUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProgressStatus.failure,
        errorMessage: failure.message,
      )),
      (summary) => emit(state.copyWith(
        status: ProgressStatus.success,
        summary: summary,
      )),
    );
  }

  Future<void> _onLoadMyProgress(
    LoadMyProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(state.copyWith(status: ProgressStatus.loading, clearMessages: true));

    final results = await Future.wait([
      getMyProgressUseCase(),
      getCertificatesUseCase(),
      getCompletedLessonsUseCase(),
    ]);

    final progressRes = results[0];
    final certsRes = results[1];
    final completedRes = results[2];

    progressRes.fold(
      (failure) => emit(state.copyWith(
        status: ProgressStatus.failure,
        errorMessage: failure.message,
      )),
      (progressList) {
        final certsList = certsRes.fold(
          (_) => <CertificateEntity>[],
          (certs) => certs as List<CertificateEntity>,
        );
        final completedList = completedRes.fold(
          (_) => <CompletedLessonEntity>[],
          (lessons) => lessons as List<CompletedLessonEntity>,
        );

        emit(state.copyWith(
          status: ProgressStatus.success,
          myProgress: progressList as dynamic,
          certificates: certsList,
          completedLessons: completedList,
        ));
      },
    );
  }

  Future<void> _onLoadCourseProgress(
    LoadCourseProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final result = await getCourseProgressUseCase(event.courseId);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (progress) {
        final updatedMap = Map<int, CourseProgressEntity>.from(state.courseProgressMap);
        updatedMap[event.courseId] = progress;
        emit(state.copyWith(
          status: ProgressStatus.success,
          courseProgressMap: updatedMap,
        ));
      },
    );
  }

  Future<void> _onEnrollCourse(
    EnrollCourseProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final result = await enrollInCourseUseCase(event.courseId);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(
          successMessage: 'Enrolled in course successfully!',
        ));
        add(LoadCourseProgressEvent(event.courseId));
        add(const LoadMyProgressEvent());
      },
    );
  }

  Future<void> _onCompleteLesson(
    CompleteLessonProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    final result = await markLessonCompletedUseCase(
      MarkLessonCompletedParams(lessonId: event.lessonId),
    );

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (_) {
        emit(state.copyWith(
          successMessage: 'Lesson marked as completed!',
        ));
        if (event.courseId != null) {
          add(LoadCourseProgressEvent(event.courseId!));
        }
        add(const LoadMyProgressEvent());
      },
    );
  }

  Future<void> _onLoadCompletedLessons(
    LoadCompletedLessonsEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(state.copyWith(status: ProgressStatus.loading, clearMessages: true));

    final result = await getCompletedLessonsUseCase(event.page);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProgressStatus.failure,
        errorMessage: failure.message,
      )),
      (lessons) => emit(state.copyWith(
        status: ProgressStatus.success,
        completedLessons: lessons,
      )),
    );
  }

  Future<void> _onLoadEnrollments(
    LoadEnrollmentsEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(state.copyWith(status: ProgressStatus.loading, clearMessages: true));

    final result = await getEnrollmentsUseCase(event.page);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProgressStatus.failure,
        errorMessage: failure.message,
      )),
      (enrollments) => emit(state.copyWith(
        status: ProgressStatus.success,
        enrollments: enrollments,
      )),
    );
  }

  Future<void> _onGenerateCertificate(
    GenerateCertificateProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(state.copyWith(status: ProgressStatus.loading, clearMessages: true));

    final result = await generateCertificateUseCase(event.courseId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProgressStatus.failure,
        errorMessage: failure.message,
      )),
      (cert) {
        final updated = [cert, ...state.certificates];
        emit(state.copyWith(
          status: ProgressStatus.success,
          certificates: updated,
          successMessage: 'Certificate earned for "${cert.courseTitle}"!',
        ));
      },
    );
  }

  Future<void> _onLoadTeacherCourseStudentsProgress(
    LoadTeacherCourseStudentsProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(state.copyWith(status: ProgressStatus.loading, clearMessages: true));

    final result = await getTeacherCourseStudentsProgressUseCase(event.courseId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: ProgressStatus.failure,
        errorMessage: failure.message,
      )),
      (progress) => emit(state.copyWith(
        status: ProgressStatus.success,
        teacherCourseProgress: progress,
      )),
    );
  }
}
