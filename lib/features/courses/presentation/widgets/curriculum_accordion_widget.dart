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
        message: 'The instructor is finalizing the chapters and lessons.',
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ExpansionTile(
            initiallyExpanded: index == 0,
            leading: CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            subtitle: Text(
              '${lessons.length} lessons',
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            children: lessons.map<Widget>((lesson) {
              return ListTile(
                leading: const Icon(Icons.play_circle_outline_rounded, size: 20, color: AppColors.primary),
                title: Text(lesson.title as String, style: const TextStyle(fontSize: 13)),
                trailing: isEnrolled
                    ? const Icon(Icons.chevron_right_rounded, size: 18)
                    : const Icon(Icons.lock_outline_rounded, size: 16, color: AppColors.outline),
                onTap: () => onLessonTap(lesson),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
