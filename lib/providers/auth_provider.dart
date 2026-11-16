import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/storage_keys.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _restoreSession();
  }

  UserModel? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  final Completer<void> _restoreCompleter = Completer<void>();

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  /// Completes once the saved session has been read from local storage.
  Future<void> get ready => _restoreCompleter.future;

  Future<void> _restoreSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(StorageKeys.user);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          _user = UserModel.fromJson(Map<String, dynamic>.from(decoded));
        }
      }
    } catch (_) {
      // A corrupted session should never block the app from starting.
    } finally {
      _isInitialized = true;
      if (!_restoreCompleter.isCompleted) {
        _restoreCompleter.complete();
      }
      notifyListeners();
    }
  }

  Future<void> _saveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_user == null) {
        await prefs.remove(StorageKeys.user);
      } else {
        await prefs.setString(StorageKeys.user, jsonEncode(_user!.toJson()));
      }
    } catch (_) {
      // Persistence is best-effort; the in-memory session still works.
    }
  }

  bool get isInitialized => _isInitialized;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _user = UserModel(
      id: 'u1',
      name: 'Alex',
      email: email,
      bio: 'Coffee, music, and long walks.',
      age: 25,
      location: 'Dhaka',
    );
    await _saveSession();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signup(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _user = UserModel(
      id: 'u1',
      name: name,
      email: email,
      bio: '',
      location: 'Dhaka',
    );
    await _saveSession();
    _isLoading = false;
    notifyListeners();
  }

  void updateProfile({
    String? name,
    String? bio,
    String? location,
    int? age,
    String? avatarUrl,
  }) {
    if (_user == null) {
      _user = UserModel(
        id: 'u1',
        name: name ?? 'Guest',
        email: 'guest@soulsync.app',
        bio: bio,
        location: location,
        age: age,
        avatarUrl: avatarUrl,
      );
    } else {
      _user = _user!.copyWith(
        name: name,
        bio: bio,
        location: location,
        age: age,
        avatarUrl: avatarUrl,
      );
    }
    _saveSession();
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    await _saveSession();
    notifyListeners();
  }
}
