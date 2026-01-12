import 'package:isar/isar.dart';

class Message {
  Id id = Isar.autoIncrement;

  @Index()
  late int chatId;
  late int senderId;
  late String content;

  @Enumerated(EnumType.ordinal)
  late MessageType type;
  late DateTime timestamp;

  @Enumerated(EnumType.ordinal)
  late MessageStatus status;
  late bool isMe;
}

enum MessageType {
  text,
  image,
  voice,
  file,
}

enum MessageStatus {
  pending,
  sent,
  delivered,
  read,
  failed,
}
