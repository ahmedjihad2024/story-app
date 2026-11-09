import 'package:flutter/material.dart';

class ProfilePlaceholderScreen extends StatelessWidget {
  const ProfilePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.person_outline_rounded, size: 72, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            'Profile',
            style: TextStyle(fontSize: 20, color: Colors.black54),
          ),
          SizedBox(height: 4),
          Text(
            'Coming soon',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

