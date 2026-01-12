import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat.dart';
import '../models/message.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

class ChatRepository {
  // 暂时不连接 DatabaseService
  // final DatabaseService _dbService = DatabaseService();

  /// 1. 返回模拟的会话列表
  Stream<List<Chat>> getChatsStream() async* {
    // 模拟延迟，感觉像真的一样
    await Future.delayed(const Duration(milliseconds: 500));
    
    // 返回一些假数据
    yield [
      Chat()
        ..id = 1
        ..title = "Pavel Durov (Mock)"
        ..lastMessage = "Welcome to Telegram Web!"
        ..lastTime = DateTime.now()
        ..unreadCount = 2,
      Chat()
        ..id = 2
        ..title = "Saved Messages"
        ..lastMessage = "image.png"
        ..lastTime = DateTime.now().subtract(const Duration(hours: 2))
        ..unreadCount = 0,
    ];
  }

  /// 2. 返回模拟的消息流
  Stream<List<Message>> getMessagesStream(int chatId) async* {
    yield [
      Message()
        ..id = 1
        ..content = "Hi! This is running on Chrome without Database."
        ..timestamp = DateTime.now()
        ..isMe = false,
      Message()
        ..id = 2
        ..content = "Great! I can see the UI now."
        ..timestamp = DateTime.now().add(const Duration(seconds: 1))
        ..isMe = true,
    ];
  }

  /// 3. 模拟发送消息 (只会打印，不会保存)
  Future<void> sendMessage(int chatId, String text) async {
    print("【模拟发送】Chat: $chatId, Content: $text");
    // 真实项目中这里会写入数据库
  }

  /// 4. 空函数，Web 模式下不需要
  Future<void> seedInitialData() async {}
}