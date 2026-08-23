import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  UserRole _selectedRole = UserRole.student;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthRegisterSubmitted(
              username: _usernameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              role: _selectedRole,
              firstName: _firstNameController.text.trim().isNotEmpty
                  ? _firstNameController.text.trim()
                  : null,
              lastName: _lastNameController.text.trim().isNotEmpty
                  ? _lastNameController.text.trim()
                  : null,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.go('/login'),
        ),
        title: const Text('Create Account'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status.isError && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state.status.isAuthenticated) {
            context.go('/dashboard');
          }
        },
        builder: (context, state) {
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Join Education App',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Choose your role and get started today',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'I am joining as a:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<UserRole>(
                      segments: const [
                        ButtonSegment<UserRole>(
                          value: UserRole.student,
                          label: Text('Student'),
                          icon: Icon(Icons.school_outlined),
                        ),
                        ButtonSegment<UserRole>(
                          value: UserRole.teacher,
                          label: Text('Teacher'),
                          icon: Icon(Icons.person_outline),
                        ),
                      ],
                      selected: {_selectedRole},
                      onSelectionChanged: (newSelection) {
                        setState(() {
                          _selectedRole = newSelection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _usernameController,
                      label: 'Username',
                      hint: 'johndoe',
                      prefixIcon: Icons.account_circle_outlined,
                      validator: (val) =>
                          (val == null || val.isEmpty) ? 'Username is required' : null,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'john@example.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: (val) =>
                          (val == null || !val.contains('@')) ? 'Valid email is required' : null,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: _firstNameController,
                            label: 'First Name',
                            hint: 'John',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            controller: _lastNameController,
                            label: 'Last Name',
                            hint: 'Doe',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: '••••••••',
                      obscureText: _obscurePassword,
                      prefixIcon: Icons.lock_outline_rounded,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (val) =>
                          (val == null || val.length < 6) ? 'Password must be at least 6 characters' : null,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Create Account',
                      isLoading: state.status.isLoading,
                      onPressed: _onRegister,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
