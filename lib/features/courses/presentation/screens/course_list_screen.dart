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
  final bool isTab;

  const CourseListScreen({super.key, this.isTab = false});

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
    _loadCourses();
  }

  void _loadCourses() {
    context.read<CourseBloc>().add(const FetchCoursesRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    context.read<CourseBloc>().add(
          FetchCoursesRequested(
            searchQuery: query.isEmpty ? null : query,
            category: _selectedCategory == 'All' ? null : _selectedCategory,
          ),
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
    final hasActiveFilter = _selectedCategory != 'All';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: !widget.isTab,
        leading: widget.isTab
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              ),
        title: const Text(
          'Explore Courses',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                color: AppColors.textPrimary),
            tooltip: 'Refresh Courses',
            onPressed: _loadCourses,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 768;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Search Header with Single Unified Filter Button
                  Container(
                    color: AppColors.background,
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
                              prefixIcon: const Icon(Icons.search_rounded,
                                  color: AppColors.outline),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear_rounded,
                                          size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        _onSearch('');
                                      },
                                    )
                                  : null,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Tooltip(
                          message: 'Filter Courses',
                          child: InkWell(
                            onTap: _openFilterModal,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: hasActiveFilter
                                    ? AppColors.primary
                                    : AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: hasActiveFilter
                                    ? null
                                    : Border.all(
                                        color: AppColors.primary
                                            .withValues(alpha: 0.2)),
                              ),
                              child: Icon(
                                Icons.tune_rounded,
                                color: hasActiveFilter
                                    ? AppColors.onPrimary
                                    : AppColors.primary,
                                size: 20,
                              ),
                            ),
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

                  // Courses Grid/List Area
                  Expanded(
                    child: BlocBuilder<CourseBloc, CourseState>(
                      builder: (context, state) {
                        if (state.status.isLoading && state.courses.isEmpty) {
                          if (isWide) {
                            return GridView.builder(
                              padding: const EdgeInsets.all(16.0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    constraints.maxWidth > 1000 ? 3 : 2,
                                childAspectRatio: 1.4,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: 6,
                              itemBuilder: (context, index) =>
                                  const LoadingSkeletonCard(height: 160),
                            );
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: 4,
                            itemBuilder: (context, index) =>
                                const LoadingSkeletonCard(height: 140),
                          );
                        }

                        if (state.status.isError && state.courses.isEmpty) {
                          return Center(
                            child: EmptyStateWidget(
                              icon: Icons.wifi_off_rounded,
                              title: 'Failed to Load Courses',
                              message: state.errorMessage ??
                                  'Could not connect to the course catalog. Please check your connection.',
                              actionText: 'Retry',
                              onAction: _loadCourses,
                            ),
                          );
                        }

                        final courses = state.courses;

                        if (courses.isEmpty) {
                          return Center(
                            child: EmptyStateWidget(
                              icon: Icons.search_off_rounded,
                              title: 'No Courses Found',
                              message:
                                  'Try adjusting your search query or selecting a different category filter.',
                              actionText: 'Reset Filters',
                              onAction: () {
                                _searchController.clear();
                                setState(() => _selectedCategory = 'All');
                                _onSearch('');
                              },
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async => _loadCourses(),
                          child: isWide
                              ? GridView.builder(
                                  padding: const EdgeInsets.all(16.0),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        constraints.maxWidth > 1000 ? 3 : 2,
                                    childAspectRatio: 1.35,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                  ),
                                  itemCount: courses.length,
                                  itemBuilder: (context, index) {
                                    final course = courses[index];
                                    return CourseCardWidget(
                                      course: course,
                                      onTap: () => context
                                          .push('/courses/${course.id}'),
                                    );
                                  },
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16.0),
                                  itemCount: courses.length,
                                  itemBuilder: (context, index) {
                                    final course = courses[index];
                                    return CourseCardWidget(
                                      course: course,
                                      onTap: () => context
                                          .push('/courses/${course.id}'),
                                    );
                                  },
                                ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
