import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_toast.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../progress/presentation/bloc/progress_bloc.dart';
import '../bloc/certificate_bloc.dart';
import '../bloc/certificate_event.dart';
import '../bloc/certificate_state.dart';
import '../../utils/certificate_pdf_generator.dart';
import '../widgets/certificate_frame_widget.dart';

class CertificateViewerScreen extends StatefulWidget {
  final int certificateId;

  const CertificateViewerScreen({super.key, required this.certificateId});

  @override
  State<CertificateViewerScreen> createState() =>
      _CertificateViewerScreenState();
}

class _CertificateViewerScreenState extends State<CertificateViewerScreen> {
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    context.read<CertificateBloc>().add(const LoadCertificatesEvent());
  }

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

  Future<void> _downloadPdf({
    required String studentName,
    required String courseTitle,
    required String issueDate,
    required String credentialCode,
  }) async {
    setState(() => _isGeneratingPdf = true);
    AppToast.showInfo(context, 'Preparing official certificate PDF...');

    try {
      await CertificatePdfGenerator.downloadOrPrintCertificate(
        studentName: studentName,
        courseTitle: courseTitle,
        issueDate: issueDate,
        credentialCode: credentialCode,
      );
      if (mounted) {
        AppToast.showSuccess(context, 'Certificate PDF generated successfully!');
      }
    } catch (e) {
      if (mounted) {
        AppToast.showError(context, 'Failed to generate certificate PDF.');
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
      }
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
              AppToast.showSuccess(
                  context, 'Certificate credential URL copied to clipboard!');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<CertificateBloc, CertificateState>(
          builder: (context, state) {
            final cert = state.certificates
                    .where((c) => c.id == widget.certificateId)
                    .firstOrNull ??
                context
                    .read<ProgressBloc>()
                    .state
                    .certificates
                    .where((c) => c.id == widget.certificateId)
                    .firstOrNull;
            final courseTitle = cert?.courseTitle ??
                'Mastering Clean Architecture & Flutter';
            final formattedIssueDate = _formatIssueDate(cert?.issuedAt);
            final credentialCode =
                cert?.certificateId ?? 'EDU-CERT-8849-${widget.certificateId}';
            final recipientName = cert?.studentName ?? studentName;

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
                            certificateId: widget.certificateId,
                            studentName: recipientName,
                            courseTitle: courseTitle,
                            issueDate: formattedIssueDate,
                            credentialCode: credentialCode,
                          ),
                          const SizedBox(height: 28),

                          // Actions
                          CustomButton(
                            text: 'Download / Print PDF Certificate',
                            icon: Icons.download_rounded,
                            isLoading: _isGeneratingPdf,
                            backgroundColor: AppColors.secondary,
                            textColor: Colors.white,
                            onPressed: () => _downloadPdf(
                              studentName: recipientName,
                              courseTitle: courseTitle,
                              issueDate: formattedIssueDate,
                              credentialCode: credentialCode,
                            ),
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
