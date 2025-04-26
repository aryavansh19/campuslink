import 'package:flutter/material.dart';
import 'indoor_map_page.dart'; // <--- Import IndoorMapPage here!
import 'profile_page.dart';

class LiveFeedPage extends StatefulWidget {
  const LiveFeedPage({super.key});

  @override
  State<LiveFeedPage> createState() => _LiveFeedPageState();
}

class _LiveFeedPageState extends State<LiveFeedPage> {
  List<Map<String, String>> posts = [
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

  int _selectedIndex = 0; // For Bottom Navigation Bar

  Future<void> _refreshPosts() async {
    await Future.delayed(const Duration(seconds: 1)); // Fake delay
    setState(() {
      posts.shuffle(); // Shuffle posts to simulate update
    });
  }

  void _addNewPost() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController titleController = TextEditingController();
        TextEditingController descriptionController = TextEditingController();
        String selectedCategory = 'Lecture Update';

        return AlertDialog(
          title: const Text('Add New Post'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: [
                    'Lecture Update',
                    'Queue Alert',
                    'Lost & Found',
                    'Event Update'
                  ].map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedCategory = value;
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    descriptionController.text.isNotEmpty) {
                  setState(() {
                    posts.insert(0, {
                      'category': selectedCategory,
                      'title': titleController.text,
                      'description': descriptionController.text,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPageContent() {
    if (_selectedIndex == 0) {
      return RefreshIndicator(
        onRefresh: _refreshPosts,
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: _buildCategoryIcon(post['category']),
                title: Text(post['title'] ?? ''),
                subtitle: Text(post['description'] ?? ''),
              ),
            );
          },
        ),
      );
    } else if (_selectedIndex == 1) {
      return const Center(child: Text('Lost & Found Page - Coming Soon'));
    } else if (_selectedIndex == 2) {
      return const IndoorMapPage(); // <--- Call IndoorMapPage here
    } else {
      return const ProfilePage();
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusLink'),
        centerTitle: true,
      ),
      body: _buildPageContent(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: _addNewPost,
        child: const Icon(Icons.add),
      )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Lost & Found',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Campus Map', // <-- New Tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
