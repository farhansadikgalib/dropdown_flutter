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
  final Offset anchorOffset;
  final bool closeOnClear;
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
  final DropdownListItemBuilder<T>? listItemBuilder;
  final DropdownHeaderBuilder<T>? headerBuilder;
  final DropdownHeaderListBuilder<T>? headerListBuilder;
  final DropdownHintBuilder? hintBuilder;
  final DropdownNoResultFoundBuilder? noResultFoundBuilder;
  final CustomDropdownDecoration? decoration;
  final _DropdownType dropdownType;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final bool enableHapticFeedback;
  final String Function(T item)? groupBy;
  final DropdownGroupHeaderBuilder? groupHeaderBuilder;
  final int recentSelectionsMaxCount;
  final List<T>? initialRecentItems;
  final ValueChanged<List<T>>? onRecentItemsChanged;
  final bool enableKeyboardNavigation;
  final bool highlightMatchedText;
  final bool showSelectAll;
  final String? selectAllText;
  final String? clearAllText;
  final DropdownSearchErrorBuilder? searchRequestErrorBuilder;
  final bool showMultiSelectFooter;
  final String? doneText;

  const _DropdownOverlay({
    Key? key,
    required this.items,
    required this.itemsScrollCtrl,
    required this.size,
    required this.anchorOffset,
    required this.closeOnClear,
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
    this.searchRequestErrorBuilder,
    this.showMultiSelectFooter = true,
    this.doneText,
  });

  @override
  _DropdownOverlayState<T> createState() => _DropdownOverlayState<T>();
}

class _DropdownOverlayState<T> extends State<_DropdownOverlay<T>> {
  bool displayOverly = true, displayOverlayBottom = true;
  bool isSearchRequestLoading = false;
  Object? _requestError;
  final _searchKey = GlobalKey<_SearchFieldState<T>>();
  late List<T> items;
  late T? selectedItem;
  late List<T> selectedItems;
  late ScrollController scrollController;
  String searchQuery = '';
  int? highlightedRowIndex;
  final _rowKeys = <int, GlobalKey>{};

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
          TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
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
    selectedItem = widget.selectedItemNotifier.value;
    selectedItems = widget.selectedItemsNotifier.value;

    widget.selectedItemNotifier.addListener(singleSelectListener);
    widget.selectedItemsNotifier.addListener(multiSelectListener);

    items = List<T>.of(widget.items);
  }

  @override
  void didUpdateWidget(covariant _DropdownOverlay<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItemNotifier != widget.selectedItemNotifier) {
      oldWidget.selectedItemNotifier.removeListener(singleSelectListener);
      widget.selectedItemNotifier.addListener(singleSelectListener);
      setState(() => selectedItem = widget.selectedItemNotifier.value);
    }
    if (oldWidget.selectedItemsNotifier != widget.selectedItemsNotifier) {
      oldWidget.selectedItemsNotifier.removeListener(multiSelectListener);
      widget.selectedItemsNotifier.addListener(multiSelectListener);
      setState(() => selectedItems = widget.selectedItemsNotifier.value);
    }
    if (oldWidget.itemsScrollCtrl != widget.itemsScrollCtrl) {
      if (oldWidget.itemsScrollCtrl == null) scrollController.dispose();
      scrollController = widget.itemsScrollCtrl ?? ScrollController();
    }
    if (!listEquals(oldWidget.items, widget.items)) {
      if (widget.searchType != _SearchType.onRequestData ||
          searchQuery.isEmpty) {
        items = widget.items
            .where((item) =>
                searchQuery.isEmpty ||
                (item is CustomDropdownListFilter
                    ? item.filter(searchQuery)
                    : item
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase())))
            .toList();
      }
      highlightedRowIndex = null;
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
    if (!widget.enableKeyboardNavigation ||
        isSearchRequestLoading ||
        _requestError != null) {
      return KeyEventResult.ignored;
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
    _ensureRowVisible(newRowIndex, delta);
  }

  void _ensureRowVisible(int rowIndex, int direction) {
    if (!scrollController.hasClients) return;
    final rowContext = _rowKeys[rowIndex]?.currentContext;
    if (rowContext != null) {
      Scrollable.ensureVisible(
        rowContext,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        alignmentPolicy: direction > 0
            ? ScrollPositionAlignmentPolicy.keepVisibleAtEnd
            : ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
      return;
    }
    final pad = widget.listItemPadding ?? _defaultListItemPadding;
    final rowHeight = widget.listItemHeight ?? pad.vertical + 24.0;
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
    final allItems = items.toSet().toList();
    final selectedSet = selectedItems.toSet();
    final selectedCount = allItems.where(selectedSet.contains).length;
    final allSelected = allItems.isNotEmpty && selectedCount == allItems.length;
    final noneSelected = selectedCount == 0;
    final triValue = allSelected ? true : (noneSelected ? false : null);

    void toggle() {
      if (widget.enableHapticFeedback) {
        HapticFeedback.selectionClick();
      }
      final next = allSelected
          ? selectedItems.where((item) => !allItems.contains(item)).toList()
          : <T>{...selectedItems, ...allItems}.toList();
      widget.selectedItemsNotifier.value = next;
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
      setState(() => selectedItem = widget.selectedItemNotifier.value);
    }
  }

  void multiSelectListener() {
    if (mounted) {
      setState(() => selectedItems = widget.selectedItemsNotifier.value);
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
      final recents = recentSource
          .where((e) => items.contains(e))
          .toSet()
          .take(widget.recentSelectionsMaxCount)
          .toList();
      if (recents.isNotEmpty) {
        rows.add(_HeaderRow<T>(_recentSelectionsTitle));
        rows.addAll(recents.map((e) => _ItemRow<T>(e)));
      }
    }

    if (widget.groupBy != null) {
      final groups = <String, List<T>>{};
      for (final item in _visibleItems) {
        (groups[widget.groupBy!(item)] ??= <T>[]).add(item);
      }
      groups.forEach((label, groupItems) {
        rows.add(_HeaderRow<T>(label));
        rows.addAll(groupItems.map((e) => _ItemRow<T>(e)));
      });
    } else {
      rows.addAll(_visibleItems.map((e) => _ItemRow<T>(e)));
    }

    return rows;
  }

  Iterable<T> get _visibleItems =>
      items.where((item) => !widget.excludeSelected || item != selectedItem);

  void onItemSelect(T value) {
    if (widget.enableHapticFeedback) {
      HapticFeedback.selectionClick();
    }
    widget.onItemSelect(value);
    if (mounted && widget.dropdownType == _DropdownType.singleSelect) {
      setState(() => displayOverly = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.decoration;
    final theme = Theme.of(context);
    final onSearch = widget.searchType != null;
    final media = MediaQuery.of(context);
    final bottom =
        media.size.height - media.viewInsets.bottom - media.padding.bottom;
    final below =
        (bottom - widget.anchorOffset.dy - 12).clamp(0.0, media.size.height);
    final above =
        (widget.anchorOffset.dy + widget.size.height - media.padding.top - 12)
            .clamp(0.0, media.size.height);
    final desiredHeight = widget.overlayHeight ??
        (widget.dropdownType == _DropdownType.multipleSelect
            ? 400.0
            : (onSearch ? 320.0 : 280.0));
    displayOverlayBottom = below >= desiredHeight || below >= above;
    final maxHeight =
        desiredHeight.clamp(0.0, displayOverlayBottom ? below : above);
    final rows = _buildRows();
    final showFooter = widget.dropdownType == _DropdownType.multipleSelect &&
        widget.showMultiSelectFooter;
    final footerHeight = showFooter ? (maxHeight * .4).clamp(0.0, 56.0) : 0.0;
    final chromeHeight =
        (maxHeight - footerHeight - 48.0).clamp(0.0, maxHeight * .8);

    void close() => setState(() => displayOverly = false);
    void searched(List<T> value) => setState(() => items = value);
    void clearSearch() {
      if (widget.closeOnClear) close();
    }

    final search = widget.searchType == _SearchType.onListData
        ? _SearchField<T>.forListData(
            key: _searchKey,
            items: widget.items,
            searchHintText: widget.searchHintText,
            onQueryChanged: _onQueryChanged,
            onSearchedItems: searched,
            onClearSearch: clearSearch,
            decoration: decoration?.searchFieldDecoration,
          )
        : _SearchField<T>.forRequestData(
            key: _searchKey,
            items: widget.items,
            searchHintText: widget.searchHintText,
            onQueryChanged: _onQueryChanged,
            onSearchedItems: searched,
            onClearSearch: clearSearch,
            onFutureRequestLoading: (value) =>
                setState(() => isSearchRequestLoading = value),
            onRequestError: (error) => setState(() => _requestError = error),
            futureRequest: widget.futureRequest,
            futureRequestDelay: widget.futureRequestDelay,
            decoration: decoration?.searchFieldDecoration,
          );
    void retry() => _searchKey.currentState?.retry();
    final isSearchPrompt = widget.searchType == _SearchType.onRequestData &&
        searchQuery.isEmpty &&
        rows.isEmpty;
    final list = _requestError != null
        ? SingleChildScrollView(
            child: Semantics(
                liveRegion: true,
                child: widget.searchRequestErrorBuilder
                        ?.call(context, _requestError!, retry) ??
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                                'Unable to load results. Please try again.',
                                textAlign: TextAlign.center),
                            const SizedBox(height: 8),
                            TextButton.icon(
                                onPressed: retry,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry')),
                          ],
                        ))))
        : rows.isEmpty
            ? SingleChildScrollView(
                child: isSearchPrompt
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(widget.searchHintText,
                            style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant)))
                    : Semantics(
                        liveRegion: true, child: noResultFoundBuilder(context)))
            : _ItemsList<T>(
                scrollController: scrollController,
                listItemBuilder:
                    widget.listItemBuilder ?? defaultListItemBuilder,
                excludeSelected: widget.excludeSelected,
                selectedItem: selectedItem,
                selectedItems: selectedItems,
                rows: rows,
                rowKeys: widget.enableKeyboardNavigation ? _rowKeys : null,
                itemsListPadding: widget.itemsListPadding ??
                    (onSearch
                        ? const EdgeInsets.only(top: 8)
                        : EdgeInsets.zero),
                listItemPadding:
                    widget.listItemPadding ?? _defaultListItemPadding,
                listItemHeight: widget.listItemHeight,
                onItemSelect: onItemSelect,
                decoration: decoration?.listItemDecoration,
                dropdownType: widget.dropdownType,
                groupHeaderBuilder: widget.groupHeaderBuilder,
                highlightedRowIndex: highlightedRowIndex,
              );
    final radius = decoration?.expandedBorderRadius ?? _defaultBorderRadius;
    final menu = Container(
      margin: _overlayOuterPadding,
      decoration: BoxDecoration(
        color: decoration?.expandedFillColor ?? theme.colorScheme.surface,
        border: decoration?.expandedBorder,
        borderRadius: radius,
        boxShadow: decoration?.expandedShadow ??
            [
              BoxShadow(
                  blurRadius: 24,
                  color: Colors.black.withValues(alpha: .08),
                  offset: _defaultOverlayShadowOffset),
            ],
      ),
      child: Material(
        color: Colors.transparent,
        child: _AnimatedSection(
          animationDismissed: widget.hideOverlay,
          expand: displayOverly,
          alignment: displayOverlayBottom
              ? Alignment.topCenter
              : Alignment.bottomCenter,
          duration: media.disableAnimations
              ? Duration.zero
              : widget.animationDuration,
          curve: widget.animationCurve,
          child: ClipRRect(
            borderRadius: radius,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: Theme(
                data: theme.copyWith(
                    scrollbarTheme: decoration?.overlayScrollbarDecoration ??
                        theme.scrollbarTheme.copyWith(
                            thumbVisibility:
                                const WidgetStatePropertyAll(true))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: chromeHeight),
                      child: SingleChildScrollView(
                        primary: false,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          if (!widget.hideSelectedFieldWhenOpen)
                            InkWell(
                              onTap: close,
                              child: Padding(
                                padding: widget.headerPadding ??
                                    _defaultHeaderPadding,
                                child: Row(children: [
                                  if (decoration?.prefixIcon != null) ...[
                                    decoration!.prefixIcon!,
                                    const SizedBox(width: 12),
                                  ],
                                  Expanded(
                                      child: widget.dropdownType ==
                                              _DropdownType.singleSelect
                                          ? (selectedItem != null
                                              ? headerBuilder(context)
                                              : hintBuilder(context))
                                          : (selectedItems.isNotEmpty
                                              ? headerListBuilder(context)
                                              : hintBuilder(context))),
                                  const SizedBox(width: 12),
                                  decoration?.expandedSuffixIcon ??
                                      _defaultOverlayIconUp,
                                ]),
                              ),
                            ),
                          if (onSearch)
                            Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: search),
                          if (widget.showSelectAll &&
                              widget.dropdownType ==
                                  _DropdownType.multipleSelect &&
                              items.isNotEmpty &&
                              !isSearchRequestLoading &&
                              _requestError == null)
                            _selectAllRow(),
                        ]),
                      ),
                    ),
                    Flexible(
                        child: isSearchRequestLoading
                            ? widget.searchRequestLoadingIndicator ??
                                const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                        child: SizedBox(
                                            width: 25,
                                            height: 25,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 3))))
                            : list),
                    if (showFooter)
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: footerHeight),
                        child: SingleChildScrollView(
                          primary: false,
                          child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 4, 8, 4),
                              child: Row(children: [
                                Expanded(
                                    child: Semantics(
                                        liveRegion: true,
                                        child: Text(
                                            MaterialLocalizations.of(context)
                                                .selectedRowCountTitle(
                                                    selectedItems.length),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: theme.textTheme.bodySmall))),
                                TextButton(
                                    onPressed: close,
                                    child: Text(widget.doneText ?? 'Done')),
                              ])),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final content = Stack(children: [
      if (widget.canCloseOutsideBounds)
        Positioned.fill(
            child: GestureDetector(
                behavior: HitTestBehavior.opaque, onTap: close)),
      Positioned(
        width: widget.size.width + 24,
        child: CompositedTransformFollower(
          link: widget.layerLink,
          followerAnchor:
              displayOverlayBottom ? Alignment.topLeft : Alignment.bottomLeft,
          offset:
              Offset(-12, displayOverlayBottom ? 0 : widget.size.height + 12),
          showWhenUnlinked: false,
          child: menu,
        ),
      ),
    ]);
    return Focus(
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: content,
    );
  }
}
