import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_student_dashboard_use_case.dart';
import '../../domain/usecases/get_teacher_dashboard_use_case.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetStudentDashboardUseCase getStudentDashboardUseCase;
  final GetTeacherDashboardUseCase getTeacherDashboardUseCase;

  DashboardBloc({
    required this.getStudentDashboardUseCase,
    required this.getTeacherDashboardUseCase,
  }) : super(const DashboardState()) {
    on<LoadStudentDashboardEvent>(_onLoadStudentDashboard);
    on<LoadTeacherDashboardEvent>(_onLoadTeacherDashboard);
  }

  Future<void> _onLoadStudentDashboard(
    LoadStudentDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    final result = await getStudentDashboardUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: DashboardStatus.success,
        studentData: data,
      )),
    );
  }

  Future<void> _onLoadTeacherDashboard(
    LoadTeacherDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));

    final result = await getTeacherDashboardUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: DashboardStatus.failure,
        errorMessage: failure.message,
      )),
      (data) => emit(state.copyWith(
        status: DashboardStatus.success,
        teacherData: data,
      )),
    );
  }
}
