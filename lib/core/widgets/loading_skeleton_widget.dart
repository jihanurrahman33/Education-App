import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// A high-performance, animated shimmer loading container.
class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.baseColor ?? AppColors.surfaceContainerLow;
    final highlight =
        widget.highlightColor ?? AppColors.surfaceContainerHigh;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                base,
                highlight,
                base,
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: _SlidingGradientTransform(slidePercent: _controller.value),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (slidePercent * 2 - 1), 0.0, 0.0);
  }
}

/// A generic skeleton box widget with rounded corners and shimmer.
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;
  final Color? color;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 8,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Animated shimmer card placeholder.
class LoadingSkeletonCard extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const LoadingSkeletonCard({
    super.key,
    this.height = 120,
    this.width = double.infinity,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SkeletonBox(width: 48, height: 48, borderRadius: 12),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonBox(height: 16, borderRadius: 4),
                      SizedBox(height: 8),
                      SkeletonBox(width: 140, height: 12, borderRadius: 4),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SkeletonBox(width: 80, height: 14, borderRadius: 4),
                SkeletonBox(width: 70, height: 22, borderRadius: 6),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Full Teacher Portal Dashboard Shimmer Skeleton.
class TeacherDashboardSkeleton extends StatelessWidget {
  const TeacherDashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 768;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(
                isWide ? 32.0 : 20.0,
                8.0,
                isWide ? 32.0 : 20.0,
                24.0,
              ),
              child: ShimmerEffect(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Banner Skeleton
                    Container(
                      height: 110,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                SkeletonBox(width: 220, height: 20, borderRadius: 6),
                                SizedBox(height: 10),
                                SkeletonBox(width: 280, height: 12, borderRadius: 4),
                              ],
                            ),
                          ),
                          const SkeletonBox(width: 44, height: 44, borderRadius: 22),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stats Row Skeleton
                    Row(
                      children: const [
                        Expanded(
                          child: SkeletonBox(height: 80, borderRadius: 16),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: SkeletonBox(height: 80, borderRadius: 16),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: SkeletonBox(height: 80, borderRadius: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Action Buttons Skeleton
                    Row(
                      children: const [
                        Expanded(
                          child: SkeletonBox(height: 50, borderRadius: 25),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: SkeletonBox(height: 50, borderRadius: 25),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // Courses Section Header Skeleton
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        SkeletonBox(width: 180, height: 20, borderRadius: 6),
                        SkeletonBox(width: 60, height: 16, borderRadius: 4),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Course Cards Skeleton
                    const LoadingSkeletonCard(height: 130),
                    const LoadingSkeletonCard(height: 130),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
