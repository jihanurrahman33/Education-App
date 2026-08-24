import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/role_selection_card_widget.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String _selectedRole = 'student';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        color: AppColors.onPrimary,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'How will you use EduFlow?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Select the role that best describes your goals. You can manage courses or start learning right away.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Reusable Student Option Card
                  RoleSelectionCardWidget(
                    isSelected: _selectedRole == 'student',
                    title: 'I am a Student',
                    subtitle:
                        'Access all approved video lectures, take quizzes, complete assignments, and earn verified certificates.',
                    icon: Icons.school_rounded,
                    color: AppColors.primary,
                    badgeText: 'POPULAR',
                    onTap: () => setState(() => _selectedRole = 'student'),
                  ),
                  const SizedBox(height: 16),

                  // Reusable Teacher Option Card
                  RoleSelectionCardWidget(
                    isSelected: _selectedRole == 'teacher',
                    title: 'I am a Teacher / Instructor',
                    subtitle:
                        'Create comprehensive curriculums, upload learning materials, construct auto-graded quizzes, and track student success.',
                    icon: Icons.cast_for_education_rounded,
                    color: AppColors.secondary,
                    badgeText: 'APPROVAL REQUIRED',
                    onTap: () => setState(() => _selectedRole = 'teacher'),
                  ),
                  const SizedBox(height: 32),

                  CustomButton(
                    text: 'Continue as ${_selectedRole == 'teacher' ? 'Teacher' : 'Student'}',
                    backgroundColor:
                        _selectedRole == 'teacher' ? AppColors.secondary : AppColors.primary,
                    onPressed: () {
                      context.push('/register?role=$_selectedRole');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
