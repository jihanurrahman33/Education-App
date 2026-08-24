import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_skeleton_widget.dart';
import '../../domain/entities/admin_user_entity.dart';
import '../../domain/usecases/get_users_use_case.dart';
import '../widgets/admin_user_card_widget.dart';

class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() => _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  final GetUsersUseCase _getUsersUseCase = GetIt.I<GetUsersUseCase>();
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
          return AdminUserCardWidget(userEntity: user);
        },
      ),
    );
  }
}
