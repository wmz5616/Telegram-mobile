import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/repositories/chat_repository.dart';
import '../data/models/chat.dart';
import 'widgets/chat_list_item.dart';
import 'widgets/side_menu.dart';
import 'widgets/chat_search_delegate.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatRepository _repository = ChatRepository();
  late Future<List<Chat>> _chatsFuture;

  @override
  void initState() {
    super.initState();
    _chatsFuture = _repository.getChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF517DA2),
        elevation: 0,
        title: const Text(
          "Telegram",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ChatSearchDelegate(),
              );
            },
          ),
        ],
      ),
      drawer: const SideMenu(),
      body: FutureBuilder<List<Chat>>(
        future: _chatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No chats yet"));
          }

          final chats = snapshot.data!;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return ChatListItem(chat: chats[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/contacts');
        },
        backgroundColor: const Color(0xFF65A9E0),
        shape: const CircleBorder(),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }
}
