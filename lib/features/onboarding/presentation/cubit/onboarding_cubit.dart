import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/check_onboarding_status_use_case.dart';
import '../../domain/usecases/complete_onboarding_use_case.dart';
import '../../domain/usecases/get_onboarding_items_use_case.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final GetOnboardingItemsUseCase getOnboardingItemsUseCase;
  final CompleteOnboardingUseCase completeOnboardingUseCase;
  final CheckOnboardingStatusUseCase checkOnboardingStatusUseCase;

  OnboardingCubit({
    required this.getOnboardingItemsUseCase,
    required this.completeOnboardingUseCase,
    required this.checkOnboardingStatusUseCase,
  }) : super(const OnboardingState());

  Future<void> loadOnboardingData() async {
    emit(state.copyWith(status: OnboardingStatus.loading));

    final result = await getOnboardingItemsUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OnboardingStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (items) => emit(
        state.copyWith(
          status: OnboardingStatus.loaded,
          items: items,
          currentPageIndex: 0,
        ),
      ),
    );
  }

  void onPageChanged(int index) {
    emit(state.copyWith(currentPageIndex: index));
  }

  Future<void> completeOnboarding() async {
    final result = await completeOnboardingUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OnboardingStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: OnboardingStatus.completed)),
    );
  }

  Future<bool> checkStatus() async {
    final result = await checkOnboardingStatusUseCase(const NoParams());
    return result.fold(
      (_) => false,
      (isCompleted) => isCompleted,
    );
  }
}
