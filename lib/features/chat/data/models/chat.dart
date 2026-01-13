import 'package:flutter/material.dart';

class Chat {
  final int id;
  final String title;
  final String lastMessage;
  final DateTime lastTime;
  final int unreadCount;
  final Color avatarColor;
  final String? avatarUrl;

  Chat({
    required this.id,
    required this.title,
    required this.lastMessage,
    required this.lastTime,
    required this.unreadCount,
    required this.avatarColor,
    this.avatarUrl,
  });
}
