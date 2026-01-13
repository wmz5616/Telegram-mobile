import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/chat.dart';

class ChatSearchDelegate extends SearchDelegate<String> {
  final List<Chat> allChats = [
    Chat(
      id: 1,
      title: "Telegram Team",
      lastMessage: "Welcome to Telegram!",
      lastTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 1,
      avatarColor: Colors.blue,
    ),
    Chat(
      id: 2,
      title: "Saved Messages",
      lastMessage: "File_v1.pdf",
      lastTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      avatarColor: const Color(0xFF65A9E0),
    ),
    Chat(
      id: 3,
      title: "John Doe",
      lastMessage: "Hey, how are you?",
      lastTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 3,
      avatarColor: Colors.orange,
    ),
    Chat(
      id: 4,
      title: "Flutter Developers",
      lastMessage: "Does anyone know how to fix this?",
      lastTime: DateTime.now().subtract(const Duration(days: 3)),
      unreadCount: 0,
      avatarColor: Colors.green,
    ),
    Chat(
      id: 5,
      title: "Design Group",
      lastMessage: "Check out this new prototype",
      lastTime: DateTime.now().subtract(const Duration(days: 5)),
      unreadCount: 0,
      avatarColor: Colors.purple,
    ),
  ];

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFF517DA2),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.grey),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.grey),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final results = allChats.where((chat) {
      return chat.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.search_off, size: 48, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              "No results found for '$query'",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final chat = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: chat.avatarColor,
            child: Text(
              chat.title.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          title: RichText(
            text: TextSpan(
              children: _highlightOccurrences(chat.title, query),
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
          subtitle: const Text("Tap to open chat"),
          onTap: () {
            close(context, chat.title);
            context.push('/chat/${chat.id}', extra: chat);
          },
        );
      },
    );
  }

  List<TextSpan> _highlightOccurrences(String text, String query) {
    if (query.isEmpty) return [TextSpan(text: text)];

    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerQuery = query.toLowerCase();
    int start = 0;
    int indexOfHighlight = lowerText.indexOf(lowerQuery);

    while (indexOfHighlight != -1) {
      if (indexOfHighlight > start) {
        spans.add(TextSpan(text: text.substring(start, indexOfHighlight)));
      }
      spans.add(TextSpan(
        text: text.substring(indexOfHighlight, indexOfHighlight + query.length),
        style: const TextStyle(color: Color(0xFF517DA2)),
      ));
      start = indexOfHighlight + query.length;
      indexOfHighlight = lowerText.indexOf(lowerQuery, start);
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }
}
