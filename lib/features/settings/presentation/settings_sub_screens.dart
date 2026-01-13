import 'package:flutter/material.dart';
import '../../chat/presentation/widgets/message_bubble.dart';
import '../../chat/data/models/message.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;
  const SettingsSectionHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF517DA2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _privateChats = true;
  bool _groups = true;
  bool _channels = true;
  bool _inAppSound = true;
  bool _inAppVibrate = true;
  bool _inAppPreview = true;
  bool _contactJoined = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF517DA2),
        title: const Text("Notifications and Sounds",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const SettingsSectionHeader("Message notifications"),
          _buildSwitchTile("Private Chats", _privateChats,
              (v) => setState(() => _privateChats = v)),
          const Divider(height: 1, indent: 72),
          _buildSwitchTile(
              "Groups", _groups, (v) => setState(() => _groups = v)),
          const Divider(height: 1, indent: 72),
          _buildSwitchTile(
              "Channels", _channels, (v) => setState(() => _channels = v)),
          const SettingsSectionHeader("Calls"),
          _buildActionTile("Vibrate", "Default"),
          const Divider(height: 1, indent: 72),
          _buildActionTile("Ringtone", "Default"),
          const SettingsSectionHeader("Badge Counter"),
          _buildSwitchTile("Show Badge Icon", true, (v) {}),
          const Divider(height: 1, indent: 72),
          _buildSwitchTile("Include Muted Chats", false, (v) {}),
          const Divider(height: 1, indent: 72),
          _buildActionTile("Count Unread Messages", "One by one"),
          const SettingsSectionHeader("In-app notifications"),
          _buildSwitchTile("In-App Sounds", _inAppSound,
              (v) => setState(() => _inAppSound = v)),
          const Divider(height: 1, indent: 72),
          _buildSwitchTile("In-App Vibrate", _inAppVibrate,
              (v) => setState(() => _inAppVibrate = v)),
          const Divider(height: 1, indent: 72),
          _buildSwitchTile("In-App Preview", _inAppPreview,
              (v) => setState(() => _inAppPreview = v)),
          const SettingsSectionHeader("Events"),
          _buildSwitchTile("Contact joined Telegram", _contactJoined,
              (v) => setState(() => _contactJoined = v)),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextButton(
              onPressed: () {},
              child: const Text("Reset All Notifications",
                  style: TextStyle(color: Colors.red, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      color: Colors.white,
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF517DA2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        subtitle: Text(subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        onTap: () {},
      ),
    );
  }
}

class ChatSettingsScreen extends StatefulWidget {
  const ChatSettingsScreen({super.key});

  @override
  State<ChatSettingsScreen> createState() => _ChatSettingsScreenState();
}

class _ChatSettingsScreenState extends State<ChatSettingsScreen> {
  double _textSize = 16.0;
  bool _nightMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF517DA2),
        title:
            const Text("Chat Settings", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: 140,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF96B3C8),
            ),
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Transform.scale(
                  scale: _textSize / 16.0,
                  child: IgnorePointer(
                    child: MessageBubble(
                      message: Message(
                        id: 0,
                        chatId: 0,
                        content: "This is a preview of the message size.",
                        timestamp: DateTime.now(),
                        isMe: false,
                        status: MessageStatus.read,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Transform.scale(
                  scale: _textSize / 16.0,
                  child: IgnorePointer(
                    child: MessageBubble(
                      message: Message(
                        id: 1,
                        chatId: 0,
                        content: "Looks good!",
                        timestamp: DateTime.now(),
                        isMe: true,
                        status: MessageStatus.read,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Message text size",
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.bold)),
                ),
                Slider(
                  value: _textSize,
                  min: 12.0,
                  max: 30.0,
                  divisions: 18,
                  activeColor: const Color(0xFF517DA2),
                  label: _textSize.round().toString(),
                  onChanged: (v) => setState(() => _textSize = v),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("12", style: TextStyle(color: Colors.grey)),
                      Text("30", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.wallpaper, color: Color(0xFF517DA2)),
              title: const Text("Change Chat Background"),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 14, color: Colors.grey),
              onTap: () {},
            ),
          ),
          const SettingsSectionHeader("Color theme"),
          Container(
            height: 100,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildThemeItem(const Color(0xFF517DA2), "Classic", true),
                _buildThemeItem(const Color(0xFF4CA5FF), "Day", false),
                _buildThemeItem(const Color(0xFF212121), "Dark", false),
                _buildThemeItem(const Color(0xFF2A2E33), "Night", false),
                _buildThemeItem(const Color(0xFF5088BD), "Arctic", false),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text("Auto-Night Mode"),
                  subtitle: const Text("Disabled"),
                  value: _nightMode,
                  onChanged: (v) => setState(() => _nightMode = v),
                  activeColor: const Color(0xFF517DA2),
                ),
                const Divider(height: 1, indent: 72),
                const ListTile(
                  title: Text("In-App Browser"),
                  trailing: Switch(
                      value: true,
                      onChanged: null,
                      activeColor: Color(0xFF517DA2)),
                ),
                const Divider(height: 1, indent: 72),
                const ListTile(
                  title: Text("Direct Share"),
                  subtitle: Text("Show recent chats in Android share sheet"),
                  trailing: Switch(
                      value: true,
                      onChanged: null,
                      activeColor: Color(0xFF517DA2)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildThemeItem(Color color, String name, bool selected) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: selected
                    ? Border.all(color: const Color(0xFF517DA2), width: 2)
                    : null,
                boxShadow: [
                  if (selected)
                    const BoxShadow(
                        color: Colors.black26, blurRadius: 4, spreadRadius: 1)
                ]),
            child:
                selected ? const Icon(Icons.check, color: Colors.white) : null,
          ),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF517DA2),
        title: const Text("Privacy and Security",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          const SettingsSectionHeader("Privacy"),
          _buildPrivacyItem("Blocked Users", "None"),
          const Divider(height: 1, indent: 16),
          _buildPrivacyItem("Phone Number", "My Contacts"),
          const Divider(height: 1, indent: 16),
          _buildPrivacyItem("Last Seen & Online", "Nobody"),
          const Divider(height: 1, indent: 16),
          _buildPrivacyItem("Profile Photos", "Everybody"),
          const Divider(height: 1, indent: 16),
          _buildPrivacyItem("Forwarded Messages", "Everybody"),
          const Divider(height: 1, indent: 16),
          _buildPrivacyItem("Calls", "Everybody"),
          const Divider(height: 1, indent: 16),
          _buildPrivacyItem("Groups & Channels", "Everybody"),
          const SettingsSectionHeader("Security"),
          _buildPrivacyItem("Passcode Lock", "Off"),
          const Divider(height: 1, indent: 16),
          _buildPrivacyItem("Two-Step Verification", "On"),
          const Divider(height: 1, indent: 16),
          _buildPrivacyItem("Active Sessions", "3 devices"),
          const SettingsSectionHeader("Advanced"),
          _buildPrivacyItem("Delete My Account", "If away for 6 months"),
        ],
      ),
    );
  }

  Widget _buildPrivacyItem(String title, String value) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value,
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

class DataSettingsScreen extends StatelessWidget {
  const DataSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF517DA2),
        title: const Text("Data and Storage",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        children: [
          const SettingsSectionHeader("Disk and network usage"),
          Container(
            color: Colors.white,
            child: ListTile(
              title: const Text("Storage Usage"),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 14, color: Colors.grey),
              onTap: () {},
            ),
          ),
          const Divider(height: 1, indent: 16),
          Container(
            color: Colors.white,
            child: ListTile(
              title: const Text("Data Usage"),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 14, color: Colors.grey),
              onTap: () {},
            ),
          ),
          const SettingsSectionHeader("Automatic media download"),
          _buildSwitch("When using mobile data", true),
          const Divider(height: 1, indent: 72),
          _buildSwitch("When connected to Wi-Fi", true),
          const Divider(height: 1, indent: 72),
          _buildSwitch("When roaming", false),
        ],
      ),
    );
  }

  Widget _buildSwitch(String title, bool val) => Container(
      color: Colors.white,
      child: SwitchListTile(
          title: Text(title),
          value: val,
          onChanged: (v) {},
          activeColor: const Color(0xFF517DA2)));
}

class DevicesSettingsScreen extends StatelessWidget {
  const DevicesSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF517DA2),
        title: const Text("Devices", style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
            Icon(Icons.devices, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text("This device + 2 others")
          ])),
    );
  }
}

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF517DA2),
        title: const Text("Language", style: TextStyle(color: Colors.white)),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      body: ListView(
        children: [
          Container(
              color: Colors.white,
              child: const ListTile(
                  title: Text("English"),
                  trailing: Icon(Icons.check, color: Color(0xFF517DA2)))),
          const Divider(height: 1, indent: 16),
          Container(
              color: Colors.white,
              child: const ListTile(title: Text("Chinese (中文)"), onTap: null)),
          const Divider(height: 1, indent: 16),
          Container(
              color: Colors.white,
              child:
                  const ListTile(title: Text("Japanese (日本語)"), onTap: null)),
        ],
      ),
    );
  }
}
