import 'package:flutter/material.dart';
import '../models/chat.dart';

class ChatRepository {
  Future<List<Chat>> getChats() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Chat(
        id: 1,
        title: "Telegram Team",
        lastMessage:
            "Welcome to Telegram! This is a mock message to test layout.",
        lastTime: DateTime.now().subtract(const Duration(minutes: 5)),
        unreadCount: 3,
        avatarColor: const Color(0xFF517DA2),
      ),
      Chat(
        id: 2,
        title: "Saved Messages",
        lastMessage: "Project_specs_v2.pdf",
        lastTime: DateTime.now().subtract(const Duration(hours: 1)),
        unreadCount: 0,
        avatarColor: Colors.blueAccent,
      ),
      Chat(
        id: 3,
        title: "Flutter Developers",
        lastMessage: "Does anyone know how to optimize Hero animations?",
        lastTime: DateTime.now().subtract(const Duration(hours: 4)),
        unreadCount: 128,
        avatarColor: Colors.orange,
      ),
      Chat(
        id: 4,
        title: "Design Group",
        lastMessage: "Alice: Check out the new figma file.",
        lastTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 5,
        avatarColor: Colors.purple,
      ),
      Chat(
        id: 5,
        title: "Mom",
        lastMessage: "Call me when you are free ❤️",
        lastTime: DateTime.now().subtract(const Duration(days: 2)),
        unreadCount: 1,
        avatarColor: Colors.pink,
      ),
      Chat(
        id: 6,
        title: "Work Announcement",
        lastMessage: "Office will be closed tomorrow for maintenance.",
        lastTime: DateTime.now().subtract(const Duration(days: 3)),
        unreadCount: 0,
        avatarColor: Colors.green,
      ),
    ];
  }
}
