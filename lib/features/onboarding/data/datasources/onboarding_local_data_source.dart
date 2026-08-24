import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/onboarding_item_model.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> isOnboardingCompleted();
  Future<void> completeOnboarding();
  Future<List<OnboardingItemModel>> getOnboardingItems();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences _prefs;

  const OnboardingLocalDataSourceImpl(this._prefs);

  @override
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool(AppConstants.onboardingCompletedKey) ?? false;
  }

  @override
  Future<void> completeOnboarding() async {
    await _prefs.setBool(AppConstants.onboardingCompletedKey, true);
  }

  @override
  Future<List<OnboardingItemModel>> getOnboardingItems() async {
    return [
      OnboardingItemModel(
        id: 1,
        badge: 'SMART DISCOVERY',
        title: 'Explore World-Class Courses',
        description:
            'Access structured modular curriculum spanning tech, science, business, and design crafted by top educators.',
        iconCodePoint: Icons.auto_stories_rounded.codePoint,
        accentColorValue: AppColors.primary.toARGB32(),
        secondaryIconCodePoint: Icons.video_collection_rounded.codePoint,
      ),
      OnboardingItemModel(
        id: 2,
        badge: 'ACTIVE RETENTION',
        title: 'Master Topics with Interactive Quizzes',
        description:
            'Reinforce your learning retention with immediate-feedback chapter assessments, choice questions, and score breakdowns.',
        iconCodePoint: Icons.quiz_rounded.codePoint,
        accentColorValue: AppColors.tertiary.toARGB32(),
        secondaryIconCodePoint: Icons.psychology_rounded.codePoint,
      ),
      OnboardingItemModel(
        id: 3,
        badge: 'VERIFIED CREDENTIALS',
        title: 'Earn Accredited Course Certificates',
        description:
            'Complete chapters at your own pace, reach 100% curriculum progress, and unlock shareable certificates.',
        iconCodePoint: Icons.workspace_premium_rounded.codePoint,
        accentColorValue: AppColors.secondaryContainer.toARGB32(),
        secondaryIconCodePoint: Icons.military_tech_rounded.codePoint,
      ),
    ];
  }
}
