part of '../custom_dropdown.dart';

/// Appearance and layout overrides for the dropdown search input.
class SearchFieldDecoration {
  /// Fill color for [DropdownFlutter] search field.
  ///
  /// Defaults to the ambient color scheme surfaceContainerHighest.
  final Color? fillColor;

  /// Layout constraints for [DropdownFlutter] search field.
  final BoxConstraints? constraints;

  /// Content spacing for [DropdownFlutter] search field.
  final EdgeInsetsGeometry? contentPadding;

  /// Text Style (text being edited) for [DropdownFlutter] search field.
  final TextStyle? textStyle;

  /// Hint text style for [DropdownFlutter] search field.
  final TextStyle? hintStyle;

  /// Icon (before the text area) for [DropdownFlutter] search field.
  final Widget? prefixIcon;

  /// Icon (after the text area) for [DropdownFlutter] search field.
  /// "onClear" callback can be used to clear typed text appearing on search field.
  final Widget Function(VoidCallback onClear)? suffixIcon;

  /// Border for [DropdownFlutter] search field.
  final InputBorder? border;

  /// Focused border for [DropdownFlutter] search field.
  final InputBorder? focusedBorder;

  /// Creates styling overrides for the search input.
  const SearchFieldDecoration({
    this.fillColor,
    this.constraints,
    this.contentPadding,
    this.textStyle,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.border,
    this.focusedBorder,
  });
}
