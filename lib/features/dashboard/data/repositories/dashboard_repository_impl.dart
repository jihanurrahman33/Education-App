import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/student_dashboard_entity.dart';
import '../../domain/entities/teacher_dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  const DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<StudentDashboardEntity> getStudentDashboard() async {
    try {
      final summary = await remoteDataSource.getStudentDashboard();
      return Right(summary);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<TeacherDashboardEntity> getTeacherDashboard() async {
    try {
      final summary = await remoteDataSource.getTeacherDashboard();
      return Right(summary);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
