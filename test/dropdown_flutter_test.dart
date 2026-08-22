import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const items = ['Apple', 'Banana', 'Cherry'];

  Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(
            body: Padding(padding: const EdgeInsets.all(16), child: child)),
      );

  testWidgets('renders hint text when no item is selected', (tester) async {
    await tester.pumpWidget(
      wrap(
        DropdownFlutter<String>(
          items: items,
          hintText: 'Select a fruit',
          onChanged: (_) {},
        ),
      ),
    );

    expect(find.text('Select a fruit'), findsOneWidget);
  });

  testWidgets('opens overlay and selects an item', (tester) async {
    String? selected;

    await tester.pumpWidget(
      wrap(
        DropdownFlutter<String>(
          items: items,
          hintText: 'Select a fruit',
          onChanged: (value) => selected = value,
        ),
      ),
    );

    // Open the dropdown.
    await tester.tap(find.text('Select a fruit'));
    await tester.pumpAndSettle();

    expect(find.text('Banana'), findsOneWidget);

    // Select an item.
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();

    expect(selected, 'Banana');
  });

  testWidgets('search constructor filters items by query', (tester) async {
    await tester.pumpWidget(
      wrap(
        DropdownFlutter<String>.search(
          items: items,
          hintText: 'Select a fruit',
          onChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('Select a fruit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Ch');
    await tester.pumpAndSettle();

    expect(find.text('Cherry'), findsOneWidget);
    expect(find.text('Apple'), findsNothing);
  });

  // ---- Modern UX features (all opt-in) ----

  testWidgets('groupBy renders section headers', (tester) async {
    await tester.pumpWidget(
      wrap(
        DropdownFlutter<String>(
          items: items,
          hintText: 'h',
          groupBy: (item) => item == 'Cherry' ? 'Group 2' : 'Group 1',
          onChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('h'));
    await tester.pumpAndSettle();

    expect(find.text('Group 1'), findsOneWidget);
    expect(find.text('Group 2'), findsOneWidget);
  });

  testWidgets('select-all toggles every item in multi-select', (tester) async {
    List<String> selected = [];

    await tester.pumpWidget(
      wrap(
        DropdownFlutter<String>.multiSelect(
          items: items,
          hintText: 'h',
          showSelectAll: true,
          onListChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.text('h'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Select all'));
    await tester.pumpAndSettle();

    expect(selected, items);

    // Now it should offer "Clear all".
    await tester.tap(find.text('Clear all'));
    await tester.pumpAndSettle();

    expect(selected, isEmpty);
  });

  testWidgets('highlightMatchedText renders a rich label for matches',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        DropdownFlutter<String>.search(
          items: items,
          hintText: 'h',
          highlightMatchedText: true,
          onChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('h'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'an');
    await tester.pumpAndSettle();

    // The matched item label is built with Text.rich (textSpan set).
    final richLabels = find.byWidgetPredicate(
      (w) => w is Text && w.textSpan != null,
    );
    expect(richLabels, findsWidgets);
  });

  testWidgets('keyboard navigation selects with ArrowDown + Enter',
      (tester) async {
    String? selected;

    await tester.pumpWidget(
      wrap(
        DropdownFlutter<String>(
          items: items,
          hintText: 'h',
          enableKeyboardNavigation: true,
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.text('h'));
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(selected, 'Apple');
  });

  testWidgets('recent selections appear after a pick', (tester) async {
    await tester.pumpWidget(
      wrap(
        DropdownFlutter<String>(
          items: items,
          hintText: 'h',
          recentSelectionsMaxCount: 3,
          onChanged: (_) {},
        ),
      ),
    );

    await tester.tap(find.text('h'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();

    // Reopen — the recently-selected section should now be present.
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();

    expect(find.text('Recently selected'), findsOneWidget);
  });

  testWidgets('configurable animation + haptics build and select cleanly',
      (tester) async {
    String? selected;

    await tester.pumpWidget(
      wrap(
        DropdownFlutter<String>(
          items: items,
          hintText: 'h',
          enableHapticFeedback: true,
          animationDuration: const Duration(milliseconds: 120),
          animationCurve: Curves.easeOutCubic,
          onChanged: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.text('h'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cherry'));
    await tester.pumpAndSettle();

    expect(selected, 'Cherry');
  });

  testWidgets('selected row stays legible under a dark theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        home: Scaffold(
          body: DropdownFlutter<String>(
            items: items,
            initialItem: items.first,
            excludeSelected: false,
            hintText: 'h',
            onChanged: (_) {},
          ),
        ),
      ),
    );

    await tester.tap(find.text(items.first).first);
    await tester.pumpAndSettle();

    // The selected row must not fall back to the hardcoded light tint,
    // which is unreadable on a dark surface.
    final inkColors = tester
        .widgetList<Ink>(find.byType(Ink))
        .map((e) => e.decoration)
        .whereType<BoxDecoration>()
        .map((d) => d.color)
        .toList();
    expect(inkColors, isNotEmpty);
    expect(inkColors, isNot(contains(const Color(0xFFF5F5F5))));
  });

  test('CustomDropdownDecoration.copyWith replaces only given fields', () {
    const base = CustomDropdownDecoration(
      closedFillColor: Color(0xFF111111),
      hintStyle: TextStyle(fontSize: 15),
    );

    final copy = base.copyWith(hintStyle: const TextStyle(fontSize: 20));

    expect(copy.closedFillColor, const Color(0xFF111111));
    expect(copy.hintStyle?.fontSize, 20);
    expect(base.hintStyle?.fontSize, 15);
  });
}
