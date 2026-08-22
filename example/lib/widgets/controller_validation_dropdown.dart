import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:dropdown_flutter_example/model/model.dart';
import 'package:dropdown_flutter_example/theme.dart';
import 'package:flutter/material.dart';

/// A [SingleSelectController] lets you read and set the selection from code —
/// here a clear button wired into the suffix icon.
class ControllerValidationDropdown extends StatefulWidget {
  const ControllerValidationDropdown({super.key});

  @override
  State<ControllerValidationDropdown> createState() =>
      _ControllerValidationDropdownState();
}

class _ControllerValidationDropdownState
    extends State<ControllerValidationDropdown> {
  final formKey = GlobalKey<FormState>();
  final controller = SingleSelectController<Member>(members[0]);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownFlutter<Member>(
            controller: controller,
            hintText: 'Select an owner',
            items: members,
            decoration: fieldDecoration(context).copyWith(
              closedSuffixIcon: InkWell(
                onTap: controller.clear,
                child: const Icon(Icons.close, size: 20),
              ),
            ),
            validator: (value) =>
                value == null ? 'Please select an owner' : null,
            onChanged: (value) => log('ControllerValidationDropdown: $value'),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => formKey.currentState!.validate(),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
