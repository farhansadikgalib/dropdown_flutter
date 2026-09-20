import 'dart:async';

import 'package:dropdown_flutter/dropdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  const items = ['Apple', 'Banana', 'Cherry'];

  testWidgets(
      'remote search starts with a prompt and errors can retry the same query',
      (tester) async {
    final queries = <String>[];
    await tester.pumpWidget(host(DropdownFlutter<String>.searchRequest(
        searchHintText: 'Find a fruit',
        futureRequest: (query) async {
          queries.add(query);
          if (queries.length == 1) throw StateError('offline');
          return ['Banana'];
        },
        onChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    expect(find.text('No result found.'), findsNothing);
    expect(find.byTooltip('Clear search'), findsNothing);
    await tester.enterText(find.byType(TextField), 'ban');
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('No result found.'), findsNothing);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(queries, ['ban', 'ban']);
    expect(find.text('Banana'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);
    expect(tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'ban');
  });

  testWidgets('custom error builder receives the error and retry action',
      (tester) async {
    final error = StateError('offline');
    Object? received;
    var attempts = 0;
    await tester.pumpWidget(host(DropdownFlutter<String>.searchRequest(
        futureRequest: (_) async {
          if (attempts++ == 0) throw error;
          return items;
        },
        searchRequestErrorBuilder: (_, failure, retry) {
          received = failure;
          return TextButton(onPressed: retry, child: const Text('Reconnect'));
        },
        onChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pumpAndSettle();
    expect(received, same(error));
    await tester.tap(find.text('Reconnect'));
    await tester.pumpAndSettle();
    expect(find.text('Banana'), findsOneWidget);
  });

  testWidgets('clear removes the error and keeps search focused',
      (tester) async {
    await tester.pumpWidget(host(DropdownFlutter<String>.searchRequest(
        futureRequest: (_) async => throw StateError('offline'),
        onChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsNothing);
    expect(find.byTooltip('Clear search'), findsNothing);
    expect(tester.widget<TextField>(find.byType(TextField)).focusNode!.hasFocus,
        isTrue);
  });

  testWidgets('multi-select shows a count and Done keeps the selection',
      (tester) async {
    final controller = MultiSelectController<String>([]);
    await tester.pumpWidget(host(DropdownFlutter<String>.multiSelect(
        items: items,
        multiSelectController: controller,
        doneText: 'Finish',
        onListChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();
    expect(find.text('1 item selected'), findsOneWidget);
    await tester.tap(find.text('Finish'));
    await tester.pumpAndSettle();
    expect(find.byType(Checkbox), findsNothing);
    expect(controller.value, ['Banana']);
    await tester.pumpWidget(host(const SizedBox()));
    controller.dispose();
  });

  testWidgets('footer can be hidden and is absent on single-select',
      (tester) async {
    await tester.pumpWidget(host(DropdownFlutter<String>.multiSelect(
        items: items, showMultiSelectFooter: false, onListChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    expect(find.text('Done'), findsNothing);
    await tester.pumpWidget(host(const SizedBox()));
    await tester.pumpWidget(
        host(DropdownFlutter<String>(items: items, onChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    expect(find.text('Done'), findsNothing);
  });

  testWidgets(
      'Escape dismisses without arrow navigation and restores trigger focus',
      (tester) async {
    await tester.pumpWidget(
        host(DropdownFlutter<String>(items: items, onChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Banana'), findsNothing);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Banana'), findsOneWidget);
  });

  testWidgets('pending requests cannot select stale results using the keyboard',
      (tester) async {
    final response = Completer<List<String>>();
    String? selection;
    await tester.pumpWidget(host(DropdownFlutter<String>.searchRequest(
        items: items,
        enableKeyboardNavigation: true,
        futureRequest: (_) => response.future,
        onChanged: (value) => selection = value)));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'new');
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(selection, isNull);
    response.complete(['New item']);
    await tester.pumpAndSettle();
    expect(find.text('New item'), findsOneWidget);
  });
}
