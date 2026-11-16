import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulsync/core/constants/storage_keys.dart';
import 'package:soulsync/providers/auth_provider.dart';
import 'package:soulsync/providers/profile_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('a signed up user is restored on the next launch', () async {
    final firstLaunch = AuthProvider();
    await firstLaunch.ready;
    await firstLaunch.signup('Rumi', 'rumi@example.com', 'secret1');

    expect(firstLaunch.isAuthenticated, isTrue);

    final secondLaunch = AuthProvider();
    await secondLaunch.ready;

    expect(secondLaunch.isAuthenticated, isTrue);
    expect(secondLaunch.user?.name, 'Rumi');
    expect(secondLaunch.user?.email, 'rumi@example.com');
  });

  test('people added to Discover are saved for the next launch', () async {
    final firstLaunch = ProfileProvider();
    await firstLaunch.ready;

    firstLaunch.addProfile(
      name: 'Persisted Person',
      age: 29,
      location: 'Sylhet',
      bio: 'Saved locally',
      interests: const ['Music'],
      imageUrl: 'https://example.com/person.jpg',
    );

    // addProfile persists in the background, so wait for the write to land.
    final prefs = await SharedPreferences.getInstance();
    for (var i = 0; i < 25; i++) {
      if (prefs.getString(StorageKeys.customProfiles) != null) break;
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }

    final secondLaunch = ProfileProvider();
    await secondLaunch.ready;

    final restored = secondLaunch.discoverProfiles.where(
      (profile) => profile.name == 'Persisted Person',
    );
    expect(restored, hasLength(1));
    expect(secondLaunch.savedProfiles, hasLength(1));
  });
}
