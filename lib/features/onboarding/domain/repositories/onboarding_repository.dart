import '../../../../core/utils/typedefs.dart';
import '../entities/onboarding_item_entity.dart';

abstract class OnboardingRepository {
  ResultFuture<bool> isOnboardingCompleted();
  ResultFuture<void> completeOnboarding();
  ResultFuture<List<OnboardingItemEntity>> getOnboardingItems();
}
