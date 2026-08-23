import 'package:equatable/equatable.dart';
import '../utils/typedefs.dart';

abstract class UseCase<T, Params> {
  const UseCase();
  ResultFuture<T> call(Params params);
}

abstract class UseCaseWithoutParams<T> {
  const UseCaseWithoutParams();
  ResultFuture<T> call();
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
