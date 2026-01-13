import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../chat/data/models/chat.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final List<Map<String, dynamic>> _contacts = [
    {
      "id": 101,
      "name": "Alice Smith",
      "status": "last seen recently",
      "color": Colors.orange
    },
    {
      "id": 102,
      "name": "Bob Johnson",
      "status": "online",
      "color": Colors.purple
    },
    {
      "id": 103,
      "name": "Charlie Brown",
      "status": "last seen 5 mins ago",
      "color": Colors.green
    },
    {
      "id": 104,
      "name": "David Wilson",
      "status": "online",
      "color": Colors.blue
    },
    {
      "id": 105,
      "name": "Eva Green",
      "status": "last seen yesterday",
      "color": Colors.redAccent
    },
    {
      "id": 106,
      "name": "Frank White",
      "status": "last seen just now",
      "color": Colors.teal
    },
  ];

  @override
  Widget build(BuildContext context) {
    _contacts.sort((a, b) => a["name"].compareTo(b["name"]));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF517DA2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "New Message",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.sort_by_alpha, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: _contacts.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeaderActions();
          }

          final contact = _contacts[index - 1];
          return _buildContactTile(contact);
        },
      ),
    );
  }

  Widget _buildHeaderActions() {
    return Column(
      children: [
        _buildActionTile(Icons.group_add, "New Group"),
        _buildActionTile(Icons.lock_outline, "New Secret Chat"),
        _buildActionTile(Icons.campaign, "New Channel"),
        Container(
          height: 32,
          width: double.infinity,
          color: const Color(0xFFF0F2F5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: const Text(
            "Sorted by last seen time",
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF517DA2), size: 28),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {},
    );
  }

  Widget _buildContactTile(Map<String, dynamic> contact) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: contact['color'],
        radius: 22,
        child: Text(
          contact['name'].substring(0, 1),
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(contact['name'],
          style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        contact['status'],
        style: TextStyle(
          color: contact['status'] == 'online'
              ? const Color(0xFF517DA2)
              : Colors.grey,
        ),
      ),
      onTap: () {
        final chat = Chat(
          id: contact['id'],
          title: contact['name'],
          lastMessage: "",
          lastTime: DateTime.now(),
          unreadCount: 0,
          avatarColor: contact['color'],
        );
        context.pushReplacement('/chat/${chat.id}', extra: chat);
      },
    );
  }
}
