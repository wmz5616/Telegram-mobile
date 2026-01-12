import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/chat_list_item.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> mockChats = [
      {
        "name": "Saved Messages",
        "message": "File_2024.pdf",
        "time": "12:30",
        "unread": 0,
        "online": false,
      },
      {
        "name": "Pavel Durov",
        "message": "Welcome to Telegram! This is a clone.",
        "time": "11:45",
        "unread": 2,
        "online": true,
      },
      {
        "name": "Flutter Group",
        "message": "User123: Is Provider better than Riverpod?",
        "time": "Yesterday",
        "unread": 156,
        "online": false,
      },
      {
        "name": "Mom",
        "message": "Call me when you are free.",
        "time": "Mon",
        "unread": 0,
        "online": false,
      },
      {
        "name": "Work Chat",
        "message": "Meeting starts in 5 mins",
        "time": "Sun",
        "unread": 5,
        "online": false,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Telegram'),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text("Gemini User"),
              accountEmail: Text("+86 138 0000 0000"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text("G", style: TextStyle(fontSize: 24)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.group),
              title: const Text('New Group'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => context.push('/settings'),
            ),
          ],
        ),
      ),
      body: ListView.separated(
        itemCount: mockChats.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 70),
        itemBuilder: (context, index) {
          final chat = mockChats[index];
          return ChatListItem(
            name: chat['name'],
            message: chat['message'],
            time: chat['time'],
            unreadCount: chat['unread'],
            isOnline: chat['online'],
            isRead: true,
            onTap: () {
              context.pushNamed(
                'chat',
                extra: {'name': chat['name']},
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
    );
  }
}
