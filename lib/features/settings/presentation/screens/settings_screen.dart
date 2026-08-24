import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../domain/entities/app_settings_entity.dart';
import '../../domain/usecases/get_settings_use_case.dart';
import '../../domain/usecases/save_settings_use_case.dart';
import '../widgets/settings_group_card_widget.dart';
import '../widgets/settings_tile_item_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GetSettingsUseCase _getSettingsUseCase = GetIt.I<GetSettingsUseCase>();
  final SaveSettingsUseCase _saveSettingsUseCase = GetIt.I<SaveSettingsUseCase>();

  AppSettingsEntity _settings = const AppSettingsEntity();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final result = await _getSettingsUseCase(const NoParams());
    if (!mounted) return;

    result.fold(
      (_) => setState(() => _isLoading = false),
      (settings) => setState(() {
        _settings = settings;
        _isLoading = false;
      }),
    );
  }

  void _updateSettings(AppSettingsEntity newSettings) {
    setState(() => _settings = newSettings);
    _saveSettingsUseCase(newSettings);
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          value: _settings.pushNotificationsEnabled,
                          activeTrackColor: AppColors.primary,
                          onChanged: (val) {
                            _updateSettings(
                              _settings.copyWith(pushNotificationsEnabled: val),
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      SettingsTileItemWidget(
                        icon: Icons.mail_outline_rounded,
                        title: 'Email Digest',
                        subtitle: 'Weekly progress & certificate updates',
                        trailing: Switch(
                          value: _settings.emailNotificationsEnabled,
                          activeTrackColor: AppColors.primary,
                          onChanged: (val) {
                            _updateSettings(
                              _settings.copyWith(emailNotificationsEnabled: val),
                            );
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
                          value: _settings.isDarkMode,
                          activeTrackColor: AppColors.primary,
                          onChanged: (val) {
                            _updateSettings(
                              _settings.copyWith(isDarkMode: val),
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      SettingsTileItemWidget(
                        icon: Icons.wifi_rounded,
                        title: 'Download via Wi-Fi Only',
                        subtitle: 'Save mobile data consumption',
                        trailing: Switch(
                          value: _settings.downloadOverWifiOnly,
                          activeTrackColor: AppColors.primary,
                          onChanged: (val) {
                            _updateSettings(
                              _settings.copyWith(downloadOverWifiOnly: val),
                            );
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
