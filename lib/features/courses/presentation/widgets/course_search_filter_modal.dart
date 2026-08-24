import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class CourseSearchFilterModal extends StatefulWidget {
  final String selectedCategory;
  final Function(String category, String level) onApply;

  const CourseSearchFilterModal({
    super.key,
    required this.selectedCategory,
    required this.onApply,
  });

  static void show(
    BuildContext context, {
    required String selectedCategory,
    required Function(String category, String level) onApply,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => CourseSearchFilterModal(
        selectedCategory: selectedCategory,
        onApply: onApply,
      ),
    );
  }

  @override
  State<CourseSearchFilterModal> createState() => _CourseSearchFilterModalState();
}

class _CourseSearchFilterModalState extends State<CourseSearchFilterModal> {
  late String _category;
  String _level = 'All Levels';

  final List<String> _categories = [
    'All',
    'Computer Science',
    'Design & UI',
    'Business',
    'Data Science',
    'Engineering',
  ];

  final List<String> _levels = [
    'All Levels',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  void initState() {
    super.initState();
    _category = widget.selectedCategory;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter Courses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Categories
          const Text(
            'Subject / Domain',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categories.map((cat) {
              final isSel = _category == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSel,
                onSelected: (val) {
                  if (val) setState(() => _category = cat);
                },
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surfaceContainerLow,
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : AppColors.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // Difficulty Levels
          const Text(
            'Difficulty Level',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.onSurface),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _levels.map((lvl) {
              final isSel = _level == lvl;
              return ChoiceChip(
                label: Text(lvl),
                selected: isSel,
                onSelected: (val) {
                  if (val) setState(() => _level = lvl);
                },
                selectedColor: AppColors.secondary,
                backgroundColor: AppColors.surfaceContainerLow,
                labelStyle: TextStyle(
                  color: isSel ? Colors.white : AppColors.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: isSel ? FontWeight.w600 : FontWeight.w500,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Reset',
                  isOutlined: true,
                  onPressed: () {
                    setState(() {
                      _category = 'All';
                      _level = 'All Levels';
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  text: 'Apply Filters',
                  onPressed: () {
                    widget.onApply(_category, _level);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
