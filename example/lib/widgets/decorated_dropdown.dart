import 'dart:developer';

import 'package:dropdown_flutter/custom_dropdown.dart';
import 'package:dropdown_flutter_example/model/model.dart';
import 'package:flutter/material.dart';

const _ink = Color(0xFF1E1B33);
const _accent = Color(0xFF8B7BF7);

/// Everything restyled: fill, borders, shadow, icons, the search field and the
/// rows themselves. Shows how far `decoration` plus the builders can go.
class DecoratedDropdown extends StatelessWidget {
  const DecoratedDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Member>.search(
      hintText: 'Select a teammate',
      searchHintText: 'Search by name or role',
      items: members,
      initialItem: members[2],
      excludeSelected: false,
      overlayHeight: 316,
      closedHeaderPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      listItemPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      onChanged: (value) => log('DecoratedDropdown: $value'),
      headerBuilder: (context, selectedItem, enabled) => Row(
        children: [
          MemberAvatar(member: selectedItem, size: 30),
          const SizedBox(width: 12),
          Text(
            selectedItem.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      listItemBuilder: (context, item, isSelected, onItemSelect) => Row(
        children: [
          MemberAvatar(member: item, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: isSelected ? _accent : Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  item.role,
                  style: const TextStyle(color: Colors.white60, fontSize: 12.5),
                ),
              ],
            ),
          ),
          if (isSelected) const Icon(Icons.check, color: _accent, size: 18),
        ],
      ),
      decoration: CustomDropdownDecoration(
        closedFillColor: _ink,
        expandedFillColor: _ink,
        closedBorderRadius: BorderRadius.circular(16),
        expandedBorderRadius: BorderRadius.circular(16),
        closedShadow: [
          BoxShadow(
            offset: const Offset(0, 6),
            color: _accent.withValues(alpha: .28),
            blurRadius: 18,
          ),
        ],
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 15),
        closedSuffixIcon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: _accent,
        ),
        expandedSuffixIcon: const Icon(
          Icons.keyboard_arrow_up_rounded,
          color: _accent,
        ),
        noResultFoundStyle: const TextStyle(color: Colors.white70),
        searchFieldDecoration: SearchFieldDecoration(
          fillColor: Colors.white.withValues(alpha: .07),
          prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 20),
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
          textStyle: const TextStyle(color: Colors.white, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _accent),
          ),
          suffixIcon: (onClear) => GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close, color: Colors.white54, size: 18),
          ),
        ),
        listItemDecoration: ListItemDecoration(
          selectedColor: Colors.white.withValues(alpha: .06),
          highlightColor: Colors.white.withValues(alpha: .04),
        ),
      ),
    );
  }
}

/// The same dark treatment applied to a multi-select.
class MultiSelectDecoratedDropdown extends StatelessWidget {
  const MultiSelectDecoratedDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownFlutter<Member>.multiSelectSearch(
      hintText: 'Assign reviewers',
      searchHintText: 'Search by name or role',
      items: members,
      initialItems: [members[1]],
      maxlines: 2,
      closedHeaderPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      listItemPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      onListChanged: (value) => log('MultiSelectDecoratedDropdown: $value'),
      listItemBuilder: (context, item, isSelected, onItemSelect) => Row(
        children: [
          MemberAvatar(member: item, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          Checkbox(
            value: isSelected,
            visualDensity: VisualDensity.compact,
            side: const BorderSide(color: Colors.white38),
            activeColor: _accent,
            onChanged: (_) => onItemSelect(),
          ),
        ],
      ),
      decoration: CustomDropdownDecoration(
        closedFillColor: _ink,
        expandedFillColor: _ink,
        closedBorderRadius: BorderRadius.circular(16),
        expandedBorderRadius: BorderRadius.circular(16),
        closedShadow: [
          BoxShadow(
            offset: const Offset(0, 6),
            color: _accent.withValues(alpha: .28),
            blurRadius: 18,
          ),
        ],
        hintStyle: const TextStyle(color: Colors.white54, fontSize: 15),
        headerStyle: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        prefixIcon: const Icon(Icons.group_outlined, color: _accent, size: 20),
        closedSuffixIcon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: _accent,
        ),
        expandedSuffixIcon: const Icon(
          Icons.keyboard_arrow_up_rounded,
          color: _accent,
        ),
        noResultFoundStyle: const TextStyle(color: Colors.white70),
        searchFieldDecoration: SearchFieldDecoration(
          fillColor: Colors.white.withValues(alpha: .07),
          prefixIcon: const Icon(Icons.search, color: Colors.white54, size: 20),
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
          textStyle: const TextStyle(color: Colors.white, fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _accent),
          ),
          suffixIcon: (onClear) => GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close, color: Colors.white54, size: 18),
          ),
        ),
        listItemDecoration: ListItemDecoration(
          selectedColor: Colors.white.withValues(alpha: .06),
          highlightColor: Colors.white.withValues(alpha: .04),
        ),
      ),
    );
  }
}
