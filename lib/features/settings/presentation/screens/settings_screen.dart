import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:nownowww/features/auth/presentation/controllers/auth_controller.dart';
import 'package:nownowww/features/profile/presentation/providers/profile_providers.dart';
import 'package:nownowww/features/settings/presentation/providers/theme_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).valueOrNull;
    final themeMode = ref.watch(themeControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          if (profile != null) ...[
            _buildUserHeader(profile, context),
            const SizedBox(height: 24),
          ],
          _buildSectionHeader('Account'),
          _buildSettingsTile(Icons.person_outline, 'Edit Profile', onTap: () => context.push('/edit-profile', extra: profile)),
          _buildSettingsTile(Icons.lock_outline, 'Privacy & Security', onTap: () => context.push('/privacy-settings')),
          _buildSettingsTile(Icons.notifications_none, 'Notifications'),
          _buildSettingsTile(Icons.block_outlined, 'Blocked Users'),
          _buildSettingsTile(Icons.visibility_off_outlined, 'Muted Words'),
          _buildSettingsTile(Icons.language_outlined, 'Language', trailingText: 'English'),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Preferences'),
          _buildSwitchTile(
            Icons.dark_mode_outlined, 
            'Dark Mode', 
            themeMode == ThemeMode.dark,
            onChanged: (val) => ref.read(themeControllerProvider.notifier).toggleTheme(),
          ),
          _buildSettingsTile(Icons.text_format, 'Text Size', trailingText: 'Medium'),
          _buildSettingsTile(Icons.tune, 'Feed Preferences'),
          _buildSwitchTile(Icons.data_usage, 'Data Saver', false, onChanged: (v) {}),
          _buildSettingsTile(Icons.download_outlined, 'Download My Data'),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Support'),
          _buildSettingsTile(Icons.help_outline, 'Help Center'),
          _buildSettingsTile(
            Icons.mail_outline, 
            'Contact Us',
            onTap: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'support@nownowww.com',
                queryParameters: {
                  'subject': 'NOWNOWWW Support Request',
                },
              );
              if (await canLaunchUrl(emailLaunchUri)) {
                await launchUrl(emailLaunchUri);
              }
            },
          ),
          _buildSettingsTile(Icons.info_outline, 'About NOWNOWWW!', trailingText: 'v1.0.0'),
          
          const SizedBox(height: 40),
          _buildLogoutButton(ref),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildUserHeader(dynamic profile, BuildContext context) {
    return InkWell(
      onTap: () => context.push('/profile'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withAlpha(20)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: profile.photoUrl != null ? NetworkImage(profile.photoUrl!) : null,
              child: profile.photoUrl == null ? const Icon(Icons.person, size: 30, color: Colors.grey) : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(profile.displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('@${profile.username}', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {VoidCallback? onTap, String? trailingText}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) 
            Text(trailingText, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, {required Function(bool) onChanged}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: Colors.black,
      ),
    );
  }

  Widget _buildLogoutButton(WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.red.withAlpha(5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withAlpha(20)),
      ),
      child: TextButton.icon(
        onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
        icon: const Icon(Icons.logout, color: Colors.red, size: 18),
        label: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
