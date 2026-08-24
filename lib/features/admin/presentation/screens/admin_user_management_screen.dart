import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../../domain/usecases/create_user_use_case.dart';
import '../../domain/usecases/get_user_by_id_use_case.dart';
import '../../domain/usecases/get_users_use_case.dart';
import '../../domain/usecases/patch_user_use_case.dart';
import '../../domain/usecases/update_user_use_case.dart';
import '../widgets/admin_user_card_widget.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() => _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  final GetUsersUseCase _getUsersUseCase = GetIt.I<GetUsersUseCase>();
  final GetUserByIdUseCase _getUserByIdUseCase = GetIt.I<GetUserByIdUseCase>();
  final CreateUserUseCase _createUserUseCase = GetIt.I<CreateUserUseCase>();
  final UpdateUserUseCase _updateUserUseCase = GetIt.I<UpdateUserUseCase>();
  final PatchUserUseCase _patchUserUseCase = GetIt.I<PatchUserUseCase>();
  final TextEditingController _searchController = TextEditingController();

  List<AdminUserEntity> _users = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedRoleFilter = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _getUsersUseCase(GetUsersParams(
      search: _searchQuery.isNotEmpty ? _searchQuery : null,
    ));

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
      },
      (users) {
        setState(() {
          _isLoading = false;
          _users = users;
        });
      },
    );
  }

  Future<void> _toggleUserActiveStatus(AdminUserEntity user) async {
    final newStatus = !user.isActive;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: newStatus ? 'Activate User Account' : 'Deactivate User Account',
      message: newStatus
          ? 'Are you sure you want to reactivate @${user.username}\'s account?'
          : 'Are you sure you want to deactivate @${user.username}\'s account?',
      confirmText: newStatus ? 'Activate' : 'Deactivate',
      confirmColor: newStatus ? AppColors.secondary : AppColors.error,
      icon: newStatus ? Icons.check_circle_outline_rounded : Icons.block_rounded,
    );

    if (confirmed == true && mounted) {
      final result = await _patchUserUseCase(PatchUserParams(
        id: user.id,
        isActive: newStatus,
      ));

      if (!mounted) return;

      result.fold(
        (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update status: ${failure.message}'),
              backgroundColor: AppColors.error,
            ),
          );
        },
        (updated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('User @${updated.username} is now ${updated.isActive ? 'Active' : 'Inactive'}'),
              backgroundColor: AppColors.secondary,
            ),
          );
          _fetchUsers();
        },
      );
    }
  }

  void _showUserDetailsModal(int userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return FutureBuilder(
          future: _getUserByIdUseCase(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isLeft) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 40),
                    const SizedBox(height: 12),
                    const Text('Unable to load user profile details.'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            }

            final user = snapshot.data!.right;

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                        child: Text(
                          user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Text(
                              '@${user.username}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      StatusBadge.role(user.role),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  _buildDetailRow(Icons.email_outlined, 'Email Address', user.email),
                  _buildDetailRow(Icons.phone_outlined, 'Phone Number',
                      user.phone?.isNotEmpty == true ? user.phone! : 'Not specified'),
                  _buildDetailRow(Icons.calendar_today_outlined, 'Member Since',
                      user.dateJoined?.substring(0, 10) ?? 'N/A'),
                  _buildDetailRow(Icons.toggle_on_outlined, 'Account Status',
                      user.isActive ? 'Active' : 'Inactive'),
                  if (user.isTeacher)
                    _buildDetailRow(
                      Icons.verified_outlined,
                      'Teacher Approval',
                      user.isApprovedTeacher
                          ? 'Approved (${user.approvedAt?.substring(0, 10) ?? 'Verified'})'
                          : 'Pending Approval',
                    ),

                  const SizedBox(height: 16),
                  // Quick Actions Row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(
                            user.isActive ? Icons.block_rounded : Icons.check_circle_outline_rounded,
                            size: 16,
                            color: user.isActive ? AppColors.error : AppColors.secondary,
                          ),
                          label: Text(user.isActive ? 'Deactivate' : 'Activate'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: user.isActive ? AppColors.error : AppColors.secondary,
                            side: BorderSide(
                              color: user.isActive ? AppColors.error : AppColors.secondary,
                            ),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _toggleUserActiveStatus(user);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.edit_outlined, size: 16),
                          label: const Text('Edit User'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            _openEditUserDialog(user);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openEditUserDialog(AdminUserEntity user) {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);
    final firstNameController = TextEditingController(text: user.firstName ?? '');
    final lastNameController = TextEditingController(text: user.lastName ?? '');
    final phoneController = TextEditingController(text: user.phone ?? '');
    String selectedRole = user.role.toLowerCase();
    bool isActive = user.isActive;
    bool isApprovedTeacher = user.isApprovedTeacher;
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit @${user.username}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: firstNameController,
                              label: 'First Name',
                              hint: 'Jane',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: lastNameController,
                              label: 'Last Name',
                              hint: 'Doe',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: usernameController,
                        label: 'Username',
                        hint: 'janedoe',
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Username is required';
                          if (!RegExp(r'^[\w.@+-]+$').hasMatch(val.trim())) return 'Valid characters: letters, digits, @/./+/-/_';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: emailController,
                        label: 'Email Address',
                        hint: 'jane@example.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline_rounded,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Email is required';
                          if (!val.contains('@') || !val.contains('.')) return 'Enter a valid email address';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: phoneController,
                        label: 'Phone (Optional)',
                        hint: '+1234567890',
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                      ),
                      const SizedBox(height: 12),

                      // Role selector
                      const Text(
                        'Account Role',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'student', child: Text('Student')),
                          DropdownMenuItem(value: 'teacher', child: Text('Teacher / Instructor')),
                          DropdownMenuItem(value: 'admin', child: Text('Administrator')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedRole = val;
                              if (selectedRole != 'teacher') {
                                isApprovedTeacher = false;
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Checkbox controls
                      Row(
                        children: [
                          Checkbox(
                            value: isActive,
                            activeColor: AppColors.primary,
                            onChanged: (val) => setModalState(() => isActive = val ?? true),
                          ),
                          const Text('Active Account', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      if (selectedRole == 'teacher')
                        Row(
                          children: [
                            Checkbox(
                              value: isApprovedTeacher,
                              activeColor: AppColors.secondary,
                              onChanged: (val) => setModalState(() => isApprovedTeacher = val ?? false),
                            ),
                            const Text('Pre-approved Teacher Status', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      const SizedBox(height: 20),

                      CustomButton(
                        text: 'Save Changes',
                        isLoading: isSubmitting,
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            setModalState(() => isSubmitting = true);
                            final result = await _updateUserUseCase(UpdateUserParams(
                              id: user.id,
                              username: usernameController.text.trim(),
                              email: emailController.text.trim(),
                              role: selectedRole,
                              firstName: firstNameController.text.trim().isNotEmpty
                                  ? firstNameController.text.trim()
                                  : null,
                              lastName: lastNameController.text.trim().isNotEmpty
                                  ? lastNameController.text.trim()
                                  : null,
                              phone: phoneController.text.trim().isNotEmpty
                                  ? phoneController.text.trim()
                                  : null,
                              isActive: isActive,
                              isApprovedTeacher: isApprovedTeacher,
                            ));

                            if (!mounted) return;
                            setModalState(() => isSubmitting = false);

                            result.fold(
                              (failure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to update user: ${failure.message}'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              },
                              (updated) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('User @${updated.username} updated successfully!'),
                                    backgroundColor: AppColors.secondary,
                                  ),
                                );
                                _fetchUsers();
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openCreateUserDialog() {
    final formKey = GlobalKey<FormState>();
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final phoneController = TextEditingController();
    String selectedRole = 'student';
    bool isActive = true;
    bool isApprovedTeacher = false;
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Create New User',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: firstNameController,
                              label: 'First Name',
                              hint: 'Jane',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: lastNameController,
                              label: 'Last Name',
                              hint: 'Doe',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: usernameController,
                        label: 'Username',
                        hint: 'janedoe',
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Username is required';
                          if (!RegExp(r'^[\w.@+-]+$').hasMatch(val.trim())) return 'Valid characters: letters, digits, @/./+/-/_';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: emailController,
                        label: 'Email Address',
                        hint: 'jane@example.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline_rounded,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Email is required';
                          if (!val.contains('@') || !val.contains('.')) return 'Enter a valid email address';
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: phoneController,
                        label: 'Phone (Optional)',
                        hint: '+1234567890',
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                      ),
                      const SizedBox(height: 12),

                      // Role selector
                      const Text(
                        'Account Role',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: selectedRole,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'student', child: Text('Student')),
                          DropdownMenuItem(value: 'teacher', child: Text('Teacher / Instructor')),
                          DropdownMenuItem(value: 'admin', child: Text('Administrator')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedRole = val;
                              if (selectedRole != 'teacher') {
                                isApprovedTeacher = false;
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Checkbox controls
                      Row(
                        children: [
                          Checkbox(
                            value: isActive,
                            activeColor: AppColors.primary,
                            onChanged: (val) => setModalState(() => isActive = val ?? true),
                          ),
                          const Text('Active Account', style: TextStyle(fontSize: 13)),
                        ],
                      ),
                      if (selectedRole == 'teacher')
                        Row(
                          children: [
                            Checkbox(
                              value: isApprovedTeacher,
                              activeColor: AppColors.secondary,
                              onChanged: (val) => setModalState(() => isApprovedTeacher = val ?? false),
                            ),
                            const Text('Pre-approved Teacher Status', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      const SizedBox(height: 20),

                      CustomButton(
                        text: 'Create User',
                        isLoading: isSubmitting,
                        onPressed: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            setModalState(() => isSubmitting = true);
                            final result = await _createUserUseCase(CreateUserParams(
                              username: usernameController.text.trim(),
                              email: emailController.text.trim(),
                              role: selectedRole,
                              firstName: firstNameController.text.trim().isNotEmpty
                                  ? firstNameController.text.trim()
                                  : null,
                              lastName: lastNameController.text.trim().isNotEmpty
                                  ? lastNameController.text.trim()
                                  : null,
                              phone: phoneController.text.trim().isNotEmpty
                                  ? phoneController.text.trim()
                                  : null,
                              isActive: isActive,
                              isApprovedTeacher: isApprovedTeacher,
                            ));

                            if (!mounted) return;
                            setModalState(() => isSubmitting = false);

                            result.fold(
                              (failure) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to create user: ${failure.message}'),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              },
                              (created) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('User @${created.username} created successfully!'),
                                    backgroundColor: AppColors.secondary,
                                  ),
                                );
                                _fetchUsers();
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = _users.where((u) {
      final matchesRole = _selectedRoleFilter == 'All' ||
          u.role.toLowerCase() == _selectedRoleFilter.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          u.username.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          u.fullName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesRole && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.onSurface),
            tooltip: 'Refresh Users',
            onPressed: _fetchUsers,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add User'),
        onPressed: _openCreateUserDialog,
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                CustomTextField(
                  controller: _searchController,
                  hint: 'Search by name, username, or email...',
                  prefixIcon: Icons.search_rounded,
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  onChanged: (val) {
                    setState(() => _searchQuery = val.trim());
                  },
                ),
                const SizedBox(height: 10),
                Row(
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
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          Expanded(
            child: _buildUserList(filteredUsers),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(List<AdminUserEntity> filteredUsers) {
    if (_isLoading) {
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (_, index) => const LoadingSkeletonCard(height: 85, borderRadius: 14),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.onSurface, fontSize: 15),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchUsers,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (filteredUsers.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchUsers,
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: EmptyStateWidget(
                icon: Icons.person_search_rounded,
                title: 'No Users Found',
                message: _searchQuery.isNotEmpty
                    ? 'No users match "$_searchQuery" in role "$_selectedRoleFilter".'
                    : 'There are no users registered under this filter.',
                actionText: 'Clear Filters',
                onAction: () {
                  _searchController.clear();
                  setState(() {
                    _selectedRoleFilter = 'All';
                    _searchQuery = '';
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchUsers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return AdminUserCardWidget(
            userEntity: user,
            onTap: () => _showUserDetailsModal(user.id),
          );
        },
      ),
    );
  }
}
