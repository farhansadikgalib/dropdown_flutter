// Drives the example app into each showcase state and captures a frame via
// the integration_test binding. Frames are written by `test_driver/screenshot_driver.dart`
// into screenshots/raw/.
//
// Run with:
//   flutter drive --driver=test_driver/screenshot_driver.dart \
//     --target=integration_test/screenshot_test.dart -d <device>
import 'dart:io';

import 'package:dropdown_flutter_example/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Finder card(String title) => find.byKey(ValueKey('demo-card-$title'));
  Finder inCard(String title, Finder inner) =>
      find.descendant(of: card(title), matching: inner);

  /// Captures the current frame under [name].
  Future<void> capture(WidgetTester tester, String name) async {
    await tester.pumpAndSettle();
    await binding.takeScreenshot(name);
  }

  Future<void> launchApp(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
  }

  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(find.widgetWithText(Tab, label));
    await tester.pumpAndSettle();
  }

  testWidgets('capture showcase frames', (tester) async {
    // Android renders into a surface that must be converted before the
    // binding can read pixels back.
    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
    }

    await launchApp(tester);

    // 1. Overview of the single-selection gallery.
    await capture(tester, '01_overview');

    // 2. Single-select overlay open over the simple dropdown.
    await tester.tap(inCard('Simple dropdown', find.text('Medium')));
    await tester.pumpAndSettle();
    await capture(tester, '02_single_open');
    await tester.tap(find.text('Medium').last);
    await tester.pumpAndSettle();

    // 3. Search dropdown filtering on a query.
    await tester.tap(inCard('Search dropdown', find.text('Bangladesh')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'ind');
    await tester.pumpAndSettle(const Duration(milliseconds: 600));
    await capture(tester, '03_search');
    await tester.tap(find.text('India'));
    await tester.pumpAndSettle();

    // 4. The fully decorated dark dropdown, expanded.
    final decorated = inCard('Fully decorated', find.text('Priya Nair'));
    await tester.scrollUntilVisible(
      decorated,
      250,
      scrollable: find.descendant(
        of: find.byKey(const ValueKey('single-tab-list')),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(decorated);
    await tester.pumpAndSettle();
    await capture(tester, '04_decorated');
    // Close via the header itself: rows further down the list may be
    // scrolled out of view. Once open the name also appears in the list,
    // so target the first match (the header).
    await tester.tap(decorated.first);
    await tester.pumpAndSettle();

    // 5. Multi-select overlay with several rows ticked.
    await openTab(tester, 'Multi');
    await tester
        .tap(inCard('Multi select', find.text('Ayesha Rahman, Daniel Okafor')));
    await tester.pumpAndSettle();
    await capture(tester, '05_multi_select');
    await tester.tap(find.text('Ayesha Rahman, Daniel Okafor').first);
    await tester.pumpAndSettle();

    // 6. Grouped sections + recents in the modern UX tab.
    await openTab(tester, 'Modern UX');
    await tester.tap(
      inCard(
        'Grouped + keyboard + haptics',
        find.text('Pick a teammate'),
      ),
    );
    await tester.pumpAndSettle();
    await capture(tester, '06_grouped');
    await tester.dragUntilVisible(
      find.text('Omar Haddad'),
      find.byType(Scrollable).last,
      const Offset(0, -60),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Omar Haddad'));
    await tester.pumpAndSettle();

    // 7. Match highlighting in search results.
    await tester.tap(
      inCard('Match highlighting', find.text('Search countries')),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'ind');
    await tester.pumpAndSettle(const Duration(milliseconds: 600));
    await capture(tester, '07_highlight');
    await tester.tap(find.text('India').last);
    await tester.pumpAndSettle();

    // 8. Dark theme overview.
    await tester.tap(find.byTooltip('Toggle theme'));
    await tester.pumpAndSettle();
    await openTab(tester, 'Single');
    await tester.tap(inCard('Simple dropdown', find.text('Medium')));
    await tester.pumpAndSettle();
    await capture(tester, '08_dark');
  });
}
