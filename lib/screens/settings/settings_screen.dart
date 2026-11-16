import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _showDistance = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
            title: const Text('Push notifications'),
            subtitle: const Text('Matches, messages, and updates'),
            activeThumbColor: AppColors.primary,
          ),
          SwitchListTile(
            value: _showDistance,
            onChanged: (v) => setState(() => _showDistance = v),
            title: const Text('Show distance'),
            subtitle: const Text('Display distance on your profile'),
            activeThumbColor: AppColors.primary,
          ),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App version'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
