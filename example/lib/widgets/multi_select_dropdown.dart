import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:dropdown_flutter_example/model/model.dart';
import 'package:flutter/material.dart';

class MultiSelectDropdown extends StatelessWidget {
  const MultiSelectDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<JobType>.multiSelect(
      items: jobItems,
      initialItems: jobItems.take(2).toList(),
      onListChanged: (value) {
        log('MultiSelectDropdown onChanged value: $value');
      },
    );
  }
}
