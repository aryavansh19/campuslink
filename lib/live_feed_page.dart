import 'package:flutter/material.dart';

class LiveFeedPage extends StatelessWidget {
  const LiveFeedPage({super.key});

  // Dummy data for posts
  final List<Map<String, String>> dummyPosts = const [
    {
      'category': 'Lecture Update',
      'title': 'Math class moved to Room 203',
      'description': 'Prof. Sharma has shifted the lecture today.'
    },
    {
      'category': 'Queue Alert',
      'title': 'Long queue at Cafeteria 1',
      'description': 'Waiting time ~15 minutes. Avoid if possible.'
    },
    {
      'category': 'Lost & Found',
      'title': 'Lost Wallet',
      'description': 'Black leather wallet found near Library Block.'
    },
    {
      'category': 'Event Update',
      'title': 'Coding Competition Today!',
      'description': 'Starts at 2 PM in Auditorium. Register at desk.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Feed'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: dummyPosts.length,
        itemBuilder: (context, index) {
          final post = dummyPosts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: _buildCategoryIcon(post['category']),
              title: Text(post['title'] ?? ''),
              subtitle: Text(post['description'] ?? ''),
            ),
          );
        },
      ),
    );
  }

  // Helper method to pick an icon based on category
  Widget _buildCategoryIcon(String? category) {
    IconData icon;
    Color color;

    switch (category) {
      case 'Lecture Update':
        icon = Icons.school;
        color = Colors.blue;
        break;
      case 'Queue Alert':
        icon = Icons.fastfood;
        color = Colors.orange;
        break;
      case 'Lost & Found':
        icon = Icons.search;
        color = Colors.green;
        break;
      case 'Event Update':
        icon = Icons.event;
        color = Colors.purple;
        break;
      default:
        icon = Icons.info;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.2),
      child: Icon(icon, color: color),
    );
  }
}
