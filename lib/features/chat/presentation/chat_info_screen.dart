import 'package:flutter/material.dart';
import '../data/models/chat.dart';

class ChatInfoScreen extends StatefulWidget {
  final Chat chat;

  const ChatInfoScreen({super.key, required this.chat});

  @override
  State<ChatInfoScreen> createState() => _ChatInfoScreenState();
}

class _ChatInfoScreenState extends State<ChatInfoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ["Media", "Files", "Voice", "Links", "Groups"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 380,
              pinned: true,
              backgroundColor: const Color(0xFF517DA2),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                    icon: const Icon(Icons.call, color: Colors.white),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {}),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: widget.chat.avatarColor,
                      child: Center(
                        child: Text(
                          widget.chat.title.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 120,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.6),
                              Colors.transparent
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.chat.title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Last seen recently",
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildInfoTile(Icons.info_outline,
                      "Mobile developer aiming for pixel perfection", "Bio"),
                  const Divider(height: 1, indent: 70),
                  _buildInfoTile(
                      Icons.alternate_email,
                      "@${widget.chat.title.replaceAll(' ', '').toLowerCase()}",
                      "Username"),
                  const Divider(height: 1, indent: 70),
                  _buildSwitchTile(
                      Icons.notifications_none, "Notifications", "On"),
                  Container(height: 12, color: const Color(0xFFF0F2F5)),
                ],
              ),
            ),
            SliverPersistentHeader(
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: const Color(0xFF517DA2),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFF517DA2),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: _tabs.map((t) => Tab(text: t)).toList(),
                ),
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildMediaGrid(),
            _buildFilesList(),
            const Center(child: Text("No Voice Messages")),
            const Center(child: Text("No Shared Links")),
            const Center(child: Text("No Groups in Common")),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      subtitle: Text(subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 13)),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      trailing: Switch(
        value: true,
        onChanged: (v) {},
        activeTrackColor: const Color(0xFF517DA2),
        activeColor: Colors.white,
      ),
    );
  }

  Widget _buildMediaGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return Image.network(
          "https://picsum.photos/seed/media$index/200/200",
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget _buildFilesList() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: 5,
      separatorBuilder: (c, i) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        return ListTile(
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(8)),
            child: const Center(
                child: Icon(Icons.insert_drive_file, color: Colors.white)),
          ),
          title: Text("Document_${index + 1}.pdf",
              style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: const Text("1.2 MB • 20 Jan at 10:30"),
        );
      },
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) => false;
}
