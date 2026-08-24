import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadStudentDashboardEvent extends DashboardEvent {
  const LoadStudentDashboardEvent();
}

class LoadTeacherDashboardEvent extends DashboardEvent {
  const LoadTeacherDashboardEvent();
}

class LoadAdminDashboardMetricsEvent extends DashboardEvent {
  const LoadAdminDashboardMetricsEvent();
}
