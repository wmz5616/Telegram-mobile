import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../data/models/chat.dart';
import '../data/models/message.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/message_bubble.dart';
import 'widgets/date_chip.dart';
import 'widgets/attachment_menu.dart';
import 'widgets/pinned_message_bar.dart';
import 'widgets/emoji_sticker_panel.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];

  Message? _replyMessage;
  Message? _editingMessage;
  Message? _pinnedMessage;

  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEmojiPanelOpen = false;

  @override
  void initState() {
    super.initState();
    _loadMockMessages();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() => _isEmojiPanelOpen = false);
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _loadMockMessages() {
    final now = DateTime.now();
    _messages.addAll([
      Message(
          id: 1,
          content: "Check my profile for shared media!",
          isMe: true,
          timestamp: now.subtract(const Duration(minutes: 1)),
          status: MessageStatus.read),
      Message(
          id: 2,
          content: "Tap the header to see Chat Info.",
          isMe: false,
          timestamp: now.subtract(const Duration(minutes: 2)),
          status: MessageStatus.read),
    ]);
  }

  void _openChatInfo() {
    _focusNode.unfocus();
    setState(() => _isEmojiPanelOpen = false);

    context.push('/chat_info', extra: widget.chat);
  }

  void _toggleEmojiPanel() {
    if (_isEmojiPanelOpen) {
      _focusNode.requestFocus();
      setState(() => _isEmojiPanelOpen = false);
    } else {
      _focusNode.unfocus();
      setState(() => _isEmojiPanelOpen = true);
    }
  }

  void _handleSend(String text) {
    setState(() {
      if (_editingMessage != null) {
        final index = _messages.indexWhere((m) => m.id == _editingMessage!.id);
        if (index != -1) {
          _messages[index].content = text;
          _messages[index].isEdited = true;
          if (_pinnedMessage?.id == _editingMessage!.id)
            _pinnedMessage = _messages[index];
        }
        _editingMessage = null;
      } else {
        final newMessage = Message(
            id: DateTime.now().millisecondsSinceEpoch,
            content: text,
            isMe: true,
            timestamp: DateTime.now(),
            status: MessageStatus.pending,
            type: MessageType.text);
        _messages.insert(0, newMessage);
        _replyMessage = null;
      }
    });
  }

  void _onEmojiSelected(String emoji) {
    final text = _textController.text;
    final selection = _textController.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final newText = text.replaceRange(start, end, emoji);
    _textController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: start + emoji.length));
  }

  void _onBackspace() {
    final text = _textController.text;
    final selection = _textController.selection;
    final cursorPosition =
        selection.isValid ? selection.baseOffset : text.length;
    if (cursorPosition > 0) {
      final newText = text.substring(0, cursorPosition - 1) +
          text.substring(cursorPosition);
      _textController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: cursorPosition - 1));
    }
  }

  void _onStickerSelected(String url) {
    setState(() {
      final newMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch,
          content: "",
          attachmentUrl: url,
          type: MessageType.image,
          isMe: true,
          timestamp: DateTime.now(),
          status: MessageStatus.pending);
      _messages.insert(0, newMessage);
    });
  }

  void _setReplyMessage(Message message) {
    setState(() {
      _replyMessage = message;
      _editingMessage = null;
    });
  }

  void _setEditingMessage(Message message) {
    setState(() {
      _editingMessage = message;
      _replyMessage = null;
    });
  }

  void _pinMessage(Message message) {
    setState(() => _pinnedMessage = message);
  }

  void _unpinMessage() {
    setState(() => _pinnedMessage = null);
  }

  void _cancelInputState() {
    setState(() {
      _replyMessage = null;
      _editingMessage = null;
    });
  }

  void _deleteMessage(Message message) {
    setState(() {
      _messages.removeWhere((m) => m.id == message.id);
      if (_pinnedMessage?.id == message.id) _pinnedMessage = null;
    });
  }

  void _handleSendImage() {}
  void _handleVoiceRecord() {}
  void _handleAttachmentPressed() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => AttachmentMenu(onPickImage: _handleSendImage));
  }

  bool _isSameDay(DateTime date1, DateTime date2) =>
      date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    if (_isSameDay(date, now)) return "Today";
    if (_isSameDay(date, now.subtract(const Duration(days: 1))))
      return "Yesterday";
    return DateFormat('MMMM d').format(date);
  }

  void _showMessageOptions(BuildContext context, Message message) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (context) {
          return SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2))),
            _buildOptionItem(Icons.reply, "Reply", () {
              Navigator.pop(context);
              _setReplyMessage(message);
            }),
            if (message.isMe && message.type == MessageType.text)
              _buildOptionItem(Icons.edit, "Edit", () {
                Navigator.pop(context);
                _setEditingMessage(message);
              }),
            if (message.type == MessageType.text)
              _buildOptionItem(Icons.copy, "Copy", () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: message.content));
              }),
            _buildOptionItem(Icons.push_pin_outlined, "Pin", () {
              Navigator.pop(context);
              _pinMessage(message);
            }),
            _buildOptionItem(Icons.delete_outline, "Delete", () {
              Navigator.pop(context);
              _deleteMessage(message);
            }, isDestructive: true),
            const SizedBox(height: 8),
          ]));
        });
  }

  Widget _buildOptionItem(IconData icon, String label, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
        leading:
            Icon(icon, color: isDestructive ? Colors.red : Colors.grey[700]),
        title: Text(label,
            style: TextStyle(
                color: isDestructive ? Colors.red : Colors.black,
                fontSize: 16)),
        onTap: onTap);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isEmojiPanelOpen,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (_isEmojiPanelOpen) setState(() => _isEmojiPanelOpen = false);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF96B3C8),
        appBar: AppBar(
          backgroundColor: const Color(0xFF517DA2),
          elevation: 1,
          titleSpacing: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
          title: GestureDetector(
            onTap: _openChatInfo,
            child: Row(
              children: [
                Hero(
                    tag: 'avatar_${widget.chat.id}',
                    child: CircleAvatar(
                        radius: 18,
                        backgroundColor: widget.chat.avatarColor,
                        child: Text(
                            widget.chat.title.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)))),
                const SizedBox(width: 10),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(widget.chat.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis),
                      const Text("online",
                          style: TextStyle(color: Colors.white70, fontSize: 12))
                    ])),
              ],
            ),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {})
          ],
        ),
        body: Column(
          children: [
            if (_pinnedMessage != null)
              PinnedMessageBar(
                  message: _pinnedMessage!,
                  onPressed: () {},
                  onClose: _unpinMessage),
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  bool nextMessageIsSameOwner = false;
                  if (index > 0 && _messages[index - 1].isMe == message.isMe)
                    nextMessageIsSameOwner = true;
                  bool showDateHeader = false;
                  if (index == _messages.length - 1)
                    showDateHeader = true;
                  else if (!_isSameDay(
                      message.timestamp, _messages[index + 1].timestamp))
                    showDateHeader = true;

                  return Column(
                    children: [
                      if (showDateHeader)
                        DateChip(date: _formatDateHeader(message.timestamp)),
                      Dismissible(
                        key: ValueKey(message.id),
                        direction: DismissDirection.startToEnd,
                        background: Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Icon(Icons.reply,
                                color: Colors.white, size: 30)),
                        confirmDismiss: (d) async {
                          _setReplyMessage(message);
                          return false;
                        },
                        child: GestureDetector(
                          onLongPress: () =>
                              _showMessageOptions(context, message),
                          child: Column(
                            crossAxisAlignment: message.isMe
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              MessageBubble(
                                  message: message,
                                  nextMessageIsSameOwner:
                                      nextMessageIsSameOwner),
                              if (message.isEdited)
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 4, bottom: 2),
                                    child: const Text("edited",
                                        style: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 10,
                                            fontStyle: FontStyle.italic)))
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ChatInputBar(
              controller: _textController,
              focusNode: _focusNode,
              isEmojiPanelOpen: _isEmojiPanelOpen,
              onEmojiToggle: _toggleEmojiPanel,
              onSend: _handleSend,
              onAttachmentPressed: _handleAttachmentPressed,
              onVoiceRecord: _handleVoiceRecord,
              replyMessage: _replyMessage,
              onCancelReply: _cancelInputState,
              editingMessage: _editingMessage,
              onCancelEdit: _cancelInputState,
            ),
            if (_isEmojiPanelOpen)
              EmojiStickerPanel(
                  onEmojiSelected: _onEmojiSelected,
                  onBackspacePressed: _onBackspace,
                  onStickerSelected: _onStickerSelected),
            if (_isEmojiPanelOpen)
              SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
