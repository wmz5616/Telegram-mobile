import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../auth/data/models/user.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showEditNameDialog(BuildContext context, WidgetRef ref, User user) {
    final firstNameController = TextEditingController(text: user.firstName);
    final lastNameController = TextEditingController(text: user.lastName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Name"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: "First Name"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: lastNameController,
              decoration:
                  const InputDecoration(labelText: "Last Name (Optional)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final updatedUser = User(
                id: user.id,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                phoneNumber: user.phoneNumber,
                avatarColor: user.avatarColor,
              );
              ref.read(authProvider.notifier).updateUser(updatedUser);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showChangeNumberWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Number"),
        content: const Text(
          "Users will see your new number if they have it in their address book or your privacy settings allow them to see it. \n\nYou can modify your number there.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Change number flow initiated")),
              );
            },
            child: const Text("Change"),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pop(context);
              context.go('/');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged out successfully")),
              );
            },
            child: const Text("Log Out", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.currentUser;
    final currentTheme = ref.watch(themeProvider);
    final isDark = currentTheme == ThemeMode.dark;

    final bgColor = isDark ? const Color(0xFF1C242F) : const Color(0xFFF0F2F5);
    final sectionColor = isDark ? const Color(0xFF232D3A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];
    final headerColor =
        isDark ? const Color(0xFF232D3A) : const Color(0xFF517DA2);

    return Scaffold(
      backgroundColor: bgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140.0,
            floating: false,
            pinned: true,
            backgroundColor: headerColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit_name') {
                    _showEditNameDialog(context, ref, user);
                  } else if (value == 'logout') {
                    _showLogoutDialog(context, ref);
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit_name',
                    child: Text('Edit name'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Log out'),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: headerColor,
                padding: const EdgeInsets.only(left: 24, bottom: 20),
                alignment: Alignment.bottomLeft,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'profile_avatar',
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: user.avatarColor,
                        child: Text(
                          user.initials,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.fullName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Online",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  _buildSectionTitle(context, "Account"),
                  Container(
                    color: sectionColor,
                    child: Column(
                      children: [
                        _buildInfoTile(
                          context,
                          user.phoneNumber,
                          "Tap to change phone number",
                          textColor,
                          subtitleColor,
                          onTap: () => _showChangeNumberWarning(context),
                        ),
                        const Divider(height: 1, indent: 72),
                        _buildInfoTile(
                          context,
                          "@${user.firstName.toLowerCase()}",
                          "Username",
                          textColor,
                          subtitleColor,
                          onTap: () {},
                        ),
                        const Divider(height: 1, indent: 72),
                        _buildInfoTile(
                          context,
                          "Mobile developer aiming for pixel perfection.",
                          "Bio",
                          textColor,
                          subtitleColor,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSectionTitle(context, "Settings"),
                  Container(
                    color: sectionColor,
                    child: Column(
                      children: [
                        _buildSettingTile(
                            context,
                            Icons.notifications_outlined,
                            "Notifications and Sounds",
                            textColor,
                            '/settings/notifications'),
                        _buildDivider(),
                        _buildSettingTile(
                            context,
                            Icons.lock_outline,
                            "Privacy and Security",
                            textColor,
                            '/settings/privacy'),
                        _buildDivider(),
                        _buildSettingTile(context, Icons.data_usage,
                            "Data and Storage", textColor, '/settings/data'),
                        _buildDivider(),
                        _buildSettingTile(
                            context,
                            Icons.chat_bubble_outline,
                            "Chat Settings",
                            textColor,
                            '/settings/chat_settings'),
                        _buildDivider(),
                        _buildSettingTile(context, Icons.devices, "Devices",
                            textColor, '/settings/devices'),
                        _buildDivider(),
                        _buildSettingTile(context, Icons.language, "Language",
                            textColor, '/settings/language'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSectionTitle(context, "Help"),
                  Container(
                    color: sectionColor,
                    child: Column(
                      children: [
                        _buildSettingTile(context, Icons.chat_outlined,
                            "Ask a Question", textColor, null),
                        _buildDivider(),
                        _buildSettingTile(context, Icons.help_outline,
                            "Telegram FAQ", textColor, null),
                        _buildDivider(),
                        _buildSettingTile(context, Icons.policy_outlined,
                            "Privacy Policy", textColor, null),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text(
                      "Telegram for Android v10.0.0 (Mock)",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF517DA2),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildInfoTile(BuildContext context, String title, String subtitle,
      Color titleColor, Color? subColor,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(fontSize: 16, color: titleColor)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: TextStyle(fontSize: 13, color: subColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title,
      Color textColor, String? route) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: TextStyle(fontSize: 16, color: textColor)),
      onTap: () {
        if (route != null) {
          context.push(route);
        }
      },
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 72);
  }
}
