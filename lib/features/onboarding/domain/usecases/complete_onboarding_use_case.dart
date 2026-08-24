import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase implements UseCase<void, NoParams> {
  final OnboardingRepository _repository;

  const CompleteOnboardingUseCase(this._repository);

  @override
  ResultFuture<void> call(NoParams params) async {
    return _repository.completeOnboarding();
  }
}
