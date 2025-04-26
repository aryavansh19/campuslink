import 'dart:io';
import 'package:flutter/material.dart';
import 'lost_and_found_manager.dart';

class PostDetailPage extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostDetailPage({super.key, required this.post});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late Map<String, dynamic> post;

  @override
  void initState() {
    super.initState();
    post = widget.post;  // Initialize the post
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post['image'] != null)
              Image.file(post['image'], width: 150, height: 150, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              post['title'] ?? '',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(post['description'] ?? ''),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Mark as found logic
                setState(() {
                  post['isFound'] = true; // Update post status
                });

                // Optionally update the global list in LostAndFoundManager
                final postIndex = LostAndFoundManager()
                    .lostAndFoundPosts
                    .indexOf(post); // Find index of this post
                if (postIndex != -1) {
                  LostAndFoundManager().lostAndFoundPosts[postIndex] = post;
                }

                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text(post['isFound'] ? 'Marked as Found' : 'Mark as Found'),
            ),
            if (post['isFound'] == true)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'This item is marked as found!',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
