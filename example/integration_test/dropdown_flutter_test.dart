import 'package:dropdown_flutter_example/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Boots the example app and settles the first frame.
  Future<void> launchApp(WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
  }

  /// Switches to the tab with [label] and waits for the transition.
  Future<void> openTab(WidgetTester tester, String label) async {
    await tester.tap(find.widgetWithText(Tab, label));
    await tester.pumpAndSettle();
  }

  /// The demo card carrying [title], used to scope finders to one example.
  Finder card(String title) => find.byKey(ValueKey('demo-card-$title'));

  /// Finds [inner] only within the demo card titled [title].
  Finder inCard(String title, Finder inner) =>
      find.descendant(of: card(title), matching: inner);

  /// Scrolls the list keyed [listKey] until [finder] is on screen.
  Future<void> scrollTo(
    WidgetTester tester,
    String listKey,
    Finder finder,
  ) async {
    await tester.scrollUntilVisible(
      finder,
      250,
      scrollable: find.descendant(
        of: find.byKey(ValueKey(listKey)),
        matching: find.byType(Scrollable),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('app shell', () {
    testWidgets('boots and shows all three tabs', (tester) async {
      await launchApp(tester);

      expect(find.text('Dropdown Flutter'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Single'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Multi'), findsOneWidget);
      expect(find.widgetWithText(Tab, 'Modern UX'), findsOneWidget);
      expect(card('Simple dropdown'), findsOneWidget);
    });

    testWidgets('switches between tabs', (tester) async {
      await launchApp(tester);

      await openTab(tester, 'Multi');
      expect(card('Multi select'), findsOneWidget);

      await openTab(tester, 'Modern UX');
      expect(card('Match highlighting'), findsOneWidget);

      await openTab(tester, 'Single');
      expect(card('Simple dropdown'), findsOneWidget);
    });

    testWidgets('toggles between light and dark theme', (tester) async {
      await launchApp(tester);

      Brightness currentBrightness() =>
          Theme.of(tester.element(card('Simple dropdown'))).brightness;

      expect(currentBrightness(), Brightness.light);

      await tester.tap(find.byTooltip('Toggle theme'));
      await tester.pumpAndSettle();
      expect(currentBrightness(), Brightness.dark);

      await tester.tap(find.byTooltip('Toggle theme'));
      await tester.pumpAndSettle();
      expect(currentBrightness(), Brightness.light);
    });
  });

  group('single select', () {
    testWidgets('opens the overlay and selects an item', (tester) async {
      await launchApp(tester);

      // The simple dropdown starts on 'Developer'.
      expect(inCard('Simple dropdown', find.text('Medium')), findsOneWidget);

      await tester.tap(inCard('Simple dropdown', find.text('Medium')));
      await tester.pumpAndSettle();

      // The overlay is open, so every option is rendered.
      expect(find.text('Urgent'), findsOneWidget);

      await tester.tap(find.text('Urgent'));
      await tester.pumpAndSettle();

      // Overlay closed and the header now reads the new value.
      expect(inCard('Simple dropdown', find.text('Urgent')), findsOneWidget);
    });

    testWidgets('filters items through the search field', (tester) async {
      await launchApp(tester);

      await tester.tap(inCard('Search dropdown', find.text('Bangladesh')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'indo');
      await tester.pumpAndSettle(const Duration(milliseconds: 600));

      expect(find.text('Indonesia'), findsOneWidget);
      expect(find.text('Australia'), findsNothing);

      await tester.tap(find.text('Indonesia'));
      await tester.pumpAndSettle();
      expect(
        inCard('Search dropdown', find.text('Indonesia')),
        findsOneWidget,
      );
    });

    testWidgets('shows a validation error on empty submit', (tester) async {
      await launchApp(tester);

      final submit = inCard(
        'Form validation',
        find.widgetWithText(FilledButton, 'Submit'),
      );
      await scrollTo(tester, 'single-tab-list', submit);

      await tester.tap(submit);
      await tester.pumpAndSettle();

      expect(find.text('Please select a reviewer'), findsOneWidget);
    });

    testWidgets('clears the value through its controller', (tester) async {
      await launchApp(tester);

      const title = 'Controller + validation';
      final clearIcon = inCard(title, find.byIcon(Icons.close));
      await scrollTo(tester, 'single-tab-list', clearIcon);

      // The controller demo starts pre-filled with the first member.
      expect(inCard(title, find.text('Ayesha Rahman')), findsOneWidget);

      // The close suffix icon calls controller.clear().
      await tester.tap(clearIcon);
      await tester.pumpAndSettle();

      expect(inCard(title, find.text('Select an owner')), findsOneWidget);
    });
  });

  group('multi select', () {
    testWidgets('selects and deselects several items', (tester) async {
      await launchApp(tester);
      await openTab(tester, 'Multi');

      const title = 'Multi select';
      const two = 'Ayesha Rahman, Daniel Okafor';
      // Starts with the first two members selected.
      expect(inCard(title, find.text(two)), findsOneWidget);

      await tester.tap(inCard(title, find.text(two)));
      await tester.pumpAndSettle();

      // Overlay rows live outside the card, so scope by what is on screen.
      await tester.tap(find.text('Priya Nair').last);
      await tester.pumpAndSettle();
      expect(
        inCard(title, find.text('$two, Priya Nair')),
        findsAtLeast(1),
      );

      // Tapping an already selected row removes it again.
      await tester.tap(find.text('Ayesha Rahman').last);
      await tester.pumpAndSettle();
      expect(
        inCard(title, find.text('Daniel Okafor, Priya Nair')),
        findsAtLeast(1),
      );
    });

    testWidgets('adds and clears items via the controller', (tester) async {
      await launchApp(tester);
      await openTab(tester, 'Multi');

      const title = 'Multi select controller';
      final toggle = inCard(
        title,
        find.widgetWithText(FilledButton, 'Toggle first'),
      );
      await scrollTo(tester, 'multi-tab-list', toggle);

      // Starts with the first member selected; toggling removes them.
      expect(inCard(title, find.text('Ayesha Rahman')), findsOneWidget);
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(inCard(title, find.text('Assign teammates')), findsOneWidget);

      // Toggle back on, then clear everything.
      await tester.tap(toggle);
      await tester.pumpAndSettle();
      expect(inCard(title, find.text('Ayesha Rahman')), findsOneWidget);

      await tester.tap(
        inCard(title, find.widgetWithText(OutlinedButton, 'Clear')),
      );
      await tester.pumpAndSettle();
      expect(inCard(title, find.text('Assign teammates')), findsOneWidget);
    });

    testWidgets('requires at least one selection', (tester) async {
      await launchApp(tester);
      await openTab(tester, 'Multi');

      const title = 'Multi select validation';
      final submit = inCard(
        title,
        find.widgetWithText(FilledButton, 'Submit'),
      );
      await scrollTo(tester, 'multi-tab-list', submit);

      await tester.tap(submit);
      await tester.pumpAndSettle();

      expect(find.text('Please select at least one reviewer'), findsOneWidget);
    });
  });

  group('modern ux', () {
    const groupedTitle = 'Grouped + keyboard + haptics';

    testWidgets('renders grouped section headers', (tester) async {
      await launchApp(tester);
      await openTab(tester, 'Modern UX');

      await tester.tap(inCard(groupedTitle, find.text('Pick a teammate')));
      await tester.pumpAndSettle();

      // Members are grouped by their team.
      expect(find.text('Design'), findsOneWidget);
      expect(find.text('Ayesha Rahman'), findsOneWidget);
      expect(find.text('Engineering'), findsOneWidget);
    });

    testWidgets('records a recent selection after picking', (tester) async {
      await launchApp(tester);
      await openTab(tester, 'Modern UX');

      await tester.tap(inCard(groupedTitle, find.text('Pick a teammate')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Daniel Okafor').last);
      await tester.pumpAndSettle();

      // Reopen: the pick is now listed under the recents header.
      await tester.tap(inCard(groupedTitle, find.text('Daniel Okafor')));
      await tester.pumpAndSettle();

      expect(find.text('Recently selected'), findsOneWidget);
      // Closed-field header plus the row under "Recently selected".
      expect(find.text('Daniel Okafor'), findsAtLeast(2));
    });

    testWidgets('select-all toggles every item', (tester) async {
      await launchApp(tester);
      await openTab(tester, 'Modern UX');

      const title = 'Select all';
      final field = inCard(title, find.text('Select countries'));
      await scrollTo(tester, 'modern-tab-list', field);

      await tester.tap(field);
      await tester.pumpAndSettle();

      // The card title is also "Select all", so target the overlay's row.
      await tester.tap(find.text('Select all').last);
      await tester.pumpAndSettle();

      // With everything selected the action flips to the clear variant.
      expect(find.text('Clear all'), findsOneWidget);

      await tester.tap(find.text('Clear all'));
      await tester.pumpAndSettle();
      expect(find.text('Select all'), findsNWidgets(2));
    });
  });
}
