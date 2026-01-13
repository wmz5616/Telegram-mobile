import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/message.dart';
import 'audio_waveform.dart';
import '../photo_viewer_screen.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool nextMessageIsSameOwner;

  const MessageBubble({
    super.key,
    required this.message,
    this.nextMessageIsSameOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    if (message.type == MessageType.image) {
      return _buildImageBubble(context);
    } else if (message.type == MessageType.audio) {
      return _buildAudioBubble(context);
    }
    return _buildTextBubble(context);
  }

  Widget _buildImageBubble(BuildContext context) {
    final bool showTail = !nextMessageIsSameOwner;
    final String heroTag = 'img_${message.id}';

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: message.isMe ? 0 : 8,
          right: message.isMe ? 8 : 0,
        ),
        constraints: const BoxConstraints(maxWidth: 280, maxHeight: 350),
        child: ClipPath(
          clipper: _BubbleClipper(isMe: message.isMe, showTail: showTail),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhotoViewerScreen(
                        imageUrl: message.attachmentUrl ?? "",
                        heroTag: heroTag,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: heroTag,
                  child: Image.network(
                    message.attachmentUrl ?? "",
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                    errorBuilder: (ctx, err, stack) => Container(
                      height: 200,
                      width: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 6,
                right: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style:
                            const TextStyle(fontSize: 11, color: Colors.white),
                      ),
                      if (message.isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.status == MessageStatus.read
                              ? Icons.done_all
                              : Icons.done,
                          size: 16,
                          color: Colors.white,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioBubble(BuildContext context) {
    final bool showTail = !nextMessageIsSameOwner;
    final bgColor = message.isMe ? const Color(0xFFEEFFDE) : Colors.white;
    final timeColor = message.isMe ? const Color(0xFF559D69) : Colors.grey[500];

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: message.isMe ? 0 : 8,
          right: message.isMe ? 8 : 0,
        ),
        child: CustomPaint(
          painter: _BubblePainter(
            color: bgColor,
            isMe: message.isMe,
            showTail: showTail,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                message.isMe ? 10 : 16, 10, message.isMe ? 16 : 10, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: message.isMe
                        ? const Color(0xFF559D69)
                        : const Color(0xFF517DA2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    message.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AudioWaveform(
                        isMe: message.isMe,
                        duration:
                            message.duration ?? const Duration(seconds: 5)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatDuration(message.duration),
                          style: TextStyle(
                              fontSize: 12,
                              color: message.isMe
                                  ? const Color(0xFF559D69)
                                  : Colors.grey[600]),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(fontSize: 11, color: timeColor),
                        ),
                        if (message.isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            message.status == MessageStatus.read
                                ? Icons.done_all
                                : Icons.done,
                            size: 16,
                            color: const Color(0xFF559D69),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextBubble(BuildContext context) {
    final bgColor = message.isMe ? const Color(0xFFEEFFDE) : Colors.white;
    final textColor = Colors.black;
    final timeColor = message.isMe ? const Color(0xFF559D69) : Colors.grey[500];
    final bool showTail = !nextMessageIsSameOwner;

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
            top: 2,
            bottom: 2,
            left: message.isMe ? 0 : 8,
            right: message.isMe ? 8 : 0),
        child: CustomPaint(
          painter: _BubblePainter(
            color: bgColor,
            isMe: message.isMe,
            showTail: showTail,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                message.isMe ? 10 : 16, 6, message.isMe ? 16 : 10, 6),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Text(
                      message.content,
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(message.timestamp),
                          style: TextStyle(fontSize: 11, color: timeColor),
                        ),
                        if (message.isMe) ...[
                          const SizedBox(width: 4),
                          Icon(
                            message.status == MessageStatus.read
                                ? Icons.done_all
                                : Icons.done,
                            size: 16,
                            color: const Color(0xFF559D69),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) => DateFormat('HH:mm').format(time);

  String _formatDuration(Duration? d) {
    if (d == null) return "0:00";
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }
}

class _BubblePainter extends CustomPainter {
  final Color color;
  final bool isMe;
  final bool showTail;

  _BubblePainter(
      {required this.color, required this.isMe, required this.showTail});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = _getBubblePath(size, isMe, showTail);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BubblePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.showTail != showTail;
}

class _BubbleClipper extends CustomClipper<Path> {
  final bool isMe;
  final bool showTail;

  _BubbleClipper({required this.isMe, required this.showTail});

  @override
  Path getClip(Size size) => _getBubblePath(size, isMe, showTail);

  @override
  bool shouldReclip(covariant _BubbleClipper oldClipper) => true;
}

Path _getBubblePath(Size size, bool isMe, bool showTail) {
  final path = Path();
  const double r = 10;
  if (isMe) {
    if (showTail) {
      path.moveTo(r, 0);
      path.lineTo(size.width - r - 6, 0);
      path.quadraticBezierTo(size.width - 6, 0, size.width - 6, r);
      path.lineTo(size.width - 6, size.height - 6);
      path.quadraticBezierTo(size.width, size.height, size.width, size.height);
      path.lineTo(size.width - 6, size.height);
      path.lineTo(r, size.height);
      path.quadraticBezierTo(0, size.height, 0, size.height - r);
      path.lineTo(0, r);
      path.quadraticBezierTo(0, 0, r, 0);
    } else {
      path.addRRect(RRect.fromLTRBAndCorners(0, 0, size.width - 6, size.height,
          topLeft: const Radius.circular(10),
          bottomLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
          bottomRight: const Radius.circular(5)));
    }
  } else {
    if (showTail) {
      path.moveTo(size.width - r, 0);
      path.lineTo(r + 6, 0);
      path.quadraticBezierTo(6, 0, 6, r);
      path.lineTo(6, size.height - 6);
      path.quadraticBezierTo(0, size.height, 0, size.height);
      path.lineTo(6, size.height);
      path.lineTo(size.width - r, size.height);
      path.quadraticBezierTo(
          size.width, size.height, size.width, size.height - r);
      path.lineTo(size.width, r);
      path.quadraticBezierTo(size.width, 0, size.width - r, 0);
    } else {
      path.addRRect(RRect.fromLTRBAndCorners(6, 0, size.width, size.height,
          topLeft: const Radius.circular(10),
          bottomLeft: const Radius.circular(5),
          topRight: const Radius.circular(10),
          bottomRight: const Radius.circular(10)));
    }
  }
  return path;
}
