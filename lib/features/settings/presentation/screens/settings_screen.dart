import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../widgets/settings_group_card_widget.dart';
import '../widgets/settings_tile_item_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;
  bool _darkMode = false;

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
          'Settings & Preferences',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Account Group
            SettingsGroupCardWidget(
              title: 'ACCOUNT',
              children: [
                SettingsTileItemWidget(
                  icon: Icons.person_outline_rounded,
                  title: 'Edit Profile Information',
                  subtitle: 'Update your name, bio, and avatar',
                  onTap: () => context.push('/profile/edit'),
                ),
                const Divider(height: 1),
                SettingsTileItemWidget(
                  icon: Icons.lock_outline_rounded,
                  title: 'Password & Security',
                  subtitle: 'Manage two-factor auth & password',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password & Security settings')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Notifications Group
            SettingsGroupCardWidget(
              title: 'NOTIFICATIONS',
              children: [
                SettingsTileItemWidget(
                  icon: Icons.notifications_active_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Daily study streak & lesson reminders',
                  trailing: Switch(
                    value: _pushNotifications,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _pushNotifications = val);
                    },
                  ),
                ),
                const Divider(height: 1),
                SettingsTileItemWidget(
                  icon: Icons.mail_outline_rounded,
                  title: 'Email Digest',
                  subtitle: 'Weekly progress & certificate updates',
                  trailing: Switch(
                    value: _emailAlerts,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _emailAlerts = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Appearance & App Info Group
            SettingsGroupCardWidget(
              title: 'APPEARANCE & SYSTEM',
              children: [
                SettingsTileItemWidget(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Theme',
                  subtitle: 'Academic modernist night mode',
                  trailing: Switch(
                    value: _darkMode,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() => _darkMode = val);
                    },
                  ),
                ),
                const Divider(height: 1),
                SettingsTileItemWidget(
                  icon: Icons.info_outline_rounded,
                  title: 'App Version',
                  trailing: const Text(
                    'v1.0.0 (Build 2026.08)',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            CustomButton(
              text: 'Log Out of EduFlow',
              icon: Icons.logout_rounded,
              isOutlined: true,
              textColor: AppColors.error,
              backgroundColor: AppColors.error,
              onPressed: () {
                context.read<AuthBloc>().add(const AuthLogoutRequested());
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
