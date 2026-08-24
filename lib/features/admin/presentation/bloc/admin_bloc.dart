import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/approve_course_use_case.dart';
import '../../domain/usecases/approve_teacher_use_case.dart';
import '../../domain/usecases/create_user_use_case.dart';
import '../../domain/usecases/delete_user_use_case.dart';
import '../../domain/usecases/get_admin_stats_use_case.dart';
import '../../domain/usecases/get_pending_courses_use_case.dart';
import '../../domain/usecases/get_pending_teachers_use_case.dart';
import '../../domain/usecases/get_top_courses_use_case.dart';
import '../../domain/usecases/get_users_use_case.dart';
import '../../domain/usecases/patch_user_use_case.dart';
import '../../domain/usecases/reject_course_use_case.dart';
import '../../domain/usecases/update_user_use_case.dart';
import 'admin_event.dart';
import 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetAdminStatsUseCase getAdminStatsUseCase;
  final GetTopCoursesUseCase getTopCoursesUseCase;
  final GetPendingTeachersUseCase getPendingTeachersUseCase;
  final ApproveTeacherUseCase approveTeacherUseCase;
  final GetPendingCoursesUseCase getPendingCoursesUseCase;
  final ApproveCourseUseCase approveCourseUseCase;
  final RejectCourseUseCase rejectCourseUseCase;
  final GetUsersUseCase getUsersUseCase;
  final CreateUserUseCase createUserUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final PatchUserUseCase patchUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  AdminBloc({
    required this.getAdminStatsUseCase,
    required this.getTopCoursesUseCase,
    required this.getPendingTeachersUseCase,
    required this.approveTeacherUseCase,
    required this.getPendingCoursesUseCase,
    required this.approveCourseUseCase,
    required this.rejectCourseUseCase,
    required this.getUsersUseCase,
    required this.createUserUseCase,
    required this.updateUserUseCase,
    required this.patchUserUseCase,
    required this.deleteUserUseCase,
  }) : super(const AdminState()) {
    on<LoadAdminDashboardEvent>(_onLoadAdminDashboard);
    on<LoadPendingTeachersEvent>(_onLoadPendingTeachers);
    on<ApproveTeacherEvent>(_onApproveTeacher);
    on<LoadPendingCoursesEvent>(_onLoadPendingCourses);
    on<ApproveCourseEvent>(_onApproveCourse);
    on<RejectCourseEvent>(_onRejectCourse);
    on<LoadAdminUsersEvent>(_onLoadAdminUsers);
    on<CreateAdminUserEvent>(_onCreateAdminUser);
    on<UpdateAdminUserEvent>(_onUpdateAdminUser);
    on<ToggleUserStatusEvent>(_onToggleUserStatus);
    on<DeleteAdminUserEvent>(_onDeleteAdminUser);
  }

  Future<void> _onLoadAdminDashboard(
    LoadAdminDashboardEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(status: AdminStatus.loading, clearMessages: true));

    final results = await Future.wait([
      getAdminStatsUseCase(const NoParams()),
      getTopCoursesUseCase(const NoParams()),
    ]);

    final statsRes = results[0];
    final topRes = results[1];

    statsRes.fold(
      (failure) => emit(state.copyWith(
        status: AdminStatus.failure,
        errorMessage: failure.message,
      )),
      (stats) {
        topRes.fold(
          (failure) => emit(state.copyWith(
            status: AdminStatus.success,
            dashboardStats: stats as dynamic,
          )),
          (topCourses) => emit(state.copyWith(
            status: AdminStatus.success,
            dashboardStats: stats as dynamic,
            topCourses: topCourses as dynamic,
          )),
        );
      },
    );
  }

  Future<void> _onLoadPendingTeachers(
    LoadPendingTeachersEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(status: AdminStatus.loading, clearMessages: true));

    final result = await getPendingTeachersUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminStatus.failure,
        errorMessage: failure.message,
      )),
      (teachers) => emit(state.copyWith(
        status: AdminStatus.success,
        pendingTeachers: teachers,
      )),
    );
  }

  Future<void> _onApproveTeacher(
    ApproveTeacherEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await approveTeacherUseCase(event.teacherId);

    result.fold(
      (failure) => emit(state.copyWith(
        errorMessage: failure.message,
      )),
      (_) {
        final updated = state.pendingTeachers.where((t) => t.id != event.teacherId).toList();
        emit(state.copyWith(
          pendingTeachers: updated,
          successMessage: 'Teacher approved successfully!',
        ));
      },
    );
  }

  Future<void> _onLoadPendingCourses(
    LoadPendingCoursesEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(status: AdminStatus.loading, clearMessages: true));

    final result = await getPendingCoursesUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminStatus.failure,
        errorMessage: failure.message,
      )),
      (courses) => emit(state.copyWith(
        status: AdminStatus.success,
        pendingCourses: courses,
      )),
    );
  }

  Future<void> _onApproveCourse(
    ApproveCourseEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await approveCourseUseCase(event.courseId);

    result.fold(
      (failure) => emit(state.copyWith(
        errorMessage: failure.message,
      )),
      (_) {
        final updated = state.pendingCourses.where((c) => c.id != event.courseId).toList();
        emit(state.copyWith(
          pendingCourses: updated,
          successMessage: 'Course publication approved!',
        ));
      },
    );
  }

  Future<void> _onRejectCourse(
    RejectCourseEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await rejectCourseUseCase(event.courseId);

    result.fold(
      (failure) => emit(state.copyWith(
        errorMessage: failure.message,
      )),
      (_) {
        final updated = state.pendingCourses.where((c) => c.id != event.courseId).toList();
        emit(state.copyWith(
          pendingCourses: updated,
          successMessage: 'Course publication rejected.',
        ));
      },
    );
  }

  Future<void> _onLoadAdminUsers(
    LoadAdminUsersEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(status: AdminStatus.loading, clearMessages: true));

    final result = await getUsersUseCase(event.page);

    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminStatus.failure,
        errorMessage: failure.message,
      )),
      (users) => emit(state.copyWith(
        status: AdminStatus.success,
        users: users,
      )),
    );
  }

  Future<void> _onCreateAdminUser(
    CreateAdminUserEvent event,
    Emitter<AdminState> emit,
  ) async {
    emit(state.copyWith(status: AdminStatus.loading, clearMessages: true));

    final result = await createUserUseCase(CreateUserParams(
      username: event.username,
      email: event.email,
      password: event.password,
      role: event.role,
      firstName: event.firstName,
      lastName: event.lastName,
      phone: event.phone,
      isActive: event.isActive,
      isApprovedTeacher: event.isApprovedTeacher,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        status: AdminStatus.failure,
        errorMessage: failure.message,
      )),
      (newUser) {
        final updated = [newUser, ...state.users];
        emit(state.copyWith(
          status: AdminStatus.success,
          users: updated,
          successMessage: 'User created successfully!',
        ));
      },
    );
  }

  Future<void> _onUpdateAdminUser(
    UpdateAdminUserEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await updateUserUseCase(UpdateUserParams(
      id: event.id,
      username: event.username,
      email: event.email,
      firstName: event.firstName,
      lastName: event.lastName,
      role: event.role,
      phone: event.phone,
      isActive: event.isActive,
      isApprovedTeacher: event.isApprovedTeacher,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        errorMessage: failure.message,
      )),
      (updatedUser) {
        final updated = state.users.map((u) => u.id == event.id ? updatedUser : u).toList();
        emit(state.copyWith(
          users: updated,
          successMessage: 'User details updated!',
        ));
      },
    );
  }

  Future<void> _onToggleUserStatus(
    ToggleUserStatusEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await patchUserUseCase(PatchUserParams(
      id: event.userId,
      isActive: event.isActive,
    ));

    result.fold(
      (failure) => emit(state.copyWith(
        errorMessage: failure.message,
      )),
      (patchedUser) {
        final updated = state.users.map((u) => u.id == event.userId ? patchedUser : u).toList();
        emit(state.copyWith(
          users: updated,
          successMessage: 'User status updated to ${event.isActive ? 'Active' : 'Inactive'}',
        ));
      },
    );
  }

  Future<void> _onDeleteAdminUser(
    DeleteAdminUserEvent event,
    Emitter<AdminState> emit,
  ) async {
    final result = await deleteUserUseCase(event.userId);

    result.fold(
      (failure) => emit(state.copyWith(
        errorMessage: failure.message,
      )),
      (_) {
        final updated = state.users.where((u) => u.id != event.userId).toList();
        emit(state.copyWith(
          users: updated,
          successMessage: 'User permanently deleted.',
        ));
      },
    );
  }
}
