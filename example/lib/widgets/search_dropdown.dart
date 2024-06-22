import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';

const _list = [
  'Bangladesh',
  'Australia',
  'Malaysia',
  'America',
  'Canada',
  'India',
  'Pakistan',
  'Sri Lanka',
  'Nepal',
  'Bhutan',
  'Japan',
];

class SearchDropdown extends StatefulWidget {
  const SearchDropdown({Key? key}) : super(key: key);

  @override
  State<SearchDropdown> createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  String? selectedItem = _list[2];

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<String>.search(
      hintText: 'Select Country',
      items: _list,
      initialItem: selectedItem,
      overlayHeight: 342,
      onChanged: (value) {
        log('SearchDropdown onChanged value: $value');
        setState(() {
          selectedItem = value;
        });
      },
    );
  }
}

class MultiSelectSearchDropdown extends StatelessWidget {
  const MultiSelectSearchDropdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<String>.multiSelectSearch(
      hintText: 'Select Country',
      items: _list,
      onListChanged: (value) {
        log('MultiSelectSearchDropdown onChanged value: $value');
      },
    );
  }
}
