import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soulsync/app/app.dart';

void main() {
  testWidgets('splash shows the SoulSync branding', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const SoulSyncApp());

    expect(find.text('SoulSync'), findsOneWidget);
    expect(find.text('Find meaningful connections'), findsOneWidget);

    // Let the splash timer finish so no timers remain pending at teardown.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(milliseconds: 800));
  });
}
