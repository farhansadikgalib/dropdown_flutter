import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:dropdown_flutter_example/model/model.dart';
import 'package:dropdown_flutter_example/theme.dart';
import 'package:flutter/material.dart';

/// Works inside a [Form]: `validator` runs on submit like any form field.
class ValidationDropdown extends StatelessWidget {
  ValidationDropdown({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownFlutter<Member>(
            hintText: 'Select a reviewer',
            items: members,
            excludeSelected: false,
            decoration: fieldDecoration(context),
            validator: (value) =>
                value == null ? 'Please select a reviewer' : null,
            onChanged: (value) => log('ValidationDropdown: $value'),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => _formKey.currentState!.validate(),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

/// Multi-select uses `listValidator` instead of `validator`.
class MultiSelectValidationDropdown extends StatelessWidget {
  MultiSelectValidationDropdown({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownFlutter<Member>.multiSelect(
            hintText: 'Select reviewers',
            items: members,
            decoration: fieldDecoration(context),
            listValidator: (value) =>
                value.isEmpty ? 'Please select at least one reviewer' : null,
            onListChanged: (value) =>
                log('MultiSelectValidationDropdown: $value'),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => _formKey.currentState!.validate(),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
