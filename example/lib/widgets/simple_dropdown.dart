import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:dropdown_flutter_example/model/model.dart';
import 'package:dropdown_flutter_example/theme.dart';
import 'package:flutter/material.dart';

/// The simplest case: a short, closed list of strings.
class SimpleDropdown extends StatelessWidget {
  const SimpleDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<String>(
      hintText: 'Select priority',
      items: priorities,
      initialItem: priorities[1],
      excludeSelected: false,
      decoration: fieldDecoration(context),
      onChanged: (value) => log('SimpleDropdown: $value'),
    );
  }
}
