import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';
import '../widgets/settings_group_card_widget.dart';
import '../widgets/settings_tile_item_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const LoadSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Settings & Preferences',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.secondary,
              ),
            );
          }
        },
        builder: (context, state) {
          final settings = state.settings;

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 768;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 32.0 : 20.0,
                      vertical: 20.0,
                    ),
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
                            const Divider(height: 1, color: AppColors.divider),
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
                                value: settings.pushNotificationsEnabled,
                                activeTrackColor: AppColors.primary,
                                onChanged: (val) {
                                  context
                                      .read<SettingsBloc>()
                                      .add(TogglePushNotificationsEvent(val));
                                },
                              ),
                            ),
                            const Divider(height: 1, color: AppColors.divider),
                            SettingsTileItemWidget(
                              icon: Icons.mail_outline_rounded,
                              title: 'Email Digest',
                              subtitle: 'Weekly progress & certificate updates',
                              trailing: Switch(
                                value: settings.emailNotificationsEnabled,
                                activeTrackColor: AppColors.primary,
                                onChanged: (val) {
                                  context
                                      .read<SettingsBloc>()
                                      .add(ToggleEmailNotificationsEvent(val));
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
                                value: settings.isDarkMode,
                                activeTrackColor: AppColors.primary,
                                onChanged: (val) {
                                  context
                                      .read<SettingsBloc>()
                                      .add(ToggleDarkModeEvent(val));
                                },
                              ),
                            ),
                            const Divider(height: 1, color: AppColors.divider),
                            SettingsTileItemWidget(
                              icon: Icons.wifi_rounded,
                              title: 'Download via Wi-Fi Only',
                              subtitle: 'Save mobile data consumption',
                              trailing: Switch(
                                value: settings.downloadOverWifiOnly,
                                activeTrackColor: AppColors.primary,
                                onChanged: (val) {
                                  context
                                      .read<SettingsBloc>()
                                      .add(ToggleWifiDownloadEvent(val));
                                },
                              ),
                            ),
                            const Divider(height: 1, color: AppColors.divider),
                            SettingsTileItemWidget(
                              icon: Icons.info_outline_rounded,
                              title: 'App Version',
                              trailing: const Text(
                                'v1.0.0 (Build 2026.08)',
                                style: TextStyle(
                                    fontSize: 12, color: AppColors.textSecondary),
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}
