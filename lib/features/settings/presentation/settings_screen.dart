import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/avatar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldLight,
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.qr_code), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
          _buildProfileHeader(),
          const Divider(thickness: 8, color: Color(0xFFF0F0F0), height: 8),
          _buildSectionTitle('Account'),
          _buildSettingItem(
              Icons.phone, '+86 138 0000 0000', 'Tap to change phone number'),
          _buildSettingItem(Icons.alternate_email, '@gemini_user', 'Username'),
          _buildSettingItem(Icons.info_outline, 'Flutter Developer', 'Bio'),
          const Divider(thickness: 8, color: Color(0xFFF0F0F0), height: 8),
          _buildSectionTitle('Settings'),
          _buildSettingItem(
              Icons.notifications_none, 'Notifications and Sounds', ''),
          _buildSettingItem(Icons.lock_outline, 'Privacy and Security', ''),
          _buildSettingItem(Icons.data_usage, 'Data and Storage', ''),
          _buildSettingItem(Icons.chat_bubble_outline, 'Chat Settings', ''),
          _buildSettingItem(Icons.folder_open, 'Chat Folders', ''),
          _buildSettingItem(Icons.devices, 'Devices', ''),
          _buildSettingItem(Icons.language, 'Language', 'English'),
          const Divider(thickness: 8, color: Color(0xFFF0F0F0), height: 8),
          _buildSettingItem(Icons.star_border, 'Telegram Premium', ''),
          _buildSettingItem(Icons.help_outline, 'Ask a Question', ''),
          _buildSettingItem(Icons.question_answer_outlined, 'Telegram FAQ', ''),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'Telegram for Android v10.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        children: [
          const Avatar(
            text: "Gemini User",
            radius: 36,
            backgroundColor: AppColors.primaryBlue,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Gemini User",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Online",
                  style: TextStyle(
                    color: AppColors.primaryBlue,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      width: double.infinity,
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title, String subtitle) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 26),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
