import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:flutter/material.dart';

const List<String> _fruits = [
  'Apple',
  'Apricot',
  'Banana',
  'Blueberry',
  'Cherry',
  'Cranberry',
  'Mango',
  'Melon',
];

String _firstLetterGroup(String item) =>
    'Starts with "${item[0].toUpperCase()}"';

/// Single-select dropdown wired up with the opt-in modern UX features:
/// grouped sections, keyboard navigation, haptic feedback, recent selections
/// and a custom open/close animation.
class ModernUxDropdown extends StatelessWidget {
  const ModernUxDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<String>(
      hintText: 'Grouped + keyboard + haptics + recents',
      items: _fruits,
      groupBy: _firstLetterGroup,
      enableKeyboardNavigation: true,
      enableHapticFeedback: true,
      recentSelectionsMaxCount: 3,
      animationDuration: const Duration(milliseconds: 220),
      animationCurve: Curves.easeOutCubic,
      decoration: CustomDropdownDecoration(
        listItemDecoration: ListItemDecoration(
          highlightedColor: Colors.blue.withValues(alpha: .12),
        ),
      ),
      onChanged: (value) => log('ModernUxDropdown onChanged: $value'),
    );
  }
}

/// Search dropdown that highlights the matched substring in each result.
class HighlightSearchDropdown extends StatelessWidget {
  const HighlightSearchDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<String>.search(
      hintText: 'Search with match highlighting',
      items: _fruits,
      highlightMatchedText: true,
      enableKeyboardNavigation: true,
      decoration: const CustomDropdownDecoration(
        listItemDecoration: ListItemDecoration(
          searchMatchTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.blue,
          ),
        ),
      ),
      onChanged: (value) => log('HighlightSearchDropdown onChanged: $value'),
    );
  }
}

/// Multi-select dropdown with a "select all / clear all" action row.
class SelectAllDropdown extends StatelessWidget {
  const SelectAllDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<String>.multiSelectSearch(
      hintText: 'Multi-select with select-all',
      items: _fruits,
      showSelectAll: true,
      highlightMatchedText: true,
      enableHapticFeedback: true,
      onListChanged: (value) => log('SelectAllDropdown onListChanged: $value'),
    );
  }
}
