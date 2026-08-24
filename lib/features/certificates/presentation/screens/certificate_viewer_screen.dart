import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/certificate_bloc.dart';
import '../bloc/certificate_state.dart';
import '../widgets/certificate_frame_widget.dart';

class CertificateViewerScreen extends StatelessWidget {
  final int certificateId;

  const CertificateViewerScreen({super.key, required this.certificateId});

  void _handleBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/certificates');
    }
  }

  String _formatIssueDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return DateFormat('MMMM d, y').format(DateTime.now());
    }
    try {
      final parsed = DateTime.parse(rawDate).toLocal();
      return DateFormat('MMMM d, y').format(parsed);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    final studentName = user?.fullName ?? 'Valued Learner';

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => _handleBack(context),
        ),
        title: const Text(
          'Certificate of Completion',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            tooltip: 'Share Certificate',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Certificate credential URL copied to clipboard!')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CertificateBloc, CertificateState>(
          builder: (context, state) {
            final cert = state.certificates
                .where((c) => c.id == certificateId)
                .firstOrNull;
            final courseTitle = cert?.courseTitle ??
                'Mastering Clean Architecture & Flutter';
            final formattedIssueDate = _formatIssueDate(cert?.issuedAt);
            final credentialCode =
                cert?.certificateId ?? 'EDU-CERT-8849-$certificateId';

            return LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 768;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 32.0 : 20.0,
                        vertical: 20.0,
                      ),
                      child: Column(
                        children: [
                          // Reusable Digital Certificate Frame Widget
                          CertificateFrameWidget(
                            certificateId: certificateId,
                            studentName: cert?.studentName ?? studentName,
                            courseTitle: courseTitle,
                            issueDate: formattedIssueDate,
                            credentialCode: credentialCode,
                          ),
                          const SizedBox(height: 28),

                          // Actions
                          CustomButton(
                            text: 'Download PDF Certificate',
                            icon: Icons.download_rounded,
                            backgroundColor: AppColors.secondary,
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Downloading official certificate PDF...'),
                                  backgroundColor: AppColors.secondary,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          CustomButton(
                            text: 'Back to Certificates Gallery',
                            isOutlined: true,
                            textColor: Colors.white,
                            onPressed: () => _handleBack(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
