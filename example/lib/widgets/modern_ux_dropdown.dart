import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:dropdown_flutter_example/model/model.dart';
import 'package:dropdown_flutter_example/theme.dart';
import 'package:flutter/material.dart';

/// Grouped sections, keyboard navigation, haptics and recent selections —
/// all opt-in, combined here on a single dropdown.
class ModernUxDropdown extends StatelessWidget {
  const ModernUxDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Member>(
      hintText: 'Pick a teammate',
      items: members,
      groupBy: groupByTeam,
      overlayHeight: 320,
      enableKeyboardNavigation: true,
      enableHapticFeedback: true,
      recentSelectionsMaxCount: 3,
      animationDuration: const Duration(milliseconds: 220),
      animationCurve: Curves.easeOutCubic,
      decoration: fieldDecoration(
        context,
        listItemDecoration: ListItemDecoration(
          highlightedColor: brandSeed.withValues(alpha: .12),
        ),
      ),
      onChanged: (value) => log('ModernUxDropdown: $value'),
    );
  }
}

/// Search that emphasises the matched substring in every result.
class HighlightSearchDropdown extends StatelessWidget {
  const HighlightSearchDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<String>.search(
      hintText: 'Search countries',
      searchHintText: 'Try "ind"',
      items: countries,
      highlightMatchedText: true,
      enableKeyboardNavigation: true,
      decoration: fieldDecoration(
        context,
        listItemDecoration: const ListItemDecoration(
          searchMatchTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            color: brandSeed,
          ),
        ),
      ),
      onChanged: (value) => log('HighlightSearchDropdown: $value'),
    );
  }
}

/// Multi-select with a select-all / clear-all action row above the list.
class SelectAllDropdown extends StatelessWidget {
  const SelectAllDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<String>.multiSelectSearch(
      hintText: 'Select countries',
      searchHintText: 'Search countries',
      items: countries,
      showSelectAll: true,
      highlightMatchedText: true,
      enableHapticFeedback: true,
      decoration: fieldDecoration(context),
      onListChanged: (value) => log('SelectAllDropdown: $value'),
    );
  }
}
