import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/onboarding_item_entity.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingItemsUseCase implements UseCase<List<OnboardingItemEntity>, NoParams> {
  final OnboardingRepository _repository;

  const GetOnboardingItemsUseCase(this._repository);

  @override
  ResultFuture<List<OnboardingItemEntity>> call(NoParams params) async {
    return _repository.getOnboardingItems();
  }
}
