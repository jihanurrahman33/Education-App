import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/onboarding_item_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource _localDataSource;

  const OnboardingRepositoryImpl(this._localDataSource);

  @override
  ResultFuture<bool> isOnboardingCompleted() async {
    try {
      final isCompleted = await _localDataSource.isOnboardingCompleted();
      return Right(isCompleted);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to read onboarding status: ${e.toString()}'));
    }
  }

  @override
  ResultFuture<void> completeOnboarding() async {
    try {
      await _localDataSource.completeOnboarding();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to persist onboarding status: ${e.toString()}'));
    }
  }

  @override
  ResultFuture<List<OnboardingItemEntity>> getOnboardingItems() async {
    try {
      final items = await _localDataSource.getOnboardingItems();
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to load onboarding items: ${e.toString()}'));
    }
  }
}
