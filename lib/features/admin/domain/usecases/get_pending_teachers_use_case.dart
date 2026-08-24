import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_repository.dart';

class GetPendingTeachersParams extends Equatable {
  final int? page;

  const GetPendingTeachersParams({this.page});

  @override
  List<Object?> get props => [page];
}

class GetPendingTeachersUseCase implements UseCase<List<AdminUserEntity>, GetPendingTeachersParams> {
  final AdminRepository _repository;

  const GetPendingTeachersUseCase(this._repository);

  @override
  ResultFuture<List<AdminUserEntity>> call([GetPendingTeachersParams params = const GetPendingTeachersParams()]) {
    return _repository.getPendingTeachers(page: params.page);
  }
}
