import 'package:flutter/material.dart';

class AttachmentMenu extends StatelessWidget {
  final VoidCallback onPickImage;

  const AttachmentMenu({super.key, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: const BoxDecoration(
        color: Color(0xFF1C242F),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 10,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onPickImage();
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: NetworkImage("https://picsum.photos/200"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 16,
              children: [
                _buildMenuItem(Icons.photo, "Gallery", Colors.blue, context),
                _buildMenuItem(
                    Icons.insert_drive_file, "File", Colors.orange, context),
                _buildMenuItem(
                    Icons.location_on, "Location", Colors.green, context),
                _buildMenuItem(
                    Icons.poll, "Poll", Colors.yellow[700]!, context),
                _buildMenuItem(Icons.music_note, "Music", Colors.red, context),
                _buildMenuItem(
                    Icons.person, "Contact", Colors.blueAccent, context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      IconData icon, String label, Color color, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label == "Gallery") {
          Navigator.pop(context);
          onPickImage();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
