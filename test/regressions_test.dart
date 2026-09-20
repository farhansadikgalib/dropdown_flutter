import 'dart:async';

import 'package:dropdown_flutter/dropdown_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget host(Widget child, {ThemeData? theme}) => MaterialApp(
      theme: theme,
      home: Scaffold(body: Align(alignment: Alignment.topCenter, child: child)),
    );

void main() {
  const items = ['Apple', 'Banana', 'Cherry'];

  test('multi-select stores immutable snapshots and suppresses duplicates', () {
    final source = ['Apple'];
    final controller = MultiSelectController(source);
    var calls = 0;
    controller.addListener(() => calls++);
    source.add('Banana');
    expect(controller.value, ['Apple']);
    expect(() => controller.value.add('Cherry'), throwsUnsupportedError);
    controller.add('Apple');
    expect(calls, 0);
    controller.value = ['Apple', 'Banana', 'Banana'];
    expect(controller.value, ['Apple', 'Banana']);
    expect(calls, 1);
    controller.dispose();
  });

  test('every initial multi-selection must belong to the local items', () {
    expect(
      () => DropdownFlutter<String>.multiSelect(
        items: items,
        initialItems: ['Apple', 'Unknown'],
        onListChanged: (_) {},
      ),
      throwsAssertionError,
    );
  });

  testWidgets('removing a supplied controller preserves its ownership',
      (tester) async {
    final controller = SingleSelectController<String?>('Apple');
    Widget build(SingleSelectController<String?>? value) => host(
          DropdownFlutter<String>(
              items: items, controller: value, onChanged: (_) {}),
        );
    await tester.pumpWidget(build(controller));
    await tester.pumpWidget(build(null));
    await tester.pumpWidget(host(const SizedBox()));
    controller.value = 'Banana';
    expect(tester.takeException(), isNull);
    controller.dispose();
  });

  testWidgets('form reset restores selection and clears validation',
      (tester) async {
    final form = GlobalKey<FormState>();
    final controller = SingleSelectController<String?>('Apple');
    await tester.pumpWidget(host(Form(
        key: form,
        child: DropdownFlutter<String>(
          items: items,
          controller: controller,
          onChanged: (_) {},
          validator: (value) => value == null ? 'Required' : null,
        ))));
    controller.clear();
    await tester.pump();
    expect(find.text('Required'), findsOneWidget);
    form.currentState!.reset();
    await tester.pump();
    expect(controller.value, 'Apple');
    expect(find.text('Required'), findsNothing);
    expect(find.text('Apple'), findsOneWidget);
    await tester.pumpWidget(host(const SizedBox()));
    controller.dispose();
  });

  testWidgets('controller replacement updates form validation', (tester) async {
    final form = GlobalKey<FormState>();
    final first = SingleSelectController<String?>('Apple');
    final second = SingleSelectController<String?>(null);
    Widget build(SingleSelectController<String?> c) => host(Form(
        key: form,
        child: DropdownFlutter<String>(
            items: items,
            controller: c,
            onChanged: (_) {},
            validator: (value) => value == null ? 'Required' : null)));
    await tester.pumpWidget(build(first));
    await tester.pumpWidget(build(second));
    expect(form.currentState!.validate(), isFalse);
    await tester.pumpWidget(host(const SizedBox()));
    first.dispose();
    second.dispose();
  });

  testWidgets('open multi-select updates after controller writes and swaps',
      (tester) async {
    final first = MultiSelectController<String>([]);
    final second = MultiSelectController<String>(['Cherry']);
    Widget build(MultiSelectController<String> c) =>
        host(DropdownFlutter<String>.multiSelect(
            items: items, multiSelectController: c, onListChanged: (_) {}));
    await tester.pumpWidget(build(first));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    first.add('Banana');
    await tester.pumpAndSettle();
    expect(
        tester.widgetList<Checkbox>(find.byType(Checkbox)).map((e) => e.value),
        [false, true, false]);
    await tester.pumpWidget(build(second));
    await tester.pumpAndSettle();
    expect(
        tester.widgetList<Checkbox>(find.byType(Checkbox)).map((e) => e.value),
        [false, false, true]);
    await tester.pumpWidget(host(const SizedBox()));
    first.dispose();
    second.dispose();
  });

  testWidgets(
      'select all applies to filtered results and preserves other selections',
      (tester) async {
    final controller = MultiSelectController<String>(['Apple']);
    await tester.pumpWidget(host(DropdownFlutter<String>.multiSelectSearch(
        items: items,
        multiSelectController: controller,
        showSelectAll: true,
        onListChanged: (_) {})));
    await tester.tap(find.text('Apple'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Ban');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select all'));
    await tester.pumpAndSettle();
    expect(controller.value, ['Apple', 'Banana']);
    await tester.tap(find.text('Clear all'));
    await tester.pumpAndSettle();
    expect(controller.value, ['Apple']);
    await tester.pumpWidget(host(const SizedBox()));
    controller.dispose();
  });

  testWidgets('async results cannot overwrite a newer query or cleared search',
      (tester) async {
    final requests = <String, Completer<List<String>>>{};
    await tester.pumpWidget(host(DropdownFlutter<String>.searchRequest(
        futureRequest: (q) => (requests[q] = Completer<List<String>>()).future,
        onChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'b');
    await tester.pump();
    requests['b']!.complete(['Banana']);
    await tester.pumpAndSettle();
    requests['a']!.complete(['Apple']);
    await tester.pumpAndSettle();
    expect(find.text('Banana'), findsOneWidget);
    expect(find.text('Apple'), findsNothing);
    await tester.enterText(find.byType(TextField), 'c');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    requests['c']!.complete(['Cherry']);
    await tester.pumpAndSettle();
    expect(find.text('Cherry'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('clearing cancels debounce and close-on-clear works',
      (tester) async {
    var calls = 0;
    await tester.pumpWidget(host(DropdownFlutter<String>.searchRequest(
        futureRequest: (_) async {
          calls++;
          return items;
        },
        futureRequestDelay: const Duration(milliseconds: 500),
        closeDropDownOnClearFilterSearch: true,
        onChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
    expect(calls, 0);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('request completion after disposal does not call setState',
      (tester) async {
    final request = Completer<List<String>>();
    await tester.pumpWidget(host(DropdownFlutter<String>.searchRequest(
        futureRequest: (_) => request.future, onChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.pumpWidget(host(const SizedBox()));
    request.complete(items);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('remote multi-select select-all uses fetched items',
      (tester) async {
    List<String> selection = [];
    await tester.pumpWidget(host(
        DropdownFlutter<String>.multiSelectSearchRequest(
            futureRequest: (_) async => items,
            showSelectAll: true,
            onListChanged: (value) => selection = value)));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'fruit');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select all'));
    await tester.pumpAndSettle();
    expect(selection, items);
  });

  testWidgets('keyboard can open the field and disabled fields cannot open',
      (tester) async {
    await tester.pumpWidget(host(DropdownFlutter<String>(
        items: items, enableKeyboardNavigation: true, onChanged: (_) {})));
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('Banana'), findsOneWidget);
    await tester.pumpWidget(host(DropdownFlutter<String>(
        items: items,
        enabled: false,
        enableKeyboardNavigation: true,
        onChanged: (_) {})));
    await tester.pumpAndSettle();
    expect(find.text('Banana'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('short lists with tall rows remain bounded near screen bottom',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: Align(
                alignment: Alignment.bottomCenter,
                child: DropdownFlutter<String>(
                    items: items, listItemHeight: 150, onChanged: (_) {})))));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    final list = tester.getRect(find.byType(ListView));
    expect(list.top, greaterThanOrEqualTo(0));
    expect(
        list.bottom,
        lessThanOrEqualTo(
            tester.view.physicalSize.height / tester.view.devicePixelRatio));
    expect(tester.takeException(), isNull);
  });

  testWidgets('compact menus support large text and RTL without overflow',
      (tester) async {
    await tester.pumpWidget(host(MediaQuery(
        data: const MediaQueryData(
            size: Size(800, 600), textScaler: TextScaler.linear(2)),
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: DropdownFlutter<String>.multiSelectSearch(
                items: items,
                overlayHeight: 120,
                showSelectAll: true,
                groupBy: (_) =>
                    'A very long group heading that should fit in the available width',
                onListChanged: (_) {})))));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('zero-duration animations open and close safely', (tester) async {
    await tester.pumpWidget(host(DropdownFlutter<String>(
        items: items, animationDuration: Duration.zero, onChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Banana'));
    await tester.pumpAndSettle();
    expect(find.text('Cherry'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('open overlay responds to replacement items', (tester) async {
    Widget build(List<String> values) =>
        host(DropdownFlutter<String>.search(items: values, onChanged: (_) {}));
    await tester.pumpWidget(build(items));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pumpAndSettle();
    await tester.pumpWidget(build(['Date', 'Fig']));
    await tester.pumpAndSettle();
    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Apple'), findsNothing);
    expect(find.text('Fig'), findsNothing);
  });

  testWidgets('failed requests recover on the next query', (tester) async {
    await tester.pumpWidget(host(DropdownFlutter<String>.searchRequest(
        futureRequest: (q) async {
          if (q == 'bad') throw StateError('offline');
          return items;
        },
        onChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'bad');
    await tester.pumpAndSettle();
    expect(
        find.text('Unable to load results. Please try again.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'good');
    await tester.pumpAndSettle();
    expect(find.text('Banana'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('dark defaults use the theme surface', (tester) async {
    final theme = ThemeData.dark();
    await tester.pumpWidget(host(
        DropdownFlutter<String>(items: items, onChanged: (_) {}),
        theme: theme));
    final colors = tester
        .widgetList<Container>(find.byType(Container))
        .map((w) => w.decoration)
        .whereType<BoxDecoration>()
        .map((d) => d.color);
    expect(colors, contains(theme.colorScheme.surface));
    expect(colors, isNot(contains(Colors.white)));
  });

  testWidgets('external overlay controller can be replaced', (tester) async {
    final first = OverlayPortalController();
    final second = OverlayPortalController();
    Widget build(OverlayPortalController c) => host(DropdownFlutter<String>(
        items: items, overlayController: c, onChanged: (_) {}));
    await tester.pumpWidget(build(first));
    await tester.pumpWidget(build(second));
    second.show();
    await tester.pumpAndSettle();
    expect(find.text('Banana'), findsOneWidget);
    second.hide();
    await tester.pumpAndSettle();
    expect(find.text('Banana'), findsNothing);
  });

  testWidgets('keyboard scrolls tall grouped rows into view', (tester) async {
    final values = List.generate(12, (index) => 'Item $index');
    await tester.pumpWidget(host(DropdownFlutter<String>(
        items: values,
        enableKeyboardNavigation: true,
        groupBy: (_) => 'Group',
        listItemBuilder: (_, item, selected, onTap) =>
            SizedBox(height: 100, child: Text(item)),
        onChanged: (_) {})));
    await tester.tap(find.text('Select value'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 6; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
    }
    final list = tester.getRect(find.byType(ListView));
    final row = tester.getRect(find.text('Item 5'));
    expect(row.top, greaterThanOrEqualTo(list.top));
    expect(row.bottom, lessThanOrEqualTo(list.bottom));
    for (var i = 0; i < 5; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pumpAndSettle();
    }
    final first = tester.getRect(find.text('Item 0'));
    expect(first.top, greaterThanOrEqualTo(list.top));
    expect(first.bottom, lessThanOrEqualTo(list.bottom));
  });
}
