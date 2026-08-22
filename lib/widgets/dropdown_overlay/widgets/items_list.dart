part of '../../../custom_dropdown.dart';

class _ItemsList<T> extends StatelessWidget {
  final ScrollController scrollController;
  final T? selectedItem;
  final List<T> selectedItems;
  final List<_Row<T>> rows;
  final Function(T) onItemSelect;
  final bool excludeSelected;
  final EdgeInsets itemsListPadding, listItemPadding;
  final double? listItemHeight;
  final _ListItemBuilder<T> listItemBuilder;
  final ListItemDecoration? decoration;
  final _DropdownType dropdownType;
  final _GroupHeaderBuilder? groupHeaderBuilder;
  final int? highlightedRowIndex;

  const _ItemsList({
    super.key,
    required this.scrollController,
    required this.selectedItem,
    required this.rows,
    required this.onItemSelect,
    required this.excludeSelected,
    required this.itemsListPadding,
    required this.listItemPadding,
    required this.listItemHeight,
    required this.listItemBuilder,
    required this.selectedItems,
    required this.decoration,
    required this.dropdownType,
    required this.groupHeaderBuilder,
    required this.highlightedRowIndex,
  });

  bool get _hasHeaders => rows.any((r) => r is _HeaderRow<T>);

  bool _isSelected(T item) {
    return switch (dropdownType) {
      _DropdownType.singleSelect => !excludeSelected && selectedItem == item,
      _DropdownType.multipleSelect => selectedItems.contains(item),
    };
  }

  Widget _defaultGroupHeader(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(height: 1, color: Colors.grey[300])),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: scrollController,
      child: ListView.builder(
        controller: scrollController,
        shrinkWrap: true,
        padding: itemsListPadding,
        // A fixed row height lets the viewport skip measuring every child.
        // Only safe when there are no group headers, which have their own
        // intrinsic height.
        itemExtent:
            listItemHeight != null && !_hasHeaders ? listItemHeight : null,
        itemCount: rows.length,
        itemBuilder: (_, index) {
          final row = rows[index];
          switch (row) {
            case _HeaderRow<T>():
              return groupHeaderBuilder?.call(context, row.label) ??
                  _defaultGroupHeader(context, row.label);
            case _ItemRow<T>():
              final item = row.item;
              final selected = _isSelected(item);
              final highlighted = highlightedRowIndex == index;
              // Fall back to theme-derived tints so selected/highlighted rows
              // stay legible under a dark theme too.
              final scheme = Theme.of(context).colorScheme;
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final bgColor = highlighted
                  ? (decoration?.highlightedColor ??
                      (isDark
                          ? scheme.primary.withValues(alpha: .24)
                          : ListItemDecoration._defaultHighlightedColor))
                  : selected
                      ? (decoration?.selectedColor ??
                          (isDark
                              ? scheme.onSurface.withValues(alpha: .10)
                              : ListItemDecoration._defaultSelectedColor))
                      : Colors.transparent;
              final row_ = Material(
                color: Colors.transparent,
                child: InkWell(
                  splashColor: decoration?.splashColor ??
                      ListItemDecoration._defaultSplashColor,
                  highlightColor: decoration?.highlightColor ??
                      (isDark
                          ? scheme.onSurface.withValues(alpha: .08)
                          : ListItemDecoration._defaultHighlightColor),
                  onTap: () => onItemSelect(item),
                  child: Ink(
                    color: bgColor,
                    padding: listItemPadding,
                    child: listItemBuilder(
                      context,
                      item,
                      selected,
                      () => onItemSelect(item),
                    ),
                  ),
                ),
              );
              // With headers in the list itemExtent is off, so constrain the
              // row here instead to keep the requested height.
              return listItemHeight != null && _hasHeaders
                  ? SizedBox(height: listItemHeight, child: row_)
                  : row_;
          }
        },
      ),
    );
  }
}
