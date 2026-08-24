import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/empty_state_widget.dart';

class AdminPendingTeachersScreen extends StatefulWidget {
  const AdminPendingTeachersScreen({super.key});

  @override
  State<AdminPendingTeachersScreen> createState() => _AdminPendingTeachersScreenState();
}

class _AdminPendingTeachersScreenState extends State<AdminPendingTeachersScreen> {
  final List<Map<String, dynamic>> _pendingTeachers = [
    {
      'id': 101,
      'username': 'prof_smith',
      'fullName': 'Dr. Robert Smith',
      'email': 'robert.smith@university.edu',
      'appliedDate': 'Aug 23, 2026',
      'specialty': 'Distributed Systems & Mobile Security',
    },
    {
      'id': 102,
      'username': 'clara_design',
      'fullName': 'Clara Oswald',
      'email': 'clara@designstudio.io',
      'appliedDate': 'Aug 22, 2026',
      'specialty': 'Design Systems & Modern Micro-interactions',
    },
    {
      'id': 103,
      'username': 'alan_turing_fan',
      'fullName': 'Alan Vance',
      'email': 'alan.v@techacademy.org',
      'appliedDate': 'Aug 21, 2026',
      'specialty': 'Algorithms & Graph Theory',
    },
  ];

  void _onApprove(int id, String name) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Approve Teacher Application',
      message: 'Are you sure you want to approve $name as an authorized EduFlow instructor?',
      confirmText: 'Approve Teacher',
      confirmColor: AppColors.secondary,
      icon: Icons.how_to_reg_rounded,
    );

    if (confirmed == true && mounted) {
      setState(() {
        _pendingTeachers.removeWhere((t) => t['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name has been approved as an instructor!'),
          backgroundColor: AppColors.secondary,
        ),
      );
    }
  }

  void _onReject(int id, String name) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Reject Application',
      message: 'Are you sure you want to reject $name\'s instructor registration?',
      confirmText: 'Reject',
      confirmColor: AppColors.error,
      icon: Icons.person_off_rounded,
    );

    if (confirmed == true && mounted) {
      setState(() {
        _pendingTeachers.removeWhere((t) => t['id'] == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$name\'s application was rejected.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
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
          'Pending Teacher Approvals',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: _pendingTeachers.isEmpty
          ? EmptyStateWidget(
              icon: Icons.check_circle_outline_rounded,
              title: 'All Caught Up!',
              message: 'There are no pending teacher applications awaiting approval.',
              actionText: 'Back to Dashboard',
              onAction: () => context.go('/dashboard'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _pendingTeachers.length,
              itemBuilder: (context, index) {
                final teacher = _pendingTeachers[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.roleTeacher.withValues(alpha: 0.12),
                              child: Text(
                                (teacher['fullName'] as String)[0],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.roleTeacher,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    teacher['fullName'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  Text(
                                    '@${teacher['username']} • ${teacher['email']}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'PENDING',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.warning,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.school_outlined, size: 16, color: AppColors.textSecondary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Specialty: ${teacher['specialty']}',
                                  style: const TextStyle(fontSize: 12, color: AppColors.onSurface),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.error,
                                side: const BorderSide(color: AppColors.error),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => _onReject(teacher['id'] as int, teacher['fullName'] as String),
                              child: const Text('Reject'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.check_rounded, size: 16),
                              label: const Text('Approve Teacher'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => _onApprove(teacher['id'] as int, teacher['fullName'] as String),
                            ),
                          ],
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
