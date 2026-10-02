import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:mariam/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('main flows render and navigate without exceptions', (
    tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('مهام اليوم'), findsOneWidget);

    final notificationButton = find.byIcon(Icons.notifications_none_rounded);
    expect(notificationButton, findsOneWidget);
    await tester.tap(notificationButton);
    await tester.pumpAndSettle();
    expect(find.text('الإشعارات'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('المهام').last);
    await tester.pumpAndSettle();
    expect(find.text('قائمة اليوم'), findsOneWidget);

    await tester.tap(find.text('عباداتي').last);
    await tester.pumpAndSettle();
    expect(find.text('عبادات اليوم'), findsOneWidget);
  });
}
