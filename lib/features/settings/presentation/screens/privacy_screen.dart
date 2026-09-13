import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Privacy & Security', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildInfoCard(),
          const SizedBox(height: 24),
          _buildSectionHeader('Account Privacy'),
          _buildSwitchTile(Icons.lock_outline, 'Private Account', 'Only approved followers can see your posts and profile.', false),
          _buildSettingsTile(Icons.people_outline, 'Who can follow you', 'Everyone'),
          _buildSettingsTile(Icons.chat_bubble_outline, 'Who can comment on your posts', 'Everyone'),
          _buildSettingsTile(Icons.alternate_email, 'Who can mention you', 'Everyone'),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Visibility'),
          _buildSwitchTile(Icons.visibility_outlined, 'Show activity status', 'Let others see when you\'re active', true),
          _buildSwitchTile(Icons.checklist, 'Show read receipts', 'Let others know when you\'ve read their messages', true),
          _buildSwitchTile(Icons.favorite_border, 'Hide likes and reactions', 'Others won\'t see the likes on your posts', false),
          _buildSwitchTile(Icons.search, 'Search visibility', 'Allow your profile to appear in search results', true),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Security'),
          _buildSettingsTile(Icons.verified_user_outlined, 'Two-Factor Authentication', 'Add an extra layer of security to your account'),
          _buildSettingsTile(Icons.login, 'Login Activity', 'See where and when your account was accessed'),
          _buildSettingsTile(Icons.key_outlined, 'Change Password', ''),
          
          const SizedBox(height: 24),
          _buildSectionHeader('Data & Permissions'),
          _buildSettingsTile(Icons.download_outlined, 'Download Your Data', 'Get a copy of your account data'),
          _buildSettingsTile(Icons.delete_outline, 'Delete Account', 'Permanently delete your account and data', isDestructive: true),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withAlpha(5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withAlpha(10)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.purple.withAlpha(20), shape: BoxShape.circle),
            child: const Icon(Icons.security, color: Colors.purple, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Your privacy matters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Manage your privacy settings and control how others see and interact with you.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
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

  Widget _buildSettingsTile(IconData icon, String title, String subtitle, {bool isDestructive = false}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.black87, size: 22),
      title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDestructive ? Colors.red : Colors.black)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, String subtitle, bool value) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      trailing: Switch.adaptive(
        value: value,
        onChanged: (_) {},
        activeTrackColor: Colors.purple,
      ),
    );
  }
}
