import 'package:isar/isar.dart';

class Chat {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String? remoteId;
  late String title;

  String? avatarUrl;

  String? lastMessage;

  DateTime? lastTime;

  int unreadCount = 0;

  bool isPinned = false;

  bool isMuted = false;
}
