part of '../custom_dropdown.dart';

class CustomDropdownDecoration {
  /// [DropdownFlutter] field color (closed state).
  ///
  /// Default to [Colors.white].
  final Color? closedFillColor;

  /// [DropdownFlutter] overlay color (opened/expanded state).
  ///
  /// Default to [Colors.white].
  final Color? expandedFillColor;

  /// [DropdownFlutter] box shadow (closed state).
  final List<BoxShadow>? closedShadow;

  /// [DropdownFlutter] box shadow (opened/expanded state).
  final List<BoxShadow>? expandedShadow;

  /// Suffix icon for closed state of [DropdownFlutter].
  final Widget? closedSuffixIcon;

  /// Suffix icon for opened/expanded state of [DropdownFlutter].
  final Widget? expandedSuffixIcon;

  /// [DropdownFlutter] header prefix icon.
  final Widget? prefixIcon;

  /// Border for closed state of [DropdownFlutter].
  final BoxBorder? closedBorder;

  /// Border radius for closed state of [DropdownFlutter].
  final BorderRadius? closedBorderRadius;

  /// Error border for closed state of [DropdownFlutter].
  final BoxBorder? closedErrorBorder;

  /// Error border radius for closed state of [DropdownFlutter].
  final BorderRadius? closedErrorBorderRadius;

  /// Border for opened/expanded state of [DropdownFlutter].
  final BoxBorder? expandedBorder;

  /// Border radius for opened/expanded state of [DropdownFlutter].
  final BorderRadius? expandedBorderRadius;

  /// The style to use for the [DropdownFlutter] header hint.
  final TextStyle? hintStyle;

  /// The style to use for the [DropdownFlutter] header text.
  final TextStyle? headerStyle;

  /// The style to use for the [DropdownFlutter] no result found area.
  final TextStyle? noResultFoundStyle;

  /// The style to use for the string returning from [validator].
  final TextStyle? errorStyle;

  /// The style to use for the [DropdownFlutter] list item text.
  final TextStyle? listItemStyle;

  /// [DropdownFlutter] scrollbar decoration (opened/expanded state).
  final ScrollbarThemeData? overlayScrollbarDecoration;

  /// [DropdownFlutter] search field decoration.
  final SearchFieldDecoration? searchFieldDecoration;

  /// [DropdownFlutter] list item decoration.
  final ListItemDecoration? listItemDecoration;

  const CustomDropdownDecoration({
    this.closedFillColor,
    this.expandedFillColor,
    this.closedShadow,
    this.expandedShadow,
    this.closedSuffixIcon,
    this.expandedSuffixIcon,
    this.prefixIcon,
    this.closedBorder,
    this.closedBorderRadius,
    this.closedErrorBorder,
    this.closedErrorBorderRadius,
    this.expandedBorder,
    this.expandedBorderRadius,
    this.hintStyle,
    this.headerStyle,
    this.noResultFoundStyle,
    this.errorStyle,
    this.listItemStyle,
    this.overlayScrollbarDecoration,
    this.searchFieldDecoration,
    this.listItemDecoration,
  });

  static const Color _defaultFillColor = Colors.white;
}
