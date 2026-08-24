import 'package:equatable/equatable.dart';
import '../../domain/entities/onboarding_item_entity.dart';

enum OnboardingStatus { initial, loading, loaded, completed, error }

class OnboardingState extends Equatable {
  final OnboardingStatus status;
  final List<OnboardingItemEntity> items;
  final int currentPageIndex;
  final String? errorMessage;

  const OnboardingState({
    this.status = OnboardingStatus.initial,
    this.items = const [],
    this.currentPageIndex = 0,
    this.errorMessage,
  });

  bool get isLastPage => items.isNotEmpty && currentPageIndex == items.length - 1;

  OnboardingState copyWith({
    OnboardingStatus? status,
    List<OnboardingItemEntity>? items,
    int? currentPageIndex,
    String? errorMessage,
  }) {
    return OnboardingState(
      status: status ?? this.status,
      items: items ?? this.items,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, currentPageIndex, errorMessage];
}
