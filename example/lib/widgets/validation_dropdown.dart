import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:dropdown_flutter_example/model/model.dart';
import 'package:flutter/material.dart';

class ValidationDropdown extends StatelessWidget {
  ValidationDropdown({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownFlutter<JobType>(
            hintText: 'Select job role',
            items: jobItems,
            excludeSelected: false,
            onChanged: (value) {
              log('ValidationDropdown onChanged value: $value');
            },
            validator: (value) {
              if (value == null) {
                return "Must not be null";
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MultiSelectValidationDropdown extends StatelessWidget {
  MultiSelectValidationDropdown({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownFlutter<JobType>.multiSelect(
            hintText: 'Select job role',
            items: jobItems,
            onListChanged: (value) {
              log('MultiSelectValidationDropdown onChanged value: $value');
            },
            listValidator: (value) {
              if (value.isEmpty) {
                return "Must not be null";
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
