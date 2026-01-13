import 'package:flutter/material.dart';

class EmojiStickerPanel extends StatefulWidget {
  final ValueChanged<String> onEmojiSelected;
  final VoidCallback onBackspacePressed;
  final ValueChanged<String> onStickerSelected;

  const EmojiStickerPanel({
    super.key,
    required this.onEmojiSelected,
    required this.onBackspacePressed,
    required this.onStickerSelected,
  });

  @override
  State<EmojiStickerPanel> createState() => _EmojiStickerPanelState();
}

class _EmojiStickerPanelState extends State<EmojiStickerPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _emojis = [
    "😀",
    "😃",
    "😄",
    "😁",
    "😆",
    "😅",
    "😂",
    "🤣",
    "☺️",
    "😊",
    "😇",
    "🙂",
    "🙃",
    "😉",
    "😌",
    "😍",
    "🥰",
    "😘",
    "😗",
    "😙",
    "😚",
    "😋",
    "😛",
    "😝",
    "😜",
    "🤪",
    "🤨",
    "🧐",
    "🤓",
    "😎",
    "🤩",
    "🥳",
    "😏",
    "😒",
    "😞",
    "😔",
    "worried",
    "😕",
    "🙁",
    "☹️",
    "😣",
    "😖",
    "😫",
    "😩",
    "🥺",
    "😢",
    "😭",
    "😤",
    "😠",
    "😡",
    "🤬",
    "🤯",
    "😳",
    "🥵",
    "🥶",
    "😱",
    "😨",
    "😰",
    "😥",
    "😓",
    "🤗",
    "🤔",
    "🤭",
    "🤫",
    "🤥",
    "😶",
    "😐",
    "😑",
    "😬",
    "🙄",
    "😯",
    "😦",
    "😧",
    "😮",
    "😲",
    "🥱",
    "sleeping",
    "🤤",
    "😪",
    "😵",
    "🤐",
    "🥴",
    "🤢",
    "🤮",
    "sneezing",
    "😷",
    "feaver",
    "🤕",
    "🤑",
    "🤠",
    "😈",
    "👿",
    "wnk",
    "💩",
    "👻",
    "💀",
    "☠️",
    "👽",
    "👾",
    "🤖",
    "👍",
    "👎",
    "👊",
    "✊",
    "🤛",
    "🤜",
    "🤞",
    "✌️",
    "🤟",
    "🤘",
    "👌",
    "🤏",
    "👈",
    "👉",
    "👆",
    "👇",
    "☝️",
    "✋",
    "🤚",
    "🖐",
  ];

  final List<String> _stickers = List.generate(
      20, (index) => "https://picsum.photos/seed/sticker$index/200/200");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: const Color(0xFFF0F2F5),
      child: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmojiGrid(),
                _buildStickerGrid(),
                const Center(
                    child: Text("GIFs coming soon",
                        style: TextStyle(color: Colors.grey))),
              ],
            ),
          ),
          Container(
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              border:
                  Border(top: BorderSide(color: Colors.black12, width: 0.5)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF517DA2),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFF517DA2),
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: const [
                      Tab(icon: Icon(Icons.emoji_emotions_outlined, size: 24)),
                      Tab(icon: Icon(Icons.sticky_note_2_outlined, size: 24)),
                      Tab(icon: Icon(Icons.gif, size: 24)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: widget.onBackspacePressed,
                  onLongPress: widget.onBackspacePressed,
                  child: Container(
                    width: 50,
                    height: double.infinity,
                    color: Colors.transparent,
                    child: const Icon(Icons.backspace_outlined,
                        color: Colors.grey, size: 20),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: _emojis.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => widget.onEmojiSelected(_emojis[index]),
          child: Center(
            child: Text(
              _emojis[index],
              style: const TextStyle(fontSize: 24),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStickerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _stickers.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => widget.onStickerSelected(_stickers[index]),
          child: Image.network(_stickers[index]),
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
