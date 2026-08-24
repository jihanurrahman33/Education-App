import 'package:equatable/equatable.dart';

class OnboardingItemEntity extends Equatable {
  final int id;
  final String badge;
  final String title;
  final String description;
  final int iconCodePoint;
  final int accentColorValue;
  final int secondaryIconCodePoint;

  const OnboardingItemEntity({
    required this.id,
    required this.badge,
    required this.title,
    required this.description,
    required this.iconCodePoint,
    required this.accentColorValue,
    required this.secondaryIconCodePoint,
  });

  @override
  List<Object?> get props => [
        id,
        badge,
        title,
        description,
        iconCodePoint,
        accentColorValue,
        secondaryIconCodePoint,
      ];
}
