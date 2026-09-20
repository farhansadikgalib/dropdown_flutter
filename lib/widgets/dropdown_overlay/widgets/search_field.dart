part of '../../../custom_dropdown.dart';

class _SearchField<T> extends StatefulWidget {
  final List<T> items;
  final ValueChanged<List<T>> onSearchedItems;
  final String searchHintText;
  final _SearchType? searchType;
  final Future<List<T>> Function(String)? futureRequest;
  final Duration? futureRequestDelay;
  final ValueChanged<bool>? onFutureRequestLoading;
  final ValueChanged<Object?>? onRequestError;
  final ValueChanged<String>? onQueryChanged;
  final SearchFieldDecoration? decoration;
  final VoidCallback? onClearSearch;

  const _SearchField.forListData({
    super.key,
    required this.items,
    required this.onSearchedItems,
    required this.searchHintText,
    required this.decoration,
    this.onQueryChanged,
    this.onClearSearch,
  })  : searchType = _SearchType.onListData,
        futureRequest = null,
        futureRequestDelay = null,
        onFutureRequestLoading = null,
        onRequestError = null;

  const _SearchField.forRequestData({
    super.key,
    required this.items,
    required this.onSearchedItems,
    required this.searchHintText,
    required this.futureRequest,
    required this.futureRequestDelay,
    required this.onFutureRequestLoading,
    required this.onRequestError,
    required this.decoration,
    this.onQueryChanged,
    this.onClearSearch,
  }) : searchType = _SearchType.onRequestData;

  @override
  State<_SearchField<T>> createState() => _SearchFieldState<T>();
}

class _SearchFieldState<T> extends State<_SearchField<T>> {
  final searchCtrl = TextEditingController();
  int _requestId = 0;
  final FocusNode focusNode = FocusNode();
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    final desktop = switch (defaultTargetPlatform) {
      TargetPlatform.macOS ||
      TargetPlatform.windows ||
      TargetPlatform.linux =>
        true,
      _ => false,
    };
    if (desktop ||
        (widget.searchType == _SearchType.onRequestData &&
            widget.items.isEmpty)) {
      focusNode.requestFocus();
    }
  }

  @override
  void dispose() {
    _requestId++;
    focusNode.dispose();
    searchCtrl.dispose();
    _delayTimer?.cancel();
    super.dispose();
  }

  void onSearch(String query) {
    final result = widget.items.where((item) {
      if (item is CustomDropdownListFilter) {
        return item.filter(query);
      } else {
        return item.toString().toLowerCase().contains(query.toLowerCase());
      }
    }).toList();
    widget.onSearchedItems(result);
  }

  void onClear() {
    searchCtrl.clear();
    _onChanged('');
    focusNode.requestFocus();
    widget.onClearSearch?.call();
  }

  void _onChanged(String query) {
    _delayTimer?.cancel();
    final requestId = ++_requestId;
    setState(() {});
    widget.onRequestError?.call(null);
    widget.onQueryChanged?.call(query);
    if (widget.searchType == _SearchType.onListData) {
      onSearch(query);
      return;
    }
    if (query.isEmpty) {
      widget.onFutureRequestLoading?.call(false);

      widget.onSearchedItems(widget.items);
      return;
    }
    widget.onFutureRequestLoading?.call(true);
    _delayTimer = Timer(widget.futureRequestDelay ?? Duration.zero,
        () => searchRequest(query, requestId));
  }

  Future<void> searchRequest(String query, int requestId) async {
    List<T> result;
    Object? error;
    try {
      result = await widget.futureRequest!(query);
    } catch (exception) {
      error = exception;
      result = <T>[];
    }
    // Only the latest query may update the menu, including after clearing or
    // disposing the search field. The underlying future need not be cancellable.
    if (!mounted || requestId != _requestId) return;
    widget.onFutureRequestLoading?.call(false);
    widget.onRequestError?.call(error);
    widget.onSearchedItems(result);
  }

  void retry() => _onChanged(searchCtrl.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextField(
        focusNode: focusNode,
        textInputAction: TextInputAction.search,
        style: widget.decoration?.textStyle,
        onChanged: _onChanged,
        controller: searchCtrl,
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.decoration?.fillColor ??
              Theme.of(context).colorScheme.surfaceContainerHighest,
          constraints: widget.decoration?.constraints ??
              const BoxConstraints(minHeight: 48),
          contentPadding:
              widget.decoration?.contentPadding ?? const EdgeInsets.all(8),
          hintText: widget.searchHintText,
          hintStyle: widget.decoration?.hintStyle,
          prefixIcon: widget.decoration?.prefixIcon ??
              const Icon(Icons.search, size: 22),
          suffixIcon: widget.decoration?.suffixIcon?.call(onClear) ??
              (searchCtrl.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Clear search',
                      onPressed: onClear,
                      icon: const Icon(Icons.close, size: 20),
                    )),
          border: widget.decoration?.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.withValues(alpha: .25),
                  width: 1,
                ),
              ),
          enabledBorder: widget.decoration?.border ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.withValues(alpha: .25),
                  width: 1,
                ),
              ),
          focusedBorder: widget.decoration?.focusedBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary, width: 2),
              ),
        ),
      ),
    );
  }
}
