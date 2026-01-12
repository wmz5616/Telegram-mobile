import 'package:flutter/material.dart';
// ignore: unused_import
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/avatar.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String userName;

  const ChatScreen({
    super.key,
    required this.userName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [
    {
      "text": "See you tomorrow!",
      "time": "10:35",
      "isMe": false,
      "isRead": true,
    },
    {
      "text": "Ok, I will bring the documents.",
      "time": "10:34",
      "isMe": true,
      "isRead": true,
    },
    {
      "text": "Don't forget the meeting at 9 AM.",
      "time": "10:33",
      "isMe": false,
      "isRead": true,
    },
    {
      "text": "Hi!",
      "time": "10:30",
      "isMe": true,
      "isRead": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leadingWidth: 70,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.arrow_back),
              const SizedBox(width: 4),
              Avatar(text: widget.userName, radius: 18),
            ],
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Text(
              "online",
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              print("Selected: $value");
              if (value == 'clear') {
                setState(() {
                  _messages.clear();
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'mute',
                  child: Row(
                    children: [
                      Icon(Icons.volume_off, size: 20, color: Colors.grey),
                      SizedBox(width: 12),
                      Text('Mute')
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'clear',
                  child: Row(
                    children: [
                      Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                      SizedBox(width: 12),
                      Text('Clear History')
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete_forever, size: 20, color: Colors.red),
                      SizedBox(width: 12),
                      Text('Delete Chat', style: TextStyle(color: Colors.red))
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF98A6B3),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return MessageBubble(
                    message: msg['text'],
                    time: msg['time'],
                    isMe: msg['isMe'],
                    isRead: msg['isRead'],
                  );
                },
              ),
            ),
            ChatInputBar(
              onSend: () {
                setState(() {
                  _messages.insert(0, {
                    "text": "This is a new message!",
                    "time": "${DateTime.now().hour}:${DateTime.now().minute}",
                    "isMe": true,
                    "isRead": false,
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
