import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/course_card_widget.dart';

class CourseListScreen extends StatefulWidget {
  const CourseListScreen({super.key});

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  final _searchController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Courses'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onSubmitted: _onSearch,
              decoration: InputDecoration(
                hintText: 'Search courses by title or subject...',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _searchController.clear();
                    _onSearch('');
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<CourseBloc, CourseState>(
              builder: (context, state) {
                if (state.status.isLoading && state.courses.isEmpty) {
                  return const LoadingView(message: 'Loading courses...');
                }

                if (state.status.isError && state.courses.isEmpty) {
                  return ErrorView(
                    message: state.errorMessage ?? 'Failed to load courses',
                    onRetry: () => context.read<CourseBloc>().add(const FetchCoursesRequested()),
                  );
                }

                if (state.courses.isEmpty) {
                  return const Center(
                    child: Text(
                      'No courses available at the moment.',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<CourseBloc>().add(const FetchCoursesRequested());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
