import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';

class CurriculumAccordionWidget extends StatelessWidget {
  final List<dynamic> chapters;
  final bool isEnrolled;
  final bool isTeacherOrAdmin;
  final int? courseId;
  final Set<int>? completedLessonIds;
  final Function(dynamic lesson) onLessonTap;

  const CurriculumAccordionWidget({
    super.key,
    required this.chapters,
    required this.isEnrolled,
    this.isTeacherOrAdmin = false,
    this.courseId,
    this.completedLessonIds,
    required this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.menu_book_rounded,
        title: 'Curriculum Coming Soon',
        message:
            'The instructor is finalizing the chapters and lessons for this course.',
      );
    }

    // Get completed lesson IDs from state or parameter
    final progressState = context.watch<ProgressBloc>().state;
    final Set<int> completedIds = completedLessonIds ??
        progressState.completedLessons.map((cl) => cl.lesson).toSet();

    // Determine completion status of each chapter
    final List<bool> isChapterCompletedList = [];
    for (int i = 0; i < chapters.length; i++) {
      final ch = chapters[i];
      final lessons = (ch.lessons as List<dynamic>?) ?? [];
      final bool isComp = lessons.isNotEmpty &&
          lessons.every((l) => completedIds.contains(l.id));
      isChapterCompletedList.add(isComp);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chapters.length,
      itemBuilder: (context, chapterIndex) {
        final chapter = chapters[chapterIndex];
        final lessons = (chapter.lessons as List<dynamic>?) ?? [];

        // Chapter unlock rule:
        // Teacher/Admin -> Always Unlocked
        // Not enrolled -> All chapters locked
        // Enrolled -> Chapter 0 is unlocked. Chapter i is unlocked if Chapter i-1 is completed.
        final bool isChapterUnlocked = isTeacherOrAdmin ||
            (isEnrolled &&
                (chapterIndex == 0 ||
                    isChapterCompletedList[chapterIndex - 1]));

        final bool isChapterCompleted = isChapterCompletedList[chapterIndex];
        final int completedLessonsInChapter =
            lessons.where((l) => completedIds.contains(l.id)).length;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          color: isChapterUnlocked
              ? AppColors.surface
              : AppColors.surfaceContainerLow.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isChapterCompleted
                  ? AppColors.secondary.withValues(alpha: 0.4)
                  : (isChapterUnlocked
                      ? AppColors.border
                      : AppColors.border.withValues(alpha: 0.4)),
            ),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: chapterIndex == 0 && isChapterUnlocked,
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: isChapterCompleted
                    ? AppColors.secondary.withValues(alpha: 0.2)
                    : (isChapterUnlocked
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surfaceContainerHighest),
                child: isChapterCompleted
                    ? const Icon(Icons.check_rounded,
                        size: 16, color: AppColors.secondary)
                    : (!isChapterUnlocked
                        ? const Icon(Icons.lock_rounded,
                            size: 14, color: AppColors.textMuted)
                        : Text(
                            '${chapterIndex + 1}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          )),
              ),
              title: Text(
                chapter.title as String,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isChapterUnlocked
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              subtitle: Row(
                children: [
                  Text(
                    '${lessons.length} lessons',
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                  if (isEnrolled && isChapterUnlocked) ...[
                    const SizedBox(width: 8),
                    Text(
                      '• $completedLessonsInChapter of ${lessons.length} completed',
                      style: TextStyle(
                        fontSize: 11,
                        color: isChapterCompleted
                            ? AppColors.secondary
                            : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: isChapterCompleted
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'COMPLETED',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.secondary,
                        ),
                      ),
                    )
                  : (!isChapterUnlocked
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.lock_rounded,
                                  size: 12, color: AppColors.textMuted),
                              SizedBox(width: 4),
                              Text(
                                'LOCKED',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        )
                      : null),
              iconColor: AppColors.primary,
              collapsedIconColor: AppColors.textSecondary,
              children: lessons.asMap().entries.map<Widget>((entry) {
                final int lessonIndex = entry.key;
                final lesson = entry.value;

                final bool isLessonDone = completedIds.contains(lesson.id);

                // Sequential lesson unlock rule within unlocked chapter:
                // Lesson 0 is unlocked.
                // Lesson j is unlocked if Lesson j-1 is completed or already done.
                final bool isLessonUnlocked = isTeacherOrAdmin ||
                    (isChapterUnlocked &&
                        (lessonIndex == 0 ||
                            isLessonDone ||
                            completedIds.contains(lessons[lessonIndex - 1].id)));

                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 0.8),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 2),
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isLessonDone
                            ? AppColors.secondary.withValues(alpha: 0.15)
                            : (isLessonUnlocked
                                ? AppColors.primary.withValues(alpha: 0.12)
                                : AppColors.surfaceContainerHigh),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isLessonDone
                            ? Icons.check_circle_rounded
                            : (isLessonUnlocked
                                ? Icons.play_arrow_rounded
                                : Icons.lock_outline_rounded),
                        size: 18,
                        color: isLessonDone
                            ? AppColors.secondary
                            : (isLessonUnlocked
                                ? AppColors.primary
                                : AppColors.textMuted),
                      ),
                    ),
                    title: Text(
                      lesson.title as String,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isLessonUnlocked
                            ? AppColors.textPrimary
                            : AppColors.textMuted,
                      ),
                    ),
                    trailing: isLessonDone
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.secondary,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(Icons.check_circle_rounded,
                                  size: 16, color: AppColors.secondary),
                            ],
                          )
                        : (isLessonUnlocked
                            ? const Icon(Icons.chevron_right_rounded,
                                size: 18, color: AppColors.textSecondary)
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.lock_rounded,
                                        size: 10, color: AppColors.textMuted),
                                    SizedBox(width: 3),
                                    Text(
                                      'LOCKED',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    onTap: () {
                      if (!isEnrolled) {
                        onLessonTap(lesson);
                        return;
                      }

                      if (!isChapterUnlocked) {
                        AppToast.showInfo(
                          context,
                          'Complete Chapter $chapterIndex to unlock Chapter ${chapterIndex + 1}!',
                        );
                        return;
                      }

                      if (!isLessonUnlocked) {
                        AppToast.showInfo(
                          context,
                          'Complete lesson $lessonIndex first to unlock this lesson.',
                        );
                        return;
                      }

                      onLessonTap(lesson);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
