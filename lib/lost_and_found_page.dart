import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'lost_and_found_manager.dart';  // Import the manager class
import 'post_detail_page.dart';  // Make sure this is the correct path

class LostAndFoundPage extends StatefulWidget {
  const LostAndFoundPage({super.key});

  @override
  State<LostAndFoundPage> createState() => _LostAndFoundPageState();
}

class _LostAndFoundPageState extends State<LostAndFoundPage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    // Fetch posts from the manager
    final lostAndFoundPosts = LostAndFoundManager().getPosts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost & Found'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showAddLostFoundDialog,
              child: const Text('Add Lost or Found Item'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: lostAndFoundPosts.length,
              itemBuilder: (context, index) {
                final post = lostAndFoundPosts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: post['image'] != null
                        ? Image.file(post['image'], width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.search),
                    title: Text(post['title'] ?? ''),
                    subtitle: Text(post['description'] ?? ''),
                    trailing: post['isFound'] == true
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () {
                      // Navigate to the post details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailPage(post: post),
                        ),
                      ).then((_) {
                        setState(() {});  // Refresh the page after returning from PostDetailPage
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddLostFoundDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Lost or Found Item'),
          content: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImageFromCamera,
                child: const Text('Capture Image'),
              ),
              if (_image != null) ...[
                const SizedBox(height: 16),
                Image.file(_image!),
              ]
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final title = titleController.text;
                final description = descriptionController.text;

                if (title.isNotEmpty && description.isNotEmpty) {
                  // Add post to the global manager
                  LostAndFoundManager().addPost({
                    'title': title,
                    'description': description,
                    'image': _image,
                    'isFound': false,  // Initially, the post is not found
                  });

                  // Refresh the page after adding post
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}
