import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:dropdown_flutter_example/model/model.dart';
import 'package:dropdown_flutter_example/theme.dart';
import 'package:flutter/material.dart';

/// Search over a list long enough that scrolling alone would be tedious.
class SearchDropdown extends StatefulWidget {
  const SearchDropdown({super.key});

  @override
  State<SearchDropdown> createState() => _SearchDropdownState();
}

class _SearchDropdownState extends State<SearchDropdown> {
  String? selectedItem = countries[1];

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<String>.search(
      hintText: 'Select country',
      searchHintText: 'Search countries',
      items: countries,
      initialItem: selectedItem,
      decoration: fieldDecoration(context),
      onChanged: (value) {
        log('SearchDropdown: $value');
        setState(() => selectedItem = value);
      },
    );
  }
}

/// Multi-select over the same searchable list.
class MultiSelectSearchDropdown extends StatelessWidget {
  const MultiSelectSearchDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<String>.multiSelectSearch(
      hintText: 'Select countries',
      searchHintText: 'Search countries',
      items: countries,
      initialItems: countries.take(2).toList(),
      decoration: fieldDecoration(context),
      onListChanged: (value) => log('MultiSelectSearchDropdown: $value'),
    );
  }
}
