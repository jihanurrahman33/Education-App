import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/onboarding_repository.dart';

class CheckOnboardingStatusUseCase implements UseCase<bool, NoParams> {
  final OnboardingRepository _repository;

  const CheckOnboardingStatusUseCase(this._repository);

  @override
  ResultFuture<bool> call(NoParams params) async {
    return _repository.isOnboardingCompleted();
  }
}
