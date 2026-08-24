import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';

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

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () => context.push('/certificates/${cert['id']}'),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9E6),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFD4AF37)),
                            ),
                            child: const Icon(
                              Icons.workspace_premium_rounded,
                              color: Color(0xFFD4AF37),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cert['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Issued on ${cert['issuedDate']} • ${cert['instructor']}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cert['credentialId'] as String,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.outline),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
