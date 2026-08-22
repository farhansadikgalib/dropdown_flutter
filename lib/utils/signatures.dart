part of '../custom_dropdown.dart';

typedef _ListItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  bool isSelected,
  VoidCallback onItemSelect,
);
typedef _HeaderBuilder<T> = Widget Function(
    BuildContext context, T selectedItem, bool enabled);
typedef _HeaderListBuilder<T> = Widget Function(
    BuildContext context, List<T> selectedItems, bool enabled);
typedef _HintBuilder = Widget Function(
    BuildContext context, String hint, bool enabled);
typedef _NoResultFoundBuilder = Widget Function(
    BuildContext context, String text);
typedef _GroupHeaderBuilder = Widget Function(
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
