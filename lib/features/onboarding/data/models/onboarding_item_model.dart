import '../../domain/entities/onboarding_item_entity.dart';

class OnboardingItemModel extends OnboardingItemEntity {
  const OnboardingItemModel({
    required super.id,
    required super.badge,
    required super.title,
    required super.description,
    required super.iconCodePoint,
    required super.accentColorValue,
    required super.secondaryIconCodePoint,
  });

  factory OnboardingItemModel.fromJson(Map<String, dynamic> json) {
    return OnboardingItemModel(
      id: json['id'] as int? ?? 0,
      badge: json['badge'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconCodePoint: json['icon_code_point'] as int? ?? 0,
      accentColorValue: json['accent_color_value'] as int? ?? 0,
      secondaryIconCodePoint: json['secondary_icon_code_point'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'badge': badge,
      'title': title,
      'description': description,
      'icon_code_point': iconCodePoint,
      'accent_color_value': accentColorValue,
      'secondary_icon_code_point': secondaryIconCodePoint,
    };
  }
}
