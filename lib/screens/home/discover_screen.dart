import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/chat_provider.dart';
import '../../providers/profile_provider.dart';
import 'widgets/action_buttons.dart';
import 'widgets/filter_button.dart';
import 'widgets/profile_card.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final profile = provider.currentProfile;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Discover',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  tooltip: 'Add person',
                  onPressed: () => _showAddPersonDialog(context),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  icon: const Icon(
                    Icons.person_add_alt_1,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                FilterButton(onPressed: () {}),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: profile == null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.explore_off, size: 56),
                          const SizedBox(height: 12),
                          const Text('No more profiles right now'),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              TextButton(
                                onPressed: provider.reset,
                                child: const Text('Reset'),
                              ),
                              FilledButton.tonal(
                                onPressed: () => _showAddPersonDialog(context),
                                child: const Text('Add people'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : ProfileCard(profile: profile),
            ),
            const SizedBox(height: 16),
            if (profile != null)
              ActionButtons(
                onPass: provider.pass,
                onLike: () {
                  final liked = context.read<ProfileProvider>().like();
                  if (liked != null) {
                    context.read<ChatProvider>().ensureConversationForProfile(
                      liked,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'You liked ${liked.name}. Chat is ready!',
                        ),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showAddPersonDialog(BuildContext context) {
    final name = TextEditingController();
    final age = TextEditingController(text: '24');
    final location = TextEditingController(text: 'Dhaka');
    final bio = TextEditingController();
    final interests = TextEditingController(text: 'Music, Travel');
    final image = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Add a person',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        final count = context
                            .read<ProfileProvider>()
                            .addSamplePeople(5);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$count sample people added')),
                        );
                      },
                      child: const Text('Quick add 5'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: name,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Name *',
                    hintText: 'Enter name',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: age,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: location,
                  decoration: const InputDecoration(labelText: 'Location'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: bio,
                  decoration: const InputDecoration(labelText: 'Bio'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: interests,
                  decoration: const InputDecoration(
                    labelText: 'Interests (comma separated)',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: image,
                  decoration: const InputDecoration(
                    labelText: 'Image URL (optional)',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final n = name.text.trim();
                      if (n.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a name')),
                        );
                        return;
                      }
                      final a = int.tryParse(age.text.trim()) ?? 24;
                      final interestList = interests.text
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty)
                          .toList();
                      context.read<ProfileProvider>().addProfile(
                        name: n,
                        age: a,
                        location: location.text.trim().isEmpty
                            ? 'Dhaka'
                            : location.text.trim(),
                        bio: bio.text.trim().isEmpty
                            ? 'New on SoulSync'
                            : bio.text.trim(),
                        interests: interestList.isEmpty
                            ? ['Chat']
                            : interestList,
                        imageUrl: image.text.trim().isEmpty
                            ? null
                            : image.text.trim(),
                      );
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$n saved to Discover'),
                        ),
                      );
                    },
                    child: const Text('Add person'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
