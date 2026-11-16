import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Your privacy matters',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Control who can see your profile and how your data is used. '
            'This is a demo privacy screen — connect it to your backend and policies in production.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: Icon(Icons.visibility_outlined),
              title: Text('Profile visibility'),
              subtitle: Text('Visible to people near you'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.block_outlined),
              title: Text('Blocked accounts'),
              subtitle: Text('Manage people you have blocked'),
            ),
          ),
        ],
      ),
    );
  }
}
