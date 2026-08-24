import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/course_card_widget.dart';
import '../widgets/course_category_filter_pills.dart';
import '../widgets/course_search_filter_modal.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Computer Science',
    'Design & UI',
    'Business',
    'Data Science',
    'Engineering',
  ];

  @override
  void initState() {
    super.initState();
    context.read<CourseBloc>().add(const FetchCoursesRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    context.read<CourseBloc>().add(
          FetchCoursesRequested(searchQuery: query.isEmpty ? null : query),
        );
  }

  void _openFilterModal() {
    CourseSearchFilterModal.show(
      context,
      selectedCategory: _selectedCategory,
      onApply: (category, level) {
        setState(() {
          _selectedCategory = category;
        });
        _onSearch(_searchController.text.trim());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Explore Courses',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
            tooltip: 'Filter Courses',
            onPressed: _openFilterModal,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onSubmitted: _onSearch,
                    onChanged: (val) {
                      if (val.isEmpty) _onSearch('');
                    },
                    decoration: InputDecoration(
                      hintText: 'Search topics, skills, instructor...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.outline),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                _onSearch('');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: _openFilterModal,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.tune_rounded, color: AppColors.primary, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // Reusable Horizontal Categories Filter Pills
          CourseCategoryFilterPills(
            categories: _categories,
            selectedCategory: _selectedCategory,
            onSelectCategory: (cat) {
              setState(() => _selectedCategory = cat);
              _onSearch(_searchController.text.trim());
            },
          ),
          const Divider(height: 1, color: AppColors.divider),

          // Courses List View
          Expanded(
            child: BlocBuilder<CourseBloc, CourseState>(
              builder: (context, state) {
                if (state.status.isLoading && state.courses.isEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: 4,
                    itemBuilder: (context, index) => const LoadingSkeletonCard(height: 140),
                  );
                }

                if (state.status.isError && state.courses.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.error_outline_rounded,
                    title: 'Failed to load courses',
                    message: state.errorMessage ?? 'Please check your connection and try again.',
                    actionText: 'Retry',
                    onAction: () => context.read<CourseBloc>().add(const FetchCoursesRequested()),
                  );
                }

                if (state.courses.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.search_off_rounded,
                    title: 'No courses found',
                    message: 'Try adjusting your search terms or category filter to discover content.',
                    actionText: 'Reset Filters',
                    onAction: () {
                      _searchController.clear();
                      setState(() {
                        _selectedCategory = 'All';
                      });
                      _onSearch('');
                    },
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<CourseBloc>().add(const FetchCoursesRequested());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: state.courses.length,
                    itemBuilder: (context, index) {
                      final course = state.courses[index];
                      return CourseCardWidget(
                        course: course,
                        onTap: () {
                          context.push('/courses/${course.id}');
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
