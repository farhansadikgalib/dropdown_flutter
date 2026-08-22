import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:dropdown_flutter_example/model/model.dart';
import 'package:dropdown_flutter_example/theme.dart';
import 'package:flutter/material.dart';

/// A [MultiSelectController] exposes `add`, `remove` and `clear`, so the
/// selection can be driven from anywhere in your app.
class MultiSelectControllerDropdown extends StatefulWidget {
  const MultiSelectControllerDropdown({super.key});

  @override
  State<MultiSelectControllerDropdown> createState() =>
      _MultiSelectControllerDropdownState();
}

class _MultiSelectControllerDropdownState
    extends State<MultiSelectControllerDropdown> {
  final controller = MultiSelectController<Member>([members[0]]);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownFlutter<Member>.multiSelect(
          multiSelectController: controller,
          hintText: 'Assign teammates',
          items: members,
          decoration: fieldDecoration(context),
          onListChanged: (value) =>
              log('MultiSelectControllerDropdown: $value'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.clear,
                child: const Text('Clear'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  final first = members[0];
                  if (controller.value.contains(first)) {
                    controller.remove(first);
                  } else {
                    controller.add(first);
                  }
                },
                child: const Text('Toggle first'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
