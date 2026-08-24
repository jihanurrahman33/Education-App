import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../progress/domain/entities/progress_entity.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../../domain/entities/course_entity.dart';

class CourseCardWidget extends StatelessWidget {
  final CourseEntity course;
  final VoidCallback onTap;
  final bool? isEnrolled;
  final double? progressPercentage;

  const CourseCardWidget({
    super.key,
    required this.course,
    required this.onTap,
    this.isEnrolled,
    this.progressPercentage,
  });

  @override
  Widget build(BuildContext context) {
    // Cross-reference with active progress state
    final progressState = context.watch<ProgressBloc>().state;
    CourseProgressEntity? activeProgress;
    for (final p in progressState.myProgress) {
      if (p.courseId == course.id) {
        activeProgress = p;
        break;
      }
    }

    final bool enrolled =
        isEnrolled ?? course.isEnrolled || (activeProgress != null);
    final double pct = progressPercentage ??
        course.progressPercentage ??
        (activeProgress?.percentage ?? 0.0);
    final bool isCompleted = enrolled && pct >= 100.0;
    final bool isInProgress = enrolled && pct > 0.0 && pct < 100.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: enrolled
              ? (isCompleted
                  ? AppColors.secondary.withValues(alpha: 0.5)
                  : AppColors.primary.withValues(alpha: 0.5))
              : AppColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF3B126D),
                        Color(0xFF241442),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.auto_stories_rounded,
                      size: 54,
                      color: AppColors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                // Enrollment Status Badge on Thumbnail Top-Right
                if (enrolled)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppColors.secondary
                            : (isInProgress
                                ? AppColors.primary
                                : AppColors.secondary),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isCompleted
                                ? Icons.check_circle_rounded
                                : (isInProgress
                                    ? Icons.play_circle_filled_rounded
                                    : Icons.bookmark_added_rounded),
                            size: 13,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isCompleted
                                ? 'COMPLETED'
                                : (isInProgress
                                    ? '${pct.toInt()}% IN PROGRESS'
                                    : 'ENROLLED'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Progress Bar at bottom of thumbnail if enrolled and in progress
                if (enrolled && pct > 0)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      value: (pct / 100).clamp(0.0, 1.0),
                      minHeight: 4,
                      backgroundColor: Colors.black26,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCompleted
                            ? AppColors.secondary
                            : AppColors.primaryLight,
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (course.category != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    AppColors.primary.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            course.category!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (course.category != null) const SizedBox(height: 10),
                  Text(
                    course.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            course.instructorName ?? 'Instructor',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      if (enrolled)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCompleted
                                ? AppColors.secondary.withValues(alpha: 0.15)
                                : (isInProgress
                                    ? AppColors.primary.withValues(alpha: 0.15)
                                    : AppColors.secondary
                                        .withValues(alpha: 0.15)),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCompleted
                                  ? AppColors.secondary.withValues(alpha: 0.3)
                                  : (isInProgress
                                      ? AppColors.primary
                                          .withValues(alpha: 0.3)
                                      : AppColors.secondary
                                          .withValues(alpha: 0.3)),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isCompleted
                                    ? Icons.verified_rounded
                                    : (isInProgress
                                        ? Icons.timelapse_rounded
                                        : Icons.bookmark_added_rounded),
                                size: 14,
                                color: isCompleted
                                    ? AppColors.secondary
                                    : (isInProgress
                                        ? AppColors.primary
                                        : AppColors.secondary),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isCompleted
                                    ? 'Completed'
                                    : (isInProgress
                                        ? '${pct.toInt()}% Done'
                                        : 'Enrolled'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: isCompleted
                                      ? AppColors.secondary
                                      : (isInProgress
                                          ? AppColors.primary
                                          : AppColors.secondary),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Text(
                          course.price == 0
                              ? 'FREE'
                              : '\$${course.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
