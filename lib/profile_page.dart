import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/camp.jpeg'), // Or use NetworkImage
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            // Name
            const Text(
              'Merlin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Email
            const Text(
              'merlin@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Posts', '24'),
                      _buildStatColumn('Events', '5'),
                      _buildStatColumn('Followers', '120'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // About Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'About',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Passionate learner. Loves tech, coding competitions, and participating in campus events.',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Button
            ElevatedButton(
              onPressed: () {
                // Add functionality like "Edit Profile"
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text('Edit Profile', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String title, String count) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}
