import 'package:equatable/equatable.dart';
import '../utils/typedefs.dart';

abstract class UseCase<Type, Params> {
  const UseCase();
  ResultFuture<Type> call(Params params);
}

abstract class UseCaseWithoutParams<Type> {
  const UseCaseWithoutParams();
  ResultFuture<Type> call();
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
