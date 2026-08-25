// `hasListeners` is @protected on ChangeNotifier, but observing whether a
// listener is still attached is precisely what these regression tests assert.
// ignore_for_file: invalid_use_of_protected_member

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regression tests for the stranded-listener crash: a listener the dropdown
/// attached to an app-supplied controller survived the state's dispose, so the
/// next value change called setState on an unmounted FormFieldState ("Null
/// check operator used on a null value") and ran onChanged for a dead screen.
void main() {
  const items = ['Apple', 'Banana', 'Cherry'];

  Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(
            body: Padding(padding: const EdgeInsets.all(16), child: child)),
      );

  testWidgets('dispose detaches the listener from an app-supplied controller',
      (tester) async {
    final controller = SingleSelectController<String?>(null);

    await tester.pumpWidget(
      wrap(
        DropdownFlutter<String>(
          items: items,
          controller: controller,
          onChanged: (_) {},
        ),
      ),
    );
    expect(controller.hasListeners, isTrue);

    // Remove the dropdown; the controller lives on, as it does on an app-side
    // state object that outlives the screen.
    await tester.pumpWidget(wrap(const SizedBox()));
    expect(controller.hasListeners, isFalse,
        reason: 'no listener may outlive the state that registered it');

    // The stranded listener used to crash right here.
    var thrown = false;
    try {
      controller.value = 'Apple';
    } catch (_) {
      thrown = true;
    }
    expect(thrown, isFalse);
    controller.dispose();
  });

  testWidgets('dispose detaches from a multi-select controller',
      (tester) async {
    final controller = MultiSelectController<String>([]);

    await tester.pumpWidget(
      wrap(
        DropdownFlutter<String>.multiSelect(
          items: items,
          multiSelectController: controller,
          onListChanged: (_) {},
        ),
      ),
    );
    expect(controller.hasListeners, isTrue);

    await tester.pumpWidget(wrap(const SizedBox()));
    expect(controller.hasListeners, isFalse);
    controller.dispose();
  });

  testWidgets('swapping controllers moves the listener to the new instance',
      (tester) async {
    final first = SingleSelectController<String?>(null);
    final second = SingleSelectController<String?>(null);
    String? changed;

    Widget build(SingleSelectController<String?> controller) => wrap(
          DropdownFlutter<String>(
            items: items,
            controller: controller,
            onChanged: (value) => changed = value,
          ),
        );

    await tester.pumpWidget(build(first));
    expect(first.hasListeners, isTrue);

    await tester.pumpWidget(build(second));
    expect(first.hasListeners, isFalse,
        reason: 'the listener must not stay behind on the old controller');
    expect(second.hasListeners, isTrue,
        reason: 'the new controller must keep driving onChanged');

    // Selection through the new controller still reaches the widget.
    second.value = 'Banana';
    await tester.pump();
    expect(changed, 'Banana');

    first.dispose();
    second.dispose();
  });

  testWidgets(
      'unkeyed sibling removal recycles the state without stranding a listener',
      (tester) async {
    // Positional state recycling: when the first sibling disappears, the
    // survivor's state is the one that was built for the first controller.
    final a = SingleSelectController<String?>(null);
    final b = SingleSelectController<String?>(null);

    Widget build({required bool showFirst}) => wrap(
          Column(
            children: [
              if (showFirst)
                SizedBox(
                  height: 60,
                  child: DropdownFlutter<String>(
                      items: items, controller: a, onChanged: (_) {}),
                ),
              SizedBox(
                height: 60,
                child: DropdownFlutter<String>(
                    items: items, controller: b, onChanged: (_) {}),
              ),
            ],
          ),
        );

    await tester.pumpWidget(build(showFirst: true));
    expect(a.hasListeners, isTrue);
    expect(b.hasListeners, isTrue);

    await tester.pumpWidget(build(showFirst: false));
    expect(a.hasListeners, isFalse,
        reason: 'the recycled state re-homed its listener onto b');
    expect(b.hasListeners, isTrue);

    a.dispose();
    b.dispose();
  });

  testWidgets('a notification during teardown does not touch the dead state',
      (tester) async {
    // The Crashlytics trace: a shared controller changes value after the
    // screen is gone, and the listener runs onChanged then FormFieldState
    // .didChange -> setState on an unmounted state.
    final shared = SingleSelectController<String?>(null);
    var disposed = false;
    var changedAfterDispose = false;

    await tester.pumpWidget(
      wrap(
        DropdownFlutter<String>(
          items: items,
          controller: shared,
          validator: (value) => value == null ? 'Required' : null,
          onChanged: (_) {
            if (disposed) changedAfterDispose = true;
          },
        ),
      ),
    );

    await tester.pumpWidget(wrap(const SizedBox()));
    disposed = true;

    // Anything the app does with its own controller afterwards must be inert.
    shared.value = 'Cherry';
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(changedAfterDispose, isFalse,
        reason: 'onChanged must not run for a screen that is gone');
    shared.dispose();
  });

  testWidgets('post-frame initialItem write is skipped after disposal',
      (tester) async {
    // Changing initialItem schedules a post-frame write; tearing the widget
    // down first must not write to the implicit (now disposed) controller.
    await tester.pumpWidget(
      wrap(DropdownFlutter<String>(
          items: items, initialItem: 'Apple', onChanged: (_) {})),
    );
    await tester.pumpWidget(
      wrap(DropdownFlutter<String>(
          items: items, initialItem: 'Banana', onChanged: (_) {})),
    );
    await tester.pumpWidget(wrap(const SizedBox()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('post-frame initialItems write is skipped after disposal',
      (tester) async {
    await tester.pumpWidget(
      wrap(DropdownFlutter<String>.multiSelect(
          items: items, initialItems: const ['Apple'], onListChanged: (_) {})),
    );
    await tester.pumpWidget(
      wrap(DropdownFlutter<String>.multiSelect(
          items: items, initialItems: const ['Banana'], onListChanged: (_) {})),
    );
    await tester.pumpWidget(wrap(const SizedBox()));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
