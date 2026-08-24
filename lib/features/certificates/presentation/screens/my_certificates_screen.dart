import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../widgets/certificate_card_widget.dart';

class MyCertificatesScreen extends StatelessWidget {
  const MyCertificatesScreen({super.key});

  final List<Map<String, dynamic>> mockCertificates = const [
    {
      'id': 1,
      'title': 'Full-Stack Modern App Architecture',
      'instructor': 'Lead Architect',
      'issuedDate': 'Aug 24, 2026',
      'credentialId': 'EDU-CERT-8849-1',
    },
    {
      'id': 2,
      'title': 'UI/UX Design Systems in Flutter',
      'instructor': 'Senior Product Designer',
      'issuedDate': 'Aug 15, 2026',
      'credentialId': 'EDU-CERT-3941-2',
    },
  ];

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
          'My Earned Certificates',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: mockCertificates.isEmpty
          ? EmptyStateWidget(
              icon: Icons.workspace_premium_rounded,
              title: 'No Certificates Earned Yet',
              message: 'Complete 100% of any enrolled course to unlock your official verified certificate.',
              actionText: 'Browse Courses',
              onAction: () => context.push('/courses'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mockCertificates.length,
              itemBuilder: (context, index) {
                final cert = mockCertificates[index];

                return CertificateCardWidget(
                  title: cert['title'] as String,
                  instructor: cert['instructor'] as String,
                  issuedDate: cert['issuedDate'] as String,
                  credentialId: cert['credentialId'] as String,
                  onTap: () => context.push('/certificates/${cert['id']}'),
                );
              },
            ),
    );
  }
}
