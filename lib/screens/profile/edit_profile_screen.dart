import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _bio;
  late final TextEditingController _location;
  late final TextEditingController _age;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _name = TextEditingController(text: user?.name ?? 'Alex');
    _bio = TextEditingController(text: user?.bio ?? '');
    _location = TextEditingController(text: user?.location ?? 'Dhaka');
    _age = TextEditingController(text: (user?.age ?? 25).toString());
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    _location.dispose();
    _age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          CustomTextField(label: 'Name', controller: _name),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Age',
            controller: _age,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomTextField(label: 'Location', controller: _location),
          const SizedBox(height: 16),
          TextField(
            controller: _bio,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Bio',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          CustomButton(
            label: 'Save changes',
            onPressed: () {
              context.read<AuthProvider>().updateProfile(
                name: _name.text.trim(),
                bio: _bio.text.trim(),
                location: _location.text.trim(),
                age: int.tryParse(_age.text.trim()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully.')),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
