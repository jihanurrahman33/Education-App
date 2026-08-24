import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../../certificates/domain/entities/certificate_entity.dart';
import '../../domain/entities/progress_entity.dart';
import '../../domain/usecases/generate_certificate_usecase.dart';
import '../../domain/usecases/get_certificates_usecase.dart';
import '../../domain/usecases/get_my_progress_usecase.dart';
import '../widgets/course_progress_breakdown_card.dart';
import '../widgets/progress_overview_card_widget.dart';

class MyProgressScreen extends StatefulWidget {
  final bool isTab;

  const MyProgressScreen({super.key, this.isTab = false});

  @override
  State<MyProgressScreen> createState() => _MyProgressScreenState();
}

class _MyProgressScreenState extends State<MyProgressScreen> {
  final GetMyProgressUseCase _getMyProgressUseCase = GetIt.I<GetMyProgressUseCase>();
  final GetCertificatesUseCase _getCertificatesUseCase = GetIt.I<GetCertificatesUseCase>();
  final GenerateCertificateUseCase _generateCertificateUseCase = GetIt.I<GenerateCertificateUseCase>();

  List<CourseProgressEntity> _courses = [];
  List<CertificateEntity> _certificates = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() => _isLoading = true);

    final results = await Future.wait([
      _getMyProgressUseCase(),
      _getCertificatesUseCase(),
    ]);

    if (!mounted) return;

    final progressResult = results[0];
    final certsResult = results[1];

    List<CourseProgressEntity> courses = [];
    List<CertificateEntity> certs = [];

    progressResult.fold((_) => null, (list) => courses = list as List<CourseProgressEntity>);
    certsResult.fold((_) => null, (list) => certs = list as List<CertificateEntity>);

    setState(() {
      _courses = courses;
      _certificates = certs;
      _isLoading = false;
    });
  }

  Future<void> _onGenerateCertificate(CourseProgressEntity course) async {
    // Check if certificate already generated
    final existing = _certificates.any((c) => c.course == course.courseId);
    if (existing) {
      context.push('/certificates');
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating verified certificate...')),
    );

    final result = await _generateCertificateUseCase(course.courseId);

    if (!mounted) return;

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not generate certificate: ${failure.message}'),
            backgroundColor: AppColors.error,
          ),
        );
      },
      (cert) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Certificate earned for "${cert.courseTitle}"!'),
            backgroundColor: AppColors.secondary,
          ),
        );
        _loadProgress();
        context.push('/certificates');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int completedLessons = 0;
    double totalPercent = 0.0;

    for (final c in _courses) {
      completedLessons += c.completedLessons;
      totalPercent += c.percentage;
    }

    final avgCompletion = _courses.isNotEmpty
        ? (totalPercent / _courses.length).toInt()
        : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: !widget.isTab,
        leading: widget.isTab
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              ),
        title: const Text(
          'My Learning Progress',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
            tooltip: 'Refresh Progress',
            onPressed: _loadProgress,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadProgress,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isLoading)
                const LoadingSkeletonCard(height: 120, borderRadius: 16)
              else
                ProgressOverviewCardWidget(
                  completionRate: '$avgCompletion%',
                  completedLessons: '$completedLessons',
                  enrolledCourses: '${_courses.length}',
                  certificatesCount: '${_certificates.length}',
                ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Course Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  if (_certificates.isNotEmpty)
                    TextButton.icon(
                      icon: const Icon(Icons.workspace_premium_rounded, size: 16),
                      label: const Text('View Certificates'),
                      onPressed: () => context.push('/certificates'),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              if (_isLoading)
                const Column(
                  children: [
                    LoadingSkeletonCard(height: 110, borderRadius: 14),
                    SizedBox(height: 12),
                    LoadingSkeletonCard(height: 110, borderRadius: 14),
                  ],
                )
              else if (_courses.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.auto_stories_outlined, size: 48, color: AppColors.textSecondary),
                      const SizedBox(height: 12),
                      const Text(
                        'You are not enrolled in any courses yet.',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Browse courses to enroll and track your progress.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.push('/courses'),
                        child: const Text('Explore Courses'),
                      ),
                    ],
                  ),
                )
              else
                ..._courses.map((course) {
                  final progressFraction = (course.percentage / 100.0).clamp(0.0, 1.0);
                  final isDone = course.isEligibleForCertificate;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: CourseProgressBreakdownCard(
                      title: course.courseTitle,
                      completedLessons: course.completedLessons,
                      totalLessons: course.totalLessons,
                      progress: progressFraction,
                      isEligibleForCertificate: isDone,
                      onAction: () {
                        if (isDone) {
                          _onGenerateCertificate(course);
                        } else {
                          context.push('/courses/${course.courseId}');
                        }
                      },
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
