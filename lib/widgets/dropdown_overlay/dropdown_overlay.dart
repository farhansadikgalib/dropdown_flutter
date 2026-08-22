part of '../../custom_dropdown.dart';

const _defaultOverlayIconUp = Icon(Icons.keyboard_arrow_up_rounded, size: 20);

const _defaultHeaderPadding = EdgeInsets.all(16.0);
const _overlayOuterPadding = EdgeInsetsDirectional.only(
  bottom: 12,
  start: 12,
  end: 12,
);
const _defaultOverlayShadowOffset = Offset(0, 6);
const _defaultListItemPadding = EdgeInsets.symmetric(
  vertical: 12,
  horizontal: 16,
);
const _recentSelectionsTitle = 'Recently selected';

class _DropdownOverlay<T> extends StatefulWidget {
  final List<T> items;
  final ScrollController? itemsScrollCtrl;
  final SingleSelectController<T?> selectedItemNotifier;
  final MultiSelectController<T> selectedItemsNotifier;
  final Function(T) onItemSelect;
  final Size size;
  final LayerLink layerLink;
  final VoidCallback hideOverlay;
  final String hintText, searchHintText, noResultFoundText;
  final bool excludeSelected, hideSelectedFieldWhenOpen, canCloseOutsideBounds;
  final _SearchType? searchType;
  final Future<List<T>> Function(String)? futureRequest;
  final Duration? futureRequestDelay;
  final int maxLines;
  final double? overlayHeight;
  final TextStyle? hintStyle, headerStyle, noResultFoundStyle, listItemStyle;
  final EdgeInsets? headerPadding, listItemPadding, itemsListPadding;
  final double? listItemHeight;
  final Widget? searchRequestLoadingIndicator;
  final _ListItemBuilder<T>? listItemBuilder;
  final _HeaderBuilder<T>? headerBuilder;
  final _HeaderListBuilder<T>? headerListBuilder;
  final _HintBuilder? hintBuilder;
  final _NoResultFoundBuilder? noResultFoundBuilder;
  final CustomDropdownDecoration? decoration;
  final _DropdownType dropdownType;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final bool enableHapticFeedback;
  final String Function(T item)? groupBy;
  final _GroupHeaderBuilder? groupHeaderBuilder;
  final int recentSelectionsMaxCount;
  final List<T>? initialRecentItems;
  final ValueChanged<List<T>>? onRecentItemsChanged;
  final bool enableKeyboardNavigation;
  final bool highlightMatchedText;
  final bool showSelectAll;
  final String? selectAllText;
  final String? clearAllText;

  const _DropdownOverlay({
    Key? key,
    required this.items,
    required this.itemsScrollCtrl,
    required this.size,
    required this.layerLink,
    required this.hideOverlay,
    required this.hintText,
    required this.searchHintText,
    required this.selectedItemNotifier,
    required this.selectedItemsNotifier,
    required this.excludeSelected,
    required this.onItemSelect,
    required this.noResultFoundText,
    required this.canCloseOutsideBounds,
    required this.maxLines,
    required this.overlayHeight,
    required this.dropdownType,
    required this.decoration,
    required this.hintStyle,
    required this.headerStyle,
    required this.listItemStyle,
    required this.noResultFoundStyle,
    required this.hideSelectedFieldWhenOpen,
    required this.searchRequestLoadingIndicator,
    required this.headerPadding,
    required this.itemsListPadding,
    required this.listItemPadding,
    required this.listItemHeight,
    required this.headerBuilder,
    required this.hintBuilder,
    required this.searchType,
    required this.futureRequest,
    required this.futureRequestDelay,
    required this.listItemBuilder,
    required this.headerListBuilder,
    required this.noResultFoundBuilder,
    this.animationDuration,
    this.animationCurve,
    this.enableHapticFeedback = false,
    this.groupBy,
    this.groupHeaderBuilder,
    this.recentSelectionsMaxCount = 0,
    this.initialRecentItems,
    this.onRecentItemsChanged,
    this.enableKeyboardNavigation = false,
    this.highlightMatchedText = false,
    this.showSelectAll = false,
    this.selectAllText,
    this.clearAllText,
  });

  @override
  _DropdownOverlayState<T> createState() => _DropdownOverlayState<T>();
}

class _DropdownOverlayState<T> extends State<_DropdownOverlay<T>> {
  bool displayOverly = true, displayOverlayBottom = true;
  bool isSearchRequestLoading = false;
  bool? mayFoundSearchRequestResult;
  late List<T> items;
  late T? selectedItem;
  late List<T> selectedItems;
  late ScrollController scrollController;
  String searchQuery = '';
  int? highlightedRowIndex;
  final key1 = GlobalKey(), key2 = GlobalKey();

  Widget hintBuilder(BuildContext context) {
    return widget.hintBuilder != null
        ? widget.hintBuilder!(context, widget.hintText, true)
        : defaultHintBuilder(context, widget.hintText);
  }

  Widget headerBuilder(BuildContext context) {
    return widget.headerBuilder != null
        ? widget.headerBuilder!(context, selectedItem as T, true)
        : defaultHeaderBuilder(context, item: selectedItem);
  }

  Widget headerListBuilder(BuildContext context) {
    return widget.headerListBuilder != null
        ? widget.headerListBuilder!(context, selectedItems, true)
        : defaultHeaderBuilder(context, items: selectedItems);
  }

  Widget noResultFoundBuilder(BuildContext context) {
    return widget.noResultFoundBuilder != null
        ? widget.noResultFoundBuilder!(context, widget.noResultFoundText)
        : defaultNoResultFoundBuilder(context, widget.noResultFoundText);
  }

  Widget defaultListItemBuilder(
    BuildContext context,
    T result,
    bool isSelected,
    VoidCallback onItemSelect,
  ) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: _itemLabel(context, result),
          ),
        ),
        if (widget.dropdownType == _DropdownType.multipleSelect)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 12.0),
            child: Checkbox(
              onChanged: (_) => onItemSelect(),
              value: isSelected,
              activeColor:
                  widget.decoration?.listItemDecoration?.selectedIconColor,
              side: widget.decoration?.listItemDecoration?.selectedIconBorder,
              shape: widget.decoration?.listItemDecoration?.selectedIconShape,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
            ),
          ),
      ],
    );
  }

  Widget defaultHeaderBuilder(BuildContext context, {T? item, List<T>? items}) {
    return Text(
      items != null ? items.join(', ') : item.toString(),
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
      style: widget.headerStyle ??
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    );
  }

  Widget defaultHintBuilder(BuildContext context, String hint) {
    return Text(
      hint,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: widget.hintStyle ??
          const TextStyle(fontSize: 16, color: Color(0xFFA7A7A7)),
    );
  }

  Widget defaultNoResultFoundBuilder(BuildContext context, String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          text,
          style: widget.noResultFoundStyle ?? const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollController = widget.itemsScrollCtrl ?? ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final render1 = key1.currentContext?.findRenderObject() as RenderBox;
      final render2 = key2.currentContext?.findRenderObject() as RenderBox;
      final screenHeight = MediaQuery.of(context).size.height;
      double y = render1.localToGlobal(Offset.zero).dy;
      if (screenHeight - y < render2.size.height) {
        displayOverlayBottom = false;
        setState(() {});
      }
    });

    selectedItem = widget.selectedItemNotifier.value;
    selectedItems = widget.selectedItemsNotifier.value;

    widget.selectedItemNotifier.addListener(singleSelectListener);
    widget.selectedItemsNotifier.addListener(multiSelectListener);

    if (widget.excludeSelected &&
        widget.items.length > 1 &&
        selectedItem != null) {
      T value = selectedItem as T;
      items = widget.items.where((item) => item != value).toList();
    } else {
      items = widget.items;
    }
  }

  @override
  void dispose() {
    widget.selectedItemNotifier.removeListener(singleSelectListener);
    widget.selectedItemsNotifier.removeListener(multiSelectListener);

    if (widget.itemsScrollCtrl == null) {
      scrollController.dispose();
    }
    super.dispose();
  }

  void _onQueryChanged(String query) {
    setState(() {
      searchQuery = query;
      highlightedRowIndex = null;
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.escape) {
      setState(() => displayOverly = false);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowDown) {
      _moveHighlight(1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowUp) {
      _moveHighlight(-1);
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      final rows = _buildRows();
      final idx = highlightedRowIndex;
      if (idx != null && idx >= 0 && idx < rows.length) {
        final row = rows[idx];
        if (row is _ItemRow<T>) {
          onItemSelect(row.item);
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  void _moveHighlight(int delta) {
    final rows = _buildRows();
    final itemIndexes = [
      for (var i = 0; i < rows.length; i++)
        if (rows[i] is _ItemRow<T>) i,
    ];
    if (itemIndexes.isEmpty) return;
    int pos;
    if (highlightedRowIndex == null ||
        !itemIndexes.contains(highlightedRowIndex)) {
      pos = delta > 0 ? 0 : itemIndexes.length - 1;
    } else {
      final current = itemIndexes.indexOf(highlightedRowIndex!);
      pos = (current + delta).clamp(0, itemIndexes.length - 1);
    }
    final newRowIndex = itemIndexes[pos];
    setState(() => highlightedRowIndex = newRowIndex);
    _ensureRowVisible(newRowIndex);
  }

  void _ensureRowVisible(int rowIndex) {
    if (!scrollController.hasClients) return;
    final pad = widget.listItemPadding ?? _defaultListItemPadding;
    final rowHeight = pad.vertical + 24.0;
    final target = rowIndex * rowHeight;
    final pos = scrollController.position;
    final viewStart = pos.pixels;
    final viewEnd = viewStart + pos.viewportDimension;
    double? to;
    if (target < viewStart) {
      to = target;
    } else if (target + rowHeight > viewEnd) {
      to = target + rowHeight - pos.viewportDimension;
    }
    if (to != null) {
      scrollController.animateTo(
        to.clamp(pos.minScrollExtent, pos.maxScrollExtent),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
      );
    }
  }

  /// A "select all / clear all" action row for multi-select dropdowns.
  Widget _selectAllRow() {
    final allItems = widget.items;
    final selectedSet = selectedItems.toSet();
    final selectedCount = allItems.where(selectedSet.contains).length;
    final allSelected = allItems.isNotEmpty && selectedCount == allItems.length;
    final noneSelected = selectedCount == 0;
    final triValue = allSelected ? true : (noneSelected ? false : null);

    void toggle() {
      if (widget.enableHapticFeedback) {
        HapticFeedback.selectionClick();
      }
      final next = allSelected ? <T>[] : List<T>.of(allItems);
      widget.selectedItemsNotifier.value = next;
      setState(() => selectedItems = next);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: toggle,
        child: Padding(
          padding: widget.listItemPadding ?? _defaultListItemPadding,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  allSelected
                      ? (widget.clearAllText ?? 'Clear all')
                      : (widget.selectAllText ?? 'Select all'),
                  style: (widget.listItemStyle ?? const TextStyle(fontSize: 16))
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 12.0),
                child: Checkbox(
                  tristate: true,
                  value: triValue,
                  onChanged: (_) => toggle(),
                  activeColor:
                      widget.decoration?.listItemDecoration?.selectedIconColor,
                  side:
                      widget.decoration?.listItemDecoration?.selectedIconBorder,
                  shape:
                      widget.decoration?.listItemDecoration?.selectedIconShape,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: const VisualDensity(
                    horizontal: VisualDensity.minimumDensity,
                    vertical: VisualDensity.minimumDensity,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the item label, optionally highlighting the searched substring.
  Widget _itemLabel(BuildContext context, T result) {
    final text = result.toString();
    final style = widget.listItemStyle ?? const TextStyle(fontSize: 16);
    final query = searchQuery.trim();

    if (!widget.highlightMatchedText || query.isEmpty) {
      return Text(
        text,
        maxLines: widget.maxLines,
        overflow: TextOverflow.ellipsis,
        style: style,
      );
    }

    final matchStyle = style.merge(
      widget.decoration?.listItemDecoration?.searchMatchTextStyle ??
          ListItemDecoration._defaultSearchMatchTextStyle,
    );
    final lower = text.toLowerCase();
    final q = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    int idx;
    while ((idx = lower.indexOf(q, start)) != -1) {
      if (idx > start) {
        spans.add(TextSpan(text: text.substring(start, idx)));
      }
      spans.add(
        TextSpan(text: text.substring(idx, idx + q.length), style: matchStyle),
      );
      start = idx + q.length;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return Text.rich(
      TextSpan(style: style, children: spans),
      maxLines: widget.maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  void singleSelectListener() {
    if (mounted) {
      selectedItem = widget.selectedItemNotifier.value;
    }
  }

  void multiSelectListener() {
    if (mounted) {
      selectedItems = widget.selectedItemsNotifier.value;
    }
  }

  /// Builds the flat list of rows shown in the overlay, interleaving optional
  /// "recently selected" and group-header rows with selectable item rows.
  List<_Row<T>> _buildRows() {
    final rows = <_Row<T>>[];

    final recentSource = widget.initialRecentItems ?? const [];
    final showRecents = widget.recentSelectionsMaxCount > 0 &&
        recentSource.isNotEmpty &&
        searchQuery.isEmpty;
    if (showRecents) {
      final recents =
          recentSource.where((e) => widget.items.contains(e)).toList();
      if (recents.isNotEmpty) {
        rows.add(_HeaderRow<T>(_recentSelectionsTitle));
        rows.addAll(recents.map((e) => _ItemRow<T>(e)));
      }
    }

    if (widget.groupBy != null) {
      final groups = <String, List<T>>{};
      for (final item in items) {
        (groups[widget.groupBy!(item)] ??= <T>[]).add(item);
      }
      groups.forEach((label, groupItems) {
        rows.add(_HeaderRow<T>(label));
        rows.addAll(groupItems.map((e) => _ItemRow<T>(e)));
      });
    } else {
      rows.addAll(items.map((e) => _ItemRow<T>(e)));
    }

    return rows;
  }

  void onItemSelect(T value) {
    if (widget.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    widget.onItemSelect(value);
    if (widget.dropdownType == _DropdownType.singleSelect) {
      setState(() => displayOverly = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // decoration
    final decoration = widget.decoration;

    // search availability check
    final onSearch = widget.searchType != null;

    // overlay offset
    final overlayOffset = Offset(-12, displayOverlayBottom ? 0 : 64);

    // list padding
    final listPadding =
        onSearch ? const EdgeInsets.only(top: 8) : EdgeInsets.zero;

    // rows (items + optional group/recent headers)
    final rows = _buildRows();

    // items list
    final list = items.isNotEmpty
        ? _ItemsList<T>(
            scrollController: scrollController,
            listItemBuilder: widget.listItemBuilder ?? defaultListItemBuilder,
            excludeSelected: items.length > 1 ? widget.excludeSelected : false,
            selectedItem: selectedItem,
            selectedItems: selectedItems,
            rows: rows,
            itemsListPadding: widget.itemsListPadding ?? listPadding,
            listItemPadding: widget.listItemPadding ?? _defaultListItemPadding,
            listItemHeight: widget.listItemHeight,
            onItemSelect: onItemSelect,
            decoration: decoration?.listItemDecoration,
            dropdownType: widget.dropdownType,
            groupHeaderBuilder: widget.groupHeaderBuilder,
            highlightedRowIndex: highlightedRowIndex,
          )
        : (mayFoundSearchRequestResult != null &&
                    !mayFoundSearchRequestResult!) ||
                widget.searchType == _SearchType.onListData
            ? noResultFoundBuilder(context)
            : const SizedBox(height: 12);

    final child = Stack(
      children: [
        Positioned(
          width: widget.size.width + 24,
          child: CompositedTransformFollower(
            link: widget.layerLink,
            followerAnchor:
                displayOverlayBottom ? Alignment.topLeft : Alignment.bottomLeft,
            showWhenUnlinked: false,
            offset: overlayOffset,
            child: Container(
              key: key1,
              margin: _overlayOuterPadding,
              decoration: BoxDecoration(
                color: decoration?.expandedFillColor ??
                    CustomDropdownDecoration._defaultFillColor,
                border: decoration?.expandedBorder,
                borderRadius:
                    decoration?.expandedBorderRadius ?? _defaultBorderRadius,
                boxShadow: decoration?.expandedShadow ??
                    [
                      BoxShadow(
                        blurRadius: 24.0,
                        color: Colors.black.withValues(alpha: .08),
                        offset: _defaultOverlayShadowOffset,
                      ),
                    ],
              ),
              child: Material(
                color: Colors.transparent,
                child: _AnimatedSection(
                  animationDismissed: widget.hideOverlay,
                  expand: displayOverly,
                  alignment: displayOverlayBottom
                      ? Alignment.bottomCenter
                      : Alignment.topCenter,
                  duration: widget.animationDuration,
                  curve: widget.animationCurve,
                  child: SizedBox(
                    key: key2,
                    height: items.length > 4
                        ? widget.overlayHeight ?? (onSearch ? 270 : 225)
                        : null,
                    child: ClipRRect(
                      borderRadius: decoration?.expandedBorderRadius ??
                          _defaultBorderRadius,
                      child:
                          NotificationListener<OverscrollIndicatorNotification>(
                        onNotification: (notification) {
                          notification.disallowIndicator();
                          return true;
                        },
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            scrollbarTheme:
                                decoration?.overlayScrollbarDecoration ??
                                    ScrollbarThemeData(
                                      thumbVisibility: WidgetStateProperty.all(
                                        true,
                                      ),
                                      thickness: WidgetStateProperty.all(5),
                                      radius: const Radius.circular(4),
                                      thumbColor: WidgetStateProperty.all(
                                        Colors.grey[300],
                                      ),
                                    ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!widget.hideSelectedFieldWhenOpen)
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    setState(() => displayOverly = false);
                                  },
                                  child: Padding(
                                    padding: widget.headerPadding ??
                                        _defaultHeaderPadding,
                                    child: Row(
                                      children: [
                                        if (widget.decoration?.prefixIcon !=
                                            null) ...[
                                          widget.decoration!.prefixIcon!,
                                          const SizedBox(width: 12),
                                        ],
                                        Expanded(
                                          child: switch (widget.dropdownType) {
                                            _DropdownType.singleSelect =>
                                              selectedItem != null
                                                  ? headerBuilder(context)
                                                  : hintBuilder(context),
                                            _DropdownType.multipleSelect =>
                                              selectedItems.isNotEmpty
                                                  ? headerListBuilder(context)
                                                  : hintBuilder(context),
                                          },
                                        ),
                                        const SizedBox(width: 12),
                                        decoration?.expandedSuffixIcon ??
                                            _defaultOverlayIconUp,
                                      ],
                                    ),
                                  ),
                                ),
                              if (onSearch &&
                                  widget.searchType == _SearchType.onListData)
                                if (!widget.hideSelectedFieldWhenOpen)
                                  _SearchField<T>.forListData(
                                    items: widget.items,
                                    searchHintText: widget.searchHintText,
                                    onQueryChanged: _onQueryChanged,
                                    onSearchedItems: (val) {
                                      setState(() => items = val);
                                    },
                                    decoration:
                                        decoration?.searchFieldDecoration,
                                  )
                                else
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      setState(() => displayOverly = false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        top: 12.0,
                                        start: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          if (widget.decoration?.prefixIcon !=
                                              null) ...[
                                            widget.decoration!.prefixIcon!,
                                            const SizedBox(width: 12),
                                          ],
                                          Expanded(
                                            child: _SearchField<T>.forListData(
                                              items: widget.items,
                                              searchHintText:
                                                  widget.searchHintText,
                                              onQueryChanged: _onQueryChanged,
                                              onSearchedItems: (val) {
                                                setState(() => items = val);
                                              },
                                              decoration: decoration
                                                  ?.searchFieldDecoration,
                                            ),
                                          ),
                                          decoration?.expandedSuffixIcon ??
                                              _defaultOverlayIconUp,
                                          const SizedBox(width: 14),
                                        ],
                                      ),
                                    ),
                                  )
                              else if (onSearch &&
                                  widget.searchType ==
                                      _SearchType.onRequestData)
                                if (!widget.hideSelectedFieldWhenOpen)
                                  _SearchField<T>.forRequestData(
                                    items: widget.items,
                                    searchHintText: widget.searchHintText,
                                    onQueryChanged: _onQueryChanged,
                                    onFutureRequestLoading: (val) {
                                      setState(() {
                                        isSearchRequestLoading = val;
                                      });
                                    },
                                    futureRequest: widget.futureRequest,
                                    futureRequestDelay:
                                        widget.futureRequestDelay,
                                    onSearchedItems: (val) {
                                      setState(() => items = val);
                                    },
                                    mayFoundResult: (val) =>
                                        mayFoundSearchRequestResult = val,
                                    decoration:
                                        decoration?.searchFieldDecoration,
                                  )
                                else
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      setState(() => displayOverly = false);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        top: 12.0,
                                        start: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          if (widget.decoration?.prefixIcon !=
                                              null) ...[
                                            widget.decoration!.prefixIcon!,
                                            const SizedBox(width: 12),
                                          ],
                                          Expanded(
                                            child:
                                                _SearchField<T>.forRequestData(
                                              items: widget.items,
                                              searchHintText:
                                                  widget.searchHintText,
                                              onQueryChanged: _onQueryChanged,
                                              onFutureRequestLoading: (val) {
                                                setState(() {
                                                  isSearchRequestLoading = val;
                                                });
                                              },
                                              futureRequest:
                                                  widget.futureRequest,
                                              futureRequestDelay:
                                                  widget.futureRequestDelay,
                                              onSearchedItems: (val) {
                                                setState(() => items = val);
                                              },
                                              mayFoundResult: (val) =>
                                                  mayFoundSearchRequestResult =
                                                      val,
                                              decoration: decoration
                                                  ?.searchFieldDecoration,
                                            ),
                                          ),
                                          decoration?.expandedSuffixIcon ??
                                              _defaultOverlayIconUp,
                                          const SizedBox(width: 14),
                                        ],
                                      ),
                                    ),
                                  ),
                              if (widget.showSelectAll &&
                                  widget.dropdownType ==
                                      _DropdownType.multipleSelect &&
                                  widget.items.isNotEmpty)
                                _selectAllRow(),
                              if (isSearchRequestLoading)
                                widget.searchRequestLoadingIndicator ??
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 20.0,
                                      ),
                                      child: Center(
                                        child: SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      ),
                                    )
                              else
                                items.length > 4 ? Expanded(child: list) : list,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    final content = widget.canCloseOutsideBounds
        ? Stack(
            children: [
              GestureDetector(
                onTap: () => setState(() => displayOverly = false),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.transparent,
                ),
              ),
              child,
            ],
          )
        : child;

    if (!widget.enableKeyboardNavigation) return content;

    return Focus(
      autofocus: !onSearch,
      onKeyEvent: _handleKeyEvent,
      child: content,
    );
  }
}
