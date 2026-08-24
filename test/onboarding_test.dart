import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:education_app/core/usecases/usecase.dart';
import 'package:education_app/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:education_app/features/onboarding/data/models/onboarding_item_model.dart';
import 'package:education_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:education_app/features/onboarding/domain/usecases/check_onboarding_status_use_case.dart';
import 'package:education_app/features/onboarding/domain/usecases/complete_onboarding_use_case.dart';
import 'package:education_app/features/onboarding/domain/usecases/get_onboarding_items_use_case.dart';
import 'package:education_app/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:education_app/features/onboarding/presentation/cubit/onboarding_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding Clean Architecture Suite', () {
    late SharedPreferences prefs;
    late OnboardingLocalDataSource localDataSource;
    late OnboardingRepositoryImpl repository;
    late CheckOnboardingStatusUseCase checkUseCase;
    late CompleteOnboardingUseCase completeUseCase;
    late GetOnboardingItemsUseCase getItemsUseCase;
    late OnboardingCubit cubit;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      localDataSource = OnboardingLocalDataSourceImpl(prefs);
      repository = OnboardingRepositoryImpl(localDataSource);
      checkUseCase = CheckOnboardingStatusUseCase(repository);
      completeUseCase = CompleteOnboardingUseCase(repository);
      getItemsUseCase = GetOnboardingItemsUseCase(repository);
      cubit = OnboardingCubit(
        getOnboardingItemsUseCase: getItemsUseCase,
        completeOnboardingUseCase: completeUseCase,
        checkOnboardingStatusUseCase: checkUseCase,
      );
    });

    test('OnboardingItemModel JSON serialization & deserialization', () {
      final model = OnboardingItemModel(
        id: 1,
        badge: 'DISCOVERY',
        title: 'Learn Fast',
        description: 'Quality courses',
        iconCodePoint: 1234,
        accentColorValue: 0xFFFFC107,
        secondaryIconCodePoint: 5678,
      );

      final json = model.toJson();
      expect(json['id'], equals(1));
      expect(json['badge'], equals('DISCOVERY'));

      final parsed = OnboardingItemModel.fromJson(json);
      expect(parsed, equals(model));
    });

    test('LocalDataSource and UseCases lifecycle for onboarding status', () async {
      // 1. Initial status is false
      final initialResult = await checkUseCase(const NoParams());
      expect(initialResult.isRight, isTrue);
      expect(initialResult.fold((_) => true, (val) => val), isFalse);

      // 2. Mark complete
      final completeResult = await completeUseCase(const NoParams());
      expect(completeResult.isRight, isTrue);

      // 3. Status is now true
      final updatedResult = await checkUseCase(const NoParams());
      expect(updatedResult.fold((_) => false, (val) => val), isTrue);
    });

    test('GetOnboardingItemsUseCase returns exactly 3 structured items', () async {
      final result = await getItemsUseCase(const NoParams());
      expect(result.isRight, isTrue);
      result.fold(
        (failure) => fail('Should succeed'),
        (items) {
          expect(items.length, equals(3));
          expect(items[0].id, equals(1));
          expect(items[1].id, equals(2));
          expect(items[2].id, equals(3));
        },
      );
    });

    test('OnboardingCubit state transitions, paging, and completion', () async {
      expect(cubit.state.status, equals(OnboardingStatus.initial));

      // Load data
      await cubit.loadOnboardingData();
      expect(cubit.state.status, equals(OnboardingStatus.loaded));
      expect(cubit.state.items.length, equals(3));
      expect(cubit.state.currentPageIndex, equals(0));
      expect(cubit.state.isLastPage, isFalse);

      // Page change to 2 (last page)
      cubit.onPageChanged(2);
      expect(cubit.state.currentPageIndex, equals(2));
      expect(cubit.state.isLastPage, isTrue);

      // Complete onboarding
      await cubit.completeOnboarding();
      expect(cubit.state.status, equals(OnboardingStatus.completed));

      final isCompleted = await cubit.checkStatus();
      expect(isCompleted, isTrue);
    });
  });
}
