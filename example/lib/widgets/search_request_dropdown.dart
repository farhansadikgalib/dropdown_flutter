import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:dropdown_flutter_example/model/model.dart';
import 'package:dropdown_flutter_example/theme.dart';
import 'package:flutter/material.dart';

/// Stands in for a real API call.
Future<List<Member>> _searchMembers(String query) async {
  await Future.delayed(const Duration(milliseconds: 700));
  return members.where((m) => m.filter(query)).toList();
}

/// Results fetched asynchronously as the user types, with a debounce.
class SearchRequestDropdown extends StatelessWidget {
  const SearchRequestDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Member>.searchRequest(
      hintText: 'Search directory',
      searchHintText: 'Try "engineer"',
      futureRequest: _searchMembers,
      futureRequestDelay: const Duration(milliseconds: 300),
      listItemPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: fieldDecoration(context),
      listItemBuilder: (context, item, isSelected, onItemSelect) =>
          MemberTile(member: item),
      searchRequestLoadingIndicator: const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      ),
      onChanged: (value) => log('SearchRequestDropdown: $value'),
    );
  }
}

/// The same async search, selecting several people.
class MultiSelectSearchRequestDropdown extends StatelessWidget {
  const MultiSelectSearchRequestDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Member>.multiSelectSearchRequest(
      hintText: 'Search and assign',
      searchHintText: 'Try "design"',
      futureRequest: _searchMembers,
      futureRequestDelay: const Duration(milliseconds: 300),
      decoration: fieldDecoration(context),
      onListChanged: (value) => log('MultiSelectSearchRequestDropdown: $value'),
    );
  }
}
