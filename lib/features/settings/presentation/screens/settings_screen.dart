import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailUpdates = true;
  bool _downloadOverWifiOnly = true;

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Preferences',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Push Notifications', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Receive instant alerts for quiz results and course updates', style: TextStyle(fontSize: 12)),
                    value: _pushNotifications,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setState(() => _pushNotifications = val),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Email Digest', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Weekly summary of learning streaks and progress', style: TextStyle(fontSize: 12)),
                    value: _emailUpdates,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setState(() => _emailUpdates = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Downloads & Storage',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Download over Wi-Fi only', style: TextStyle(fontSize: 14)),
                    subtitle: const Text('Save mobile data when downloading video lessons & PDF notes', style: TextStyle(fontSize: 12)),
                    value: _downloadOverWifiOnly,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) => setState(() => _downloadOverWifiOnly = val),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Clear Cached Course Data', style: TextStyle(fontSize: 14)),
                    trailing: const Text('128 MB', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cache cleared successfully!')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'About EduFlow',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                children: [
                  ListTile(
                    title: Text('Version', style: TextStyle(fontSize: 14)),
                    trailing: Text('1.0.0 (Academic Modernist)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ),
                  Divider(height: 1),
                  ListTile(
                    title: Text('Backend REST Server', style: TextStyle(fontSize: 14)),
                    trailing: Text('Connected (Port 8000)', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
