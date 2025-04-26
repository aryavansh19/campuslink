import 'package:flutter/material.dart';

class IndoorMapPage extends StatelessWidget {
  const IndoorMapPage({super.key});

  final List<Map<String, dynamic>> rooms = const [
    {
      'roomName': 'Room 101',
      'isOccupied': true,
      'teacher': 'Prof. Sharma',
      'subject': 'Mathematics',
      'left': 70.0,
      'top': 230.0,
    },
    {
      'roomName': 'Room 102',
      'isOccupied': false,
      'teacher': '',
      'subject': '',
      'left': 210.0,
      'top': 230.0,
    },
    {
      'roomName': 'Room 103',
      'isOccupied': true,
      'teacher': 'Dr. Verma',
      'subject': 'Physics',
      'left': 60.0,
      'top': 365.0,
    },
    {
      'roomName': 'Room 104',
      'isOccupied': false,
      'teacher': '',
      'subject': '',
      'left': 180.0,
      'top': 365.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Map - Room Status'),
        centerTitle: true,
      ),
      body: InteractiveViewer( // Allow zoom and pan
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/floorplan.png', // Make sure the filename matches
                fit: BoxFit.contain,    // No cropping
              ),
            ),
            ...rooms.map((room) {
              return Positioned(
                left: room['left'],
                top: room['top'],
                child: GestureDetector(
                  onTap: () {
                    _showRoomDetails(
                      context,
                      room['roomName'],
                      room['isOccupied'],
                      room['teacher'],
                      room['subject'],
                    );
                  },
                  child: _buildRoomMarker(
                    room['isOccupied'],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomMarker(bool isOccupied) {
    return Icon(
      Icons.location_on,
      color: isOccupied ? Colors.red : Colors.green,
      size: 30,
    );
  }

  void _showRoomDetails(BuildContext context, String roomName, bool isOccupied, String teacher, String subject) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(roomName),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isOccupied
                    ? 'Status: Occupied (Class going on)'
                    : 'Status: Free (Available)',
              ),
              const SizedBox(height: 10),
              if (isOccupied) ...[
                Text('Teacher: $teacher'),
                Text('Subject: $subject'),
              ]
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
