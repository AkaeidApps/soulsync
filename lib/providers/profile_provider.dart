import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/storage_keys.dart';
import '../models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileProvider() {
    _discoverProfiles.addAll(_seedProfiles);
    _restoreCustomProfiles();
  }

  static const _seedProfiles = <ProfileModel>[
    ProfileModel(
      id: 'p1',
      name: 'Maya',
      age: 24,
      location: 'Dhaka',
      bio: 'Love art, travel, and good conversations.',
      interests: ['Art', 'Travel', 'Coffee'],
      imageUrl:
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=800',
      distanceKm: 2.5,
    ),
    ProfileModel(
      id: 'p2',
      name: 'Rafi',
      age: 27,
      location: 'Dhaka',
      bio: 'Foodie, photographer, and weekend hiker.',
      interests: ['Photography', 'Food', 'Hiking'],
      imageUrl:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=800',
      distanceKm: 4.1,
    ),
    ProfileModel(
      id: 'p3',
      name: 'Nila',
      age: 23,
      location: 'Dhaka',
      bio: 'Bookworm who also loves sunsets and playlists.',
      interests: ['Books', 'Music', 'Movies'],
      imageUrl:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=800',
      distanceKm: 1.8,
    ),
    ProfileModel(
      id: 'p4',
      name: 'Sami',
      age: 26,
      location: 'Chattogram',
      bio: 'Beach walks, startups, and football.',
      interests: ['Tech', 'Football', 'Travel'],
      imageUrl:
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800',
      distanceKm: 6.0,
    ),
    ProfileModel(
      id: 'p5',
      name: 'Tania',
      age: 25,
      location: 'Dhaka',
      bio: 'Dancer, foodie, always up for an adventure.',
      interests: ['Dance', 'Food', 'Adventure'],
      imageUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=800',
      distanceKm: 3.2,
    ),
  ];

  final List<ProfileModel> _discoverProfiles = [];
  final List<ProfileModel> _customProfiles = [];
  final List<ProfileModel> _liked = [];
  int _currentIndex = 0;
  int _nextId = 100;
  final Completer<void> _readyCompleter = Completer<void>();

  List<ProfileModel> get discoverProfiles =>
      List.unmodifiable(_discoverProfiles);
  List<ProfileModel> get likedProfiles => List.unmodifiable(_liked);
  ProfileModel? get currentProfile => _currentIndex < _discoverProfiles.length
      ? _discoverProfiles[_currentIndex]
      : null;

  /// Completes once people saved on this device have been restored.
  Future<void> get ready => _readyCompleter.future;

  List<ProfileModel> get savedProfiles => List.unmodifiable(_customProfiles);

  Future<void> _restoreCustomProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(StorageKeys.customProfiles);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          for (final item in decoded) {
            if (item is! Map) continue;
            final profile = ProfileModel.fromJson(
              Map<String, dynamic>.from(item),
            );
            if (profile.id.isEmpty) continue;
            final alreadyLoaded = _discoverProfiles.any(
              (p) => p.id == profile.id,
            );
            if (!alreadyLoaded) {
              _discoverProfiles.add(profile);
            }
            if (!_customProfiles.any((p) => p.id == profile.id)) {
              _customProfiles.add(profile);
            }
          }
        }
      }
    } catch (_) {
      // Ignore corrupted storage and keep the seeded profiles.
    } finally {
      if (!_readyCompleter.isCompleted) {
        _readyCompleter.complete();
      }
      notifyListeners();
    }
  }

  Future<void> _persistCustomProfiles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        StorageKeys.customProfiles,
        jsonEncode(_customProfiles.map((profile) => profile.toJson()).toList()),
      );
    } catch (_) {
      // Persistence is best-effort.
    }
  }

  /// Returns the liked profile if like was successful, else null.
  ProfileModel? like() => _advance(likeCurrent: true);
  void pass() => _advance(likeCurrent: false);

  ProfileModel? _advance({required bool likeCurrent}) {
    final current = currentProfile;
    if (current == null) return null;
    if (likeCurrent && !_liked.any((p) => p.id == current.id)) {
      _liked.add(current);
    }
    _currentIndex++;
    notifyListeners();
    return likeCurrent ? current : null;
  }

  void addProfile({
    required String name,
    required int age,
    required String location,
    required String bio,
    required List<String> interests,
    String? imageUrl,
  }) {
    final profile = ProfileModel(
      id: _newProfileId(),
      name: name,
      age: age,
      location: location,
      bio: bio,
      interests: interests,
      imageUrl: (imageUrl != null && imageUrl.trim().isNotEmpty)
          ? imageUrl.trim()
          : _defaultImages[_nextId % _defaultImages.length],
      distanceKm: (1 + (_nextId % 9)).toDouble(),
    );

    // Show newly added people right after the card currently on screen.
    final insertAt = (_currentIndex + 1).clamp(0, _discoverProfiles.length);
    _discoverProfiles.insert(insertAt, profile);
    _customProfiles.add(profile);
    notifyListeners();
    unawaited(_persistCustomProfiles());
  }

  String _newProfileId() {
    _nextId++;
    return 'c${DateTime.now().microsecondsSinceEpoch}_$_nextId';
  }

  int addSamplePeople([int count = 5]) {
    const names = [
      'Aisha',
      'Imran',
      'Sara',
      'Nabil',
      'Riya',
      'Tahmid',
      'Meher',
      'Fahim',
      'Zara',
      'Arif',
    ];
    const locations = ['Dhaka', 'Sylhet', 'Chattogram', 'Rajshahi', 'Khulna'];
    const bios = [
      'Love exploring new cafes and music.',
      'Always up for travel and good vibes.',
      'Into fitness, movies, and late-night talks.',
      'Reader, foodie, and weekend explorer.',
    ];
    const interestsPool = [
      ['Music', 'Travel'],
      ['Movies', 'Food'],
      ['Fitness', 'Coffee'],
      ['Art', 'Books'],
      ['Photography', 'Hiking'],
    ];
    final start = _nextId;
    for (var i = 0; i < count; i++) {
      final idx = start + i;
      addProfile(
        name: names[idx % names.length],
        age: 20 + (idx % 10),
        location: locations[idx % locations.length],
        bio: bios[idx % bios.length],
        interests: interestsPool[idx % interestsPool.length],
      );
    }
    return count;
  }

  static const _defaultImages = [
    'https://images.unsplash.com/photo-1527980965255-d3b416303d12?w=800',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800',
    'https://images.unsplash.com/photo-1524502397800-2eeaad7c3fe5?w=800',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=800',
    'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=800',
  ];

  void reset() {
    _currentIndex = 0;
    _liked.clear();
    notifyListeners();
  }
}
