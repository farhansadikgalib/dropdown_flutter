import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:dropdown_flutter_example/model/model.dart';
import 'package:dropdown_flutter_example/theme.dart';
import 'package:flutter/material.dart';

/// Assign several teammates at once. Each row is a rich [MemberTile] with a
/// checkbox, showing that `listItemBuilder` works for multi-select too.
class MultiSelectDropdown extends StatelessWidget {
  const MultiSelectDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Member>.multiSelect(
      hintText: 'Assign teammates',
      items: members,
      initialItems: members.take(2).toList(),
      overlayHeight: 320,
      listItemPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: fieldDecoration(context),
      listItemBuilder: (context, item, isSelected, onItemSelect) {
        return MemberTile(
          member: item,
          trailing: Checkbox(
            value: isSelected,
            visualDensity: VisualDensity.compact,
            onChanged: (_) => onItemSelect(),
          ),
        );
      },
      onListChanged: (value) => log('MultiSelectDropdown: $value'),
    );
  }
}
