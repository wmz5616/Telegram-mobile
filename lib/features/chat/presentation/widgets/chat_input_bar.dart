import 'package:flutter/material.dart';
import '../../data/models/message.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEmojiPanelOpen;
  final VoidCallback onEmojiToggle;
  final ValueChanged<String> onSend;
  final VoidCallback? onAttachmentPressed;
  final VoidCallback? onVoiceRecord;
  final Message? replyMessage;
  final VoidCallback? onCancelReply;
  final Message? editingMessage;
  final VoidCallback? onCancelEdit;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isEmojiPanelOpen,
    required this.onEmojiToggle,
    required this.onSend,
    this.onAttachmentPressed,
    this.onVoiceRecord,
    this.replyMessage,
    this.onCancelReply,
    this.editingMessage,
    this.onCancelEdit,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with SingleTickerProviderStateMixin {
  bool _showSendButton = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _checkEditingMessage();
  }

  @override
  void didUpdateWidget(ChatInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editingMessage != oldWidget.editingMessage) {
      if (widget.editingMessage != null) {
        widget.controller.text = widget.editingMessage!.content;
        widget.controller.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.controller.text.length));
        setState(() => _showSendButton = true);
      } else {
        widget.controller.clear();
      }
    }
  }

  void _checkEditingMessage() {
    if (widget.editingMessage != null) {
      widget.controller.text = widget.editingMessage!.content;
    }
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (_showSendButton != hasText) {
      setState(() {
        _showSendButton = hasText;
      });
    }
  }

  void _handleSend() {
    final text = widget.controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      if (widget.editingMessage == null) {
        widget.controller.clear();
      }
    }
  }

  String _getPanelTitle() {
    if (widget.editingMessage != null) return "Edit Message";
    if (widget.replyMessage != null) {
      return widget.replyMessage!.isMe ? "Reply to You" : "Reply to User";
    }
    return "";
  }

  String _getPanelContent() {
    if (widget.editingMessage != null)
      return _getMessageSummary(widget.editingMessage!);
    if (widget.replyMessage != null)
      return _getMessageSummary(widget.replyMessage!);
    return "";
  }

  String _getMessageSummary(Message msg) {
    if (msg.type == MessageType.image) return "📷 Photo";
    if (msg.type == MessageType.audio) return "🎤 Voice Message";
    return msg.content;
  }

  IconData _getPanelIcon() {
    if (widget.editingMessage != null) return Icons.edit;
    return Icons.reply;
  }

  @override
  Widget build(BuildContext context) {
    final bool showPanel =
        widget.replyMessage != null || widget.editingMessage != null;
    final bool isEditing = widget.editingMessage != null;

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showPanel)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Icon(_getPanelIcon(),
                      color: const Color(0xFF517DA2), size: 24),
                  const SizedBox(width: 12),
                  Container(
                      width: 2, height: 34, color: const Color(0xFF517DA2)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getPanelTitle(),
                          style: const TextStyle(
                              color: Color(0xFF517DA2),
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _getPanelContent(),
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                    onPressed:
                        isEditing ? widget.onCancelEdit : widget.onCancelReply,
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 30, minHeight: 30),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: SafeArea(
              top: false,
              bottom: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!isEditing)
                    IconButton(
                      icon: Icon(
                          widget.isEmojiPanelOpen
                              ? Icons.keyboard
                              : Icons.emoji_emotions_outlined,
                          color: Colors.grey,
                          size: 28),
                      onPressed: widget.onEmojiToggle,
                      padding: EdgeInsets.zero,
                      constraints:
                          const BoxConstraints(minWidth: 44, minHeight: 48),
                      splashRadius: 24,
                    ),
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 120),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: "Message",
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 18),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 10, 0, 10),
                          suffixIcon: !isEditing
                              ? IconButton(
                                  icon: Transform.rotate(
                                    angle: -0.5,
                                    child: const Icon(Icons.attach_file,
                                        color: Colors.grey, size: 28),
                                  ),
                                  onPressed: widget.onAttachmentPressed,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                      minWidth: 40, minHeight: 40),
                                  splashRadius: 24,
                                )
                              : null,
                        ),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                        cursorColor: const Color(0xFF517DA2),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _showSendButton
                        ? _handleSend
                        : (widget.onVoiceRecord ?? () {}),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      curve: Curves.easeOut,
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFF517DA2),
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        transitionBuilder: (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                        child: Icon(
                          isEditing
                              ? Icons.check
                              : (_showSendButton ? Icons.send : Icons.mic),
                          key: ValueKey<String>(isEditing
                              ? "edit"
                              : (_showSendButton ? "send" : "mic")),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
