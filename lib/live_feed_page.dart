import 'dart:async';
import 'package:flutter/material.dart';
import 'indoor_map_page.dart'; // Import IndoorMapPage here!
import 'profile_page.dart';
import 'lost_and_found_page.dart'; // Import Lost & Found Page here!

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

  int _selectedIndex = 0;
  Timer? _timer;
  Duration? _timeLeft;
  String _nextClassSubject = '';
  TimeOfDay? _nextClassTime;
  bool _showAllClasses = false;

  final List<Map<String, dynamic>> timetable = [
    {'subject': 'Physics', 'time': TimeOfDay(hour: 9, minute: 30), 'room': '101'},
    {'subject': 'Mathematics', 'time': TimeOfDay(hour: 11, minute: 0), 'room': '203'},
    {'subject': 'Computer Science', 'time': TimeOfDay(hour: 14, minute: 0), 'room': 'Lab A'},
    {'subject': 'Chemistry', 'time': TimeOfDay(hour: 16, minute: 0), 'room': 'B1'},
  ];

  @override
  void initState() {
    super.initState();
    _findNextClass(); // Initialize the next class
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTimeLeft); // Update time every second
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTimeLeft(Timer timer) {
    if (_nextClassTime == null) return;

    final now = DateTime.now();
    final nextClassDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _nextClassTime!.hour,
      _nextClassTime!.minute,
    );

    final diff = nextClassDateTime.difference(now);

    if (diff.isNegative) {
      _findNextClass();
    } else {
      setState(() {
        _timeLeft = diff;
      });
    }
  }

  // Define the method _findNextClass
  void _findNextClass() {
    final now = TimeOfDay.now();

    timetable.sort((a, b) =>
        (a['time'] as TimeOfDay).hour.compareTo((b['time'] as TimeOfDay).hour));

    for (var entry in timetable) {
      final classTime = entry['time'] as TimeOfDay;
      if (classTime.hour > now.hour ||
          (classTime.hour == now.hour && classTime.minute > now.minute)) {
        setState(() {
          _nextClassSubject = entry['subject'];
          _nextClassTime = classTime;
          _updateTimeLeft(Timer(Duration(seconds: 1), () {})); // Calling updateTimeLeft with Timer to recalculate time
        });
        return;
      }
    }

    setState(() {
      _nextClassSubject = '';
      _nextClassTime = null;
      _timeLeft = null;
    });
  }

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
                    return DropdownMenuItem<String>(value: category, child: Text(category));
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
      return Column(
        children: [
          _buildNextClassCard(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
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
            ),
          ),
        ],
      );
    } else if (_selectedIndex == 1) {
      return const LostAndFoundPage(); // Navigate to Lost and Found page
    } else if (_selectedIndex == 2) {
      return const IndoorMapPage(); // Navigate to Indoor Map page
    } else {
      return const ProfilePage(); // Navigate to Profile page
    }
  }

  Widget _buildNextClassCard() {
    if (_nextClassTime == null) {
      return Card(
        color: Colors.redAccent,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(Icons.sentiment_satisfied, size: 40, color: Colors.white),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'No more classes today!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    String countdown = _timeLeft != null
        ? "${_timeLeft!.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_timeLeft!.inSeconds.remainder(60)).toString().padLeft(2, '0')}"
        : "--:--";

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showAllClasses = !_showAllClasses;
            });
          },
          child: Card(
            color: Colors.lightBlueAccent,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.access_time, size: 40, color: Colors.white),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next Class: $_nextClassSubject',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Starts in $countdown minutes',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _showAllClasses ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_showAllClasses)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: timetable
                  .where((entry) {
                final classTime = entry['time'] as TimeOfDay;
                final now = TimeOfDay.now();
                return classTime.hour > now.hour ||
                    (classTime.hour == now.hour && classTime.minute > now.minute);
              })
                  .map((entry) {
                final time = entry['time'] as TimeOfDay;
                return ListTile(
                  leading: const Icon(Icons.class_),
                  title: Text('${entry['subject']} - Room ${entry['room']}'),
                  subtitle: Text(time.format(context)),
                );
              })
                  .toList(),
            ),
          ),
      ],
    );
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
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
            icon: const Icon(Icons.notifications),
          )
        ],
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
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Lost & Found'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Campus Map'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
