import 'dart:js';

import 'package:dictionary_definitions_app/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  pumpTest(WidgetTester tester) async {
    final navigatorKey = GlobalKey<NavigatorState>();
    await loadAppFonts();
    await TestWidgetsFlutterBinding.instance
        .setSurfaceSize(Device.iphone11.size);
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AppNotifications(
          navigatorKey: navigatorKey,
          child: Scaffold(
            body: Center(
              child: Builder(
                builder: (context) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          AppNotifications.of(context)
                              .success(message: 'Success');
                        },
                        child: const Text('Show Success'),
                      ),
                      TextButton(
                        onPressed: () {
                          AppNotifications.of(context).error(message: 'Error');
                        },
                        child: const Text('Show Error'),
                      ),
                      TextButton(
                        onPressed: () {
                          AppNotifications.of(context).info(message: 'Info');
                        },
                        child: const Text('Show Info'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets(
    'shows a success notification',
    (tester) async {
      await pumpTest(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Success'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/notification_success.png'),
      );
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    },
    skip: false,
  );

  testWidgets(
    'shows an info notification',
    (tester) async {
      await pumpTest(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Info'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/notification_info.png'),
      );
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    },
    skip: false,
  );

  testWidgets(
    'shows an error notification',
    (tester) async {
      await pumpTest(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Error'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/notification_error.png'),
      );
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    },
    skip: false,
  );
}
