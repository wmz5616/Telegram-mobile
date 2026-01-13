import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../../features/auth/data/models/user.dart';

class SideMenu extends ConsumerStatefulWidget {
  const SideMenu({super.key});

  @override
  ConsumerState<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends ConsumerState<SideMenu>
    with SingleTickerProviderStateMixin {
  bool _showAccounts = false;
  late AnimationController _arrowController;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _arrowController.dispose();
    super.dispose();
  }

  void _toggleAccounts() {
    setState(() {
      _showAccounts = !_showAccounts;
      if (_showAccounts) {
        _arrowController.forward();
      } else {
        _arrowController.reverse();
      }
    });
  }

  void _showInviteDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              const Text(
                "Invite Friends via...",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareIcon(Icons.copy, "Copy Link", Colors.blue),
                  _buildShareIcon(Icons.message, "SMS", Colors.green),
                  _buildShareIcon(Icons.email, "Email", Colors.red),
                  _buildShareIcon(Icons.more_horiz, "More", Colors.orange),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShareIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  void _showFeaturesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Open Browser"),
        content: const Text("This would open: https://telegram.org/features"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Open")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeProvider);
    final isDark = currentTheme == ThemeMode.dark;
    final authState = ref.watch(authProvider);
    final currentUser = authState.currentUser;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF1C242F) : Colors.white,
      child: Column(
        children: [
          _buildHeader(isDark, currentUser),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                            begin: const Offset(0, -0.02), end: Offset.zero)
                        .animate(animation),
                    child: child,
                  ),
                );
              },
              child: _showAccounts
                  ? _buildAccountsList(isDark, authState)
                  : _buildMainMenu(isDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark, User user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF232D3A) : const Color(0xFF517DA2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  _toggleAccounts();
                },
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: user.avatarColor,
                    child: Text(
                      user.initials,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: Colors.white,
                ),
                onPressed: () {
                  ref.read(themeProvider.notifier).state =
                      isDark ? ThemeMode.light : ThemeMode.dark;
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            user.fullName,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: _toggleAccounts,
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user.phoneNumber,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(width: 4),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(_arrowController),
                  child: const Icon(Icons.keyboard_arrow_down,
                      color: Colors.white70, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenu(bool isDark) {
    return ListView(
      key: const ValueKey("MainMenu"),
      padding: EdgeInsets.zero,
      children: [
        _buildMenuItem(Icons.group_outlined, "New Group", isDark, () {
          Navigator.pop(context);
          context.push('/new_group');
        }),
        _buildMenuItem(Icons.person_outline, "Contacts", isDark, () {
          Navigator.pop(context);
          context.push('/contacts');
        }),
        _buildMenuItem(Icons.call_outlined, "Calls", isDark, () {
          Navigator.pop(context);
          context.push('/calls');
        }),
        _buildMenuItem(Icons.location_on_outlined, "People Nearby", isDark, () {
          Navigator.pop(context);
          context.push('/nearby');
        }),
        _buildMenuItem(Icons.bookmark_border, "Saved Messages", isDark, () {
          Navigator.pop(context);
          context.push('/chat/999');
        }),
        _buildMenuItem(Icons.settings_outlined, "Settings", isDark, () {
          Navigator.pop(context);
          context.push('/settings');
        }),
        const Divider(),
        _buildMenuItem(Icons.person_add_outlined, "Invite Friends", isDark, () {
          Navigator.pop(context);
          _showInviteDialog(context);
        }),
        _buildMenuItem(Icons.help_outline, "Telegram Features", isDark, () {
          Navigator.pop(context);
          _showFeaturesDialog(context);
        }),
      ],
    );
  }

  Widget _buildAccountsList(bool isDark, AuthState authState) {
    return ListView(
      key: const ValueKey("AccountsList"),
      padding: EdgeInsets.zero,
      children: [
        ...authState.availableAccounts.map((user) {
          final isCurrent = user.id == authState.currentUser.id;
          return ListTile(
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: user.avatarColor,
              child: Text(user.initials,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
            title: Text(user.fullName,
                style:
                    TextStyle(color: isDark ? Colors.white : Colors.black87)),
            trailing:
                isCurrent ? const Icon(Icons.check, color: Colors.blue) : null,
            onTap: () {
              ref.read(authProvider.notifier).switchAccount(user);
              _toggleAccounts();
            },
          );
        }).toList(),
        _buildMenuItem(Icons.add, "Add Account", isDark, () {
          ref.read(authProvider.notifier).addAccount();
        }),
      ],
    );
  }

  Widget _buildMenuItem(
      IconData icon, String title, bool isDark, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon,
          color: isDark ? Colors.grey[400] : Colors.grey[700], size: 26),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }
}
