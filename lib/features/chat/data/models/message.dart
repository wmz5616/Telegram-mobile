enum MessageStatus {
  pending,
  sent,
  read,
}

enum MessageType {
  text,
  image,
  audio,
}

class Message {
  int id = 0;
  int chatId = 0;
  String content = '';
  String? attachmentUrl;
  Duration? duration;
  DateTime timestamp = DateTime.now();
  bool isMe = false;
  MessageStatus status = MessageStatus.pending;
  MessageType type = MessageType.text;
  bool isEdited = false;
  bool isPlaying = false;

  Message({
    this.id = 0,
    this.chatId = 0,
    this.content = '',
    this.attachmentUrl,
    this.duration,
    required this.timestamp,
    this.isMe = false,
    this.status = MessageStatus.pending,
    this.type = MessageType.text,
    this.isEdited = false,
    this.isPlaying = false,
  });
}
