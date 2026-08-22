import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dropdown_flutter/custom_dropdown.dart';

Widget host(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  const items = ['Engineer', 'Designer', 'Manager'];

  testWidgets('listItemHeight fixes each row height', (tester) async {
    await tester.pumpWidget(host(
      DropdownFlutter<String>(
        items: items,
        listItemHeight: 72,
        onChanged: (_) {},
      ),
    ));
    await tester.tap(find.byType(DropdownFlutter<String>));
    await tester.pumpAndSettle();

    final row = tester.getSize(
      find
          .ancestor(
            of: find.text('Designer'),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(row.height, 72);
  });

  testWidgets('listItemHeight applies with grouped sections', (tester) async {
    await tester.pumpWidget(host(
      DropdownFlutter<String>(
        items: items,
        listItemHeight: 64,
        groupBy: (i) => i[0].toUpperCase(),
        onChanged: (_) {},
      ),
    ));
    await tester.tap(find.byType(DropdownFlutter<String>));
    await tester.pumpAndSettle();

    final row = tester.getSize(
      find
          .ancestor(
            of: find.text('Designer'),
            matching: find.byType(SizedBox),
          )
          .first,
    );
    expect(row.height, 64);
  });

  testWidgets('rows still size to content when height is null', (tester) async {
    await tester.pumpWidget(host(
      DropdownFlutter<String>(
        items: items,
        listItemBuilder: (c, item, s, t) =>
            SizedBox(height: 90, child: Text(item)),
        onChanged: (_) {},
      ),
    ));
    await tester.tap(find.byType(DropdownFlutter<String>));
    await tester.pumpAndSettle();
    expect(find.text('Designer'), findsOneWidget);
  });
}
