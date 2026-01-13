import 'package:flutter/material.dart';
import '../../data/models/message.dart';

class PinnedMessageBar extends StatelessWidget {
  final Message message;
  final VoidCallback onPressed;
  final VoidCallback onClose;

  const PinnedMessageBar({
    super.key,
    required this.message,
    required this.onPressed,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 1,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black12, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 2,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF517DA2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pinned Message",
                      style: TextStyle(
                        color: Color(0xFF517DA2),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      _getMessageSummary(message),
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                onPressed: onClose,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                padding: EdgeInsets.zero,
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMessageSummary(Message msg) {
    if (msg.type == MessageType.image) return "📷 Photo";
    if (msg.type == MessageType.audio) return "🎤 Voice Message";
    return msg.content;
  }
}
