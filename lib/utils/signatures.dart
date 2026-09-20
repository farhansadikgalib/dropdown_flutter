part of '../custom_dropdown.dart';

/// Builds a selectable row, including any custom selection control.
typedef DropdownListItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  bool isSelected,
  VoidCallback onItemSelect,
);

/// Builds the header for a selected single item.
typedef DropdownHeaderBuilder<T> = Widget Function(
    BuildContext context, T selectedItem, bool enabled);

/// Builds the header for a list of selected items.
typedef DropdownHeaderListBuilder<T> = Widget Function(
    BuildContext context, List<T> selectedItems, bool enabled);

/// Builds the placeholder displayed when no item is selected.
typedef DropdownHintBuilder = Widget Function(
    BuildContext context, String hint, bool enabled);

/// Builds the message displayed for an empty result set.
typedef DropdownNoResultFoundBuilder = Widget Function(
    BuildContext context, String text);

/// Builds a section heading for a group of items.
typedef DropdownGroupHeaderBuilder = Widget Function(
    BuildContext context, String group);

/// Internal row model for the overlay list. Lets the list interleave section
/// headers (for grouping and recent selections) with selectable items while
/// keeping the plain-item fast path unchanged.
sealed class _Row<T> {
  const _Row();
}

class _ItemRow<T> extends _Row<T> {
  final T item;
  const _ItemRow(this.item);
}

class _HeaderRow<T> extends _Row<T> {
  final String label;
  const _HeaderRow(this.label);
}

/// Builds a recoverable remote-search error without exposing raw errors by default.
typedef DropdownSearchErrorBuilder = Widget Function(
    BuildContext context, Object error, VoidCallback retry);
