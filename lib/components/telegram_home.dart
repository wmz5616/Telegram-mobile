import 'package:flutter/material.dart';

class ChatUser {
  final String id;
  final String name;
  final String message;
  final String avatarUrl;
  final Color color;

  ChatUser(this.id, this.name, this.message, this.avatarUrl, this.color);
}

final List<ChatUser> mockUsers = [
  ChatUser('1', 'Pavel Durov', 'See you in Dubai!', '', Colors.blueAccent),
  ChatUser(
      '2', 'Design Team', 'New animations are ready.', '', Colors.purpleAccent),
  ChatUser('3', 'Mom', 'Call me when you can.', '', Colors.pinkAccent),
  ChatUser('4', 'Saved Messages', 'File uploaded.', '', Colors.teal),
];

class TelegramHome extends StatelessWidget {
  const TelegramHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C242F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF232E3C),
        elevation: 0,
        title: const Text('Telegram',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: const Icon(Icons.menu),
        actions: const [Icon(Icons.search), SizedBox(width: 16)],
      ),
      body: ListView.builder(
        itemCount: mockUsers.length,
        itemBuilder: (context, index) {
          final user = mockUsers[index];
          return ChatListItem(user: user);
        },
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final ChatUser user;

  const ChatListItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            reverseTransitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: ChatScreen(user: user),
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Hero(
              tag: 'avatar_${user.id}',
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: user.color,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  user.name.substring(0, 1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Hero(
                        tag: 'name_${user.id}',
                        flightShuttleBuilder: (flightContext, animation,
                            direction, fromContext, toContext) {
                          return DefaultTextStyle(
                            style: DefaultTextStyle.of(toContext).style,
                            child: toContext.widget,
                          );
                        },
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        '12:30',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.message,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final ChatUser user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(user.id.isNotEmpty, 'User ID must not be empty');

    return Scaffold(
      backgroundColor: const Color(0xFF0F161E),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFF232E3C),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              Hero(
                tag: 'avatar_${user.id}',
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: user.color,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    user.name.substring(0, 1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'name_${user.id}',
                    child: Material(
                      color: Colors.transparent,
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'online',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const NetworkImage(
                      'https://web.telegram.org/img/bg_0.png'),
                  fit: BoxFit.cover,
                  opacity: 0.05,
                ),
              ),
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: const Color(0xFF232E3C),
      child: Row(
        children: [
          const Icon(Icons.attach_file, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF17212B),
                borderRadius: BorderRadius.circular(20),
              ),
              child:
                  const Text('Message', style: TextStyle(color: Colors.grey)),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.mic, color: Colors.grey),
        ],
      ),
    );
  }
}
