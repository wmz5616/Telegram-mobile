import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderPage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF517DA2),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text(
              "This is the $title page",
              style: TextStyle(color: Colors.grey[600], fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class NewGroupScreen extends StatelessWidget {
  const NewGroupScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderPage(title: "New Group", icon: Icons.group_outlined);
}

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderPage(title: "Contacts", icon: Icons.person_outline);
}

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const PlaceholderPage(title: "Calls", icon: Icons.call_outlined);
}

class PeopleNearbyScreen extends StatelessWidget {
  const PeopleNearbyScreen({super.key});
  @override
  Widget build(BuildContext context) => const PlaceholderPage(
      title: "People Nearby", icon: Icons.location_on_outlined);
}
