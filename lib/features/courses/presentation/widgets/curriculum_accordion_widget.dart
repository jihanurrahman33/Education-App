import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class CurriculumAccordionWidget extends StatelessWidget {
  final List<dynamic> chapters;
  final bool isEnrolled;
  final Function(dynamic lesson) onLessonTap;

  const CurriculumAccordionWidget({
    super.key,
    required this.chapters,
    required this.isEnrolled,
    required this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    if (chapters.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.menu_book_rounded,
        title: 'Curriculum Coming Soon',
        message: 'The instructor is finalizing the chapters and lessons for this course.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final chapter = chapters[index];
        final lessons = (chapter.lessons as List<dynamic>);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              initiallyExpanded: index == 0,
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              title: Text(
                chapter.title as String,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                '${lessons.length} lessons',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              iconColor: AppColors.primary,
              collapsedIconColor: AppColors.textSecondary,
              children: lessons.map<Widget>((lesson) {
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 0.8),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: isEnrolled
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isEnrolled
                            ? Icons.play_arrow_rounded
                            : Icons.lock_outline_rounded,
                        size: 18,
                        color: isEnrolled ? AppColors.primary : AppColors.textMuted,
                      ),
                    ),
                    title: Text(
                      lesson.title as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    trailing: isEnrolled
                        ? const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.textSecondary)
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'LOCKED',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                    onTap: () => onLessonTap(lesson),
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
