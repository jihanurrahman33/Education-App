import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/enroll_course_usecase.dart';
import '../../domain/usecases/get_course_details_usecase.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import 'course_event.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCoursesUseCase _getCoursesUseCase;
  final GetCourseDetailsUseCase _getCourseDetailsUseCase;
  final EnrollCourseUseCase _enrollCourseUseCase;

  CourseBloc({
    required GetCoursesUseCase getCoursesUseCase,
    required GetCourseDetailsUseCase getCourseDetailsUseCase,
    required EnrollCourseUseCase enrollCourseUseCase,
  })  : _getCoursesUseCase = getCoursesUseCase,
        _getCourseDetailsUseCase = getCourseDetailsUseCase,
        _enrollCourseUseCase = enrollCourseUseCase,
        super(const CourseState()) {
    on<FetchCoursesRequested>(_onFetchCoursesRequested);
    on<FetchCourseDetailsRequested>(_onFetchCourseDetailsRequested);
    on<EnrollCourseRequested>(_onEnrollCourseRequested);
  }

  Future<void> _onFetchCoursesRequested(
    FetchCoursesRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(status: CourseStatus.loading, errorMessage: null));

    final result = await _getCoursesUseCase(
      GetCoursesParams(
        category: event.category,
        searchQuery: event.searchQuery,
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
        errorMessage: null,
      )),
    );
  }

  Future<void> _onFetchCourseDetailsRequested(
    FetchCourseDetailsRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(status: CourseStatus.loading, errorMessage: null));

    final result = await _getCourseDetailsUseCase(
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
        errorMessage: null,
      )),
    );
  }

  Future<void> _onEnrollCourseRequested(
    EnrollCourseRequested event,
    Emitter<CourseState> emit,
  ) async {
    emit(state.copyWith(isEnrolling: true));

    final result = await _enrollCourseUseCase(
      EnrollCourseParams(courseId: event.courseId),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isEnrolling: false,
        errorMessage: failure.message,
      )),
      (_) {
        final updatedCourse = state.selectedCourse != null
            ? CourseState(selectedCourse: state.selectedCourse)
            : null;
        emit(state.copyWith(
          isEnrolling: false,
        ));
      },
    );
  }
}
