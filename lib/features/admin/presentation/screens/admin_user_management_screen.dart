import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../widgets/admin_user_card_widget.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() => _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  String _selectedRoleFilter = 'All';

  final List<Map<String, dynamic>> _users = [
    {
      'id': 1,
      'username': 'admin',
      'fullName': 'System Administrator',
      'email': 'admin@eduflow.io',
      'role': 'admin',
      'joined': 'Aug 01, 2026',
    },
    {
      'id': 2,
      'username': 'teacher_dan',
      'fullName': 'Dan Abramov',
      'email': 'dan@eduflow.io',
      'role': 'teacher',
      'isApproved': true,
      'joined': 'Aug 05, 2026',
    },
    {
      'id': 3,
      'username': 'clara_design',
      'fullName': 'Clara Oswald',
      'email': 'clara@designstudio.io',
      'role': 'teacher',
      'isApproved': false,
      'joined': 'Aug 22, 2026',
    },
    {
      'id': 4,
      'username': 'student_emma',
      'fullName': 'Emma Watson',
      'email': 'emma@school.edu',
      'role': 'student',
      'joined': 'Aug 14, 2026',
    },
    {
      'id': 5,
      'username': 'john_student',
      'fullName': 'John Doe',
      'email': 'john.doe@example.com',
      'role': 'student',
      'joined': 'Aug 20, 2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _selectedRoleFilter == 'All'
        ? _users
        : _users.where((u) => u['role'].toString().toLowerCase() == _selectedRoleFilter.toLowerCase()).toList();

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
          'User Management Directory',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Chips Row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: ['All', 'Student', 'Teacher', 'Admin'].map((role) {
                final isSelected = _selectedRoleFilter == role;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(role),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedRoleFilter = role);
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    showCheckmark: false,
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final user = filteredUsers[index];
                return AdminUserCardWidget(user: user);
              },
            ),
          ),
        ],
      ),
    );
  }
}
