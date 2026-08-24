import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/custom_button.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../widgets/onboarding_indicator_widget.dart';
import '../widgets/onboarding_page_content_widget.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<OnboardingCubit>()..loadOnboardingData(),
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed(BuildContext context, OnboardingState state) {
    if (state.isLastPage) {
      context.read<OnboardingCubit>().completeOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state.status == OnboardingStatus.completed) {
          context.go('/login');
        } else if (state.status == OnboardingStatus.error && state.errorMessage != null) {
          AppToast.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        if (state.status == OnboardingStatus.loading || state.items.isEmpty) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          );
        }

        final isLastPage = state.isLastPage;

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.cosmicGradient,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Top Brand Bar with Skip Action
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  'assets/icon.png',
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.school_rounded,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              AppConstants.appName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        if (!isLastPage)
                          TextButton(
                            onPressed: () => context.read<OnboardingCubit>().completeOnboarding(),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.textSecondary,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            ),
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        else
                          const SizedBox(height: 36, width: 48),
                      ],
                    ),
                  ),

                  // PageView (3 Clean Pages)
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: state.items.length,
                      onPageChanged: (index) {
                        context.read<OnboardingCubit>().onPageChanged(index);
                      },
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return OnboardingPageContentWidget(item: item);
                      },
                    ),
                  ),

                  // Bottom Section with Animated Indicator & Single Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OnboardingIndicatorWidget(
                          totalPages: state.items.length,
                          currentPageIndex: state.currentPageIndex,
                        ),
                        const SizedBox(height: 28),

                        // Single Action Button
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: CustomButton(
                            key: ValueKey<bool>(isLastPage),
                            text: isLastPage ? 'Get Started' : 'Next',
                            icon: isLastPage
                                ? Icons.arrow_forward_rounded
                                : Icons.chevron_right_rounded,
                            onPressed: () => _onNextPressed(context, state),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
