import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/admin_user_entity.dart';
import '../repositories/admin_repository.dart';

class GetUsersParams extends Equatable {
  final int? page;
  final String? search;

  const GetUsersParams({this.page, this.search});

  @override
  List<Object?> get props => [page, search];
}

class GetUsersUseCase implements UseCase<List<AdminUserEntity>, GetUsersParams> {
  final AdminRepository repository;

  const GetUsersUseCase(this.repository);

  @override
  ResultFuture<List<AdminUserEntity>> call([GetUsersParams params = const GetUsersParams()]) {
    return repository.getUsers(page: params.page, search: params.search);
  }
}
