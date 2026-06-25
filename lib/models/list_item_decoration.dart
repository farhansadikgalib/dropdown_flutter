part of '../custom_dropdown.dart';

class ListItemDecoration {
  /// Splash color for [DropdownFlutter] list item area.
  ///
  /// Default to [Colors.transparent].
  final Color? splashColor;

  /// Highlight color for [DropdownFlutter] list item area.
  ///
  /// Default to Color(0xFFEEEEEE).
  final Color? highlightColor;

  /// Selected color for [DropdownFlutter] list item area.
  ///
  /// Default to Color(0xFFF5F5F5).
  final Color? selectedColor;

  /// Selected icon color for [DropdownFlutter] list item area.
  /// Useless if [listItemBuilder] provided.
  final Color? selectedIconColor;

  /// Selected icon border for [DropdownFlutter] list item area.
  /// Useless if [listItemBuilder] provided.
  final BorderSide? selectedIconBorder;

  /// Selected icon shape for [DropdownFlutter] list item area.
  /// Useless if [listItemBuilder] provided.
  final OutlinedBorder? selectedIconShape;

  /// Background color of the row highlighted via keyboard navigation.
  ///
  /// Only applicable when `enableKeyboardNavigation` is true.
  /// Default to Color(0xFFE8F0FE).
  final Color? highlightedColor;

  /// Text style applied to the matched substring within search results.
  ///
  /// Only applicable when `highlightMatchedText` is true and the default
  /// list item builder is used. Default to a bold span.
  final TextStyle? searchMatchTextStyle;

  const ListItemDecoration({
    this.splashColor,
    this.highlightColor,
    this.selectedColor,
    this.selectedIconColor,
    this.selectedIconBorder,
    this.selectedIconShape,
    this.highlightedColor,
    this.searchMatchTextStyle,
  });

  static const _defaultSplashColor = Colors.transparent;
  static const _defaultHighlightColor = Color(0xFFEEEEEE);
  static const _defaultSelectedColor = Color(0xFFF5F5F5);
  static const _defaultHighlightedColor = Color(0xFFE8F0FE);
  static const _defaultSearchMatchTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
  );
}
