import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Stay safe on SoulSync',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Text(
            'Meet in public places, tell a friend about your plans, and report any suspicious behavior.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.5),
          ),
          SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: Icon(Icons.report_gmailerrorred_outlined,
                  color: AppColors.error),
              title: Text('Report a concern'),
              subtitle: Text('Let us know about unsafe behavior'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.tips_and_updates_outlined),
              title: Text('Safety tips'),
              subtitle: Text('Guidelines for meeting new people'),
            ),
          ),
        ],
      ),
    );
  }
}
