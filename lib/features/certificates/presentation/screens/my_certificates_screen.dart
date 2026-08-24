import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../bloc/certificate_bloc.dart';
import '../bloc/certificate_event.dart';
import '../bloc/certificate_state.dart';
import '../widgets/certificate_card_widget.dart';

class MyCertificatesScreen extends StatefulWidget {
  const MyCertificatesScreen({super.key});

  @override
  State<MyCertificatesScreen> createState() => _MyCertificatesScreenState();
}

class _MyCertificatesScreenState extends State<MyCertificatesScreen> {
  @override
  void initState() {
    super.initState();
    _loadCertificates();
  }

  void _loadCertificates() {
    context.read<CertificateBloc>().add(const LoadCertificatesEvent());
  }

  void _handleBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: _handleBack,
        ),
        title: const Text(
          'My Earned Certificates',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.refresh_rounded, color: AppColors.textPrimary),
            tooltip: 'Refresh Certificates',
            onPressed: _loadCertificates,
          ),
        ],
      ),
      body: BlocBuilder<CertificateBloc, CertificateState>(
        builder: (context, state) {
          final isLoading =
              state.status == CertificateStatus.loading && state.certificates.isEmpty;

          if (isLoading) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 3,
                  itemBuilder: (context, index) =>
                      const LoadingSkeletonCard(height: 140, borderRadius: 16),
                ),
              ),
            );
          }

          if (state.status == CertificateStatus.failure &&
              state.certificates.isEmpty) {
            return Center(
              child: ErrorView(
                message: state.errorMessage ??
                    'Failed to load certificates. Please try again.',
                onRetry: _loadCertificates,
              ),
            );
          }

          if (state.certificates.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async => _loadCertificates(),
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: EmptyStateWidget(
                      icon: Icons.workspace_premium_rounded,
                      title: 'No Certificates Earned Yet',
                      message:
                          'Complete 100% of any enrolled course to unlock your official verified certificate.',
                      actionText: 'Browse Courses',
                      onAction: () => context.push('/courses'),
                    ),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: RefreshIndicator(
                    onRefresh: () async => _loadCertificates(),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 24.0 : 16.0,
                        vertical: 16.0,
                      ),
                      itemCount: state.certificates.length,
                      itemBuilder: (context, index) {
                        final cert = state.certificates[index];

                        return CertificateCardWidget(
                          title: cert.courseTitle,
                          instructor: 'Verified Instructor',
                          issuedDate: cert.issuedAt,
                          credentialId: cert.certificateId,
                          onTap: () => context.push('/certificates/${cert.id}'),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
