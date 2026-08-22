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

  /// Returns a copy of this decoration with the given fields replaced.
  ///
  /// Useful for deriving a one-off variant from a shared base decoration
  /// without repeating every property.
  CustomDropdownDecoration copyWith({
    Color? closedFillColor,
    Color? expandedFillColor,
    List<BoxShadow>? closedShadow,
    List<BoxShadow>? expandedShadow,
    Widget? closedSuffixIcon,
    Widget? expandedSuffixIcon,
    Widget? prefixIcon,
    BoxBorder? closedBorder,
    BorderRadius? closedBorderRadius,
    BoxBorder? closedErrorBorder,
    BorderRadius? closedErrorBorderRadius,
    BoxBorder? expandedBorder,
    BorderRadius? expandedBorderRadius,
    TextStyle? hintStyle,
    TextStyle? headerStyle,
    TextStyle? noResultFoundStyle,
    TextStyle? errorStyle,
    TextStyle? listItemStyle,
    ScrollbarThemeData? overlayScrollbarDecoration,
    SearchFieldDecoration? searchFieldDecoration,
    ListItemDecoration? listItemDecoration,
  }) {
    return CustomDropdownDecoration(
      closedFillColor: closedFillColor ?? this.closedFillColor,
      expandedFillColor: expandedFillColor ?? this.expandedFillColor,
      closedShadow: closedShadow ?? this.closedShadow,
      expandedShadow: expandedShadow ?? this.expandedShadow,
      closedSuffixIcon: closedSuffixIcon ?? this.closedSuffixIcon,
      expandedSuffixIcon: expandedSuffixIcon ?? this.expandedSuffixIcon,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      closedBorder: closedBorder ?? this.closedBorder,
      closedBorderRadius: closedBorderRadius ?? this.closedBorderRadius,
      closedErrorBorder: closedErrorBorder ?? this.closedErrorBorder,
      closedErrorBorderRadius:
          closedErrorBorderRadius ?? this.closedErrorBorderRadius,
      expandedBorder: expandedBorder ?? this.expandedBorder,
      expandedBorderRadius: expandedBorderRadius ?? this.expandedBorderRadius,
      hintStyle: hintStyle ?? this.hintStyle,
      headerStyle: headerStyle ?? this.headerStyle,
      noResultFoundStyle: noResultFoundStyle ?? this.noResultFoundStyle,
      errorStyle: errorStyle ?? this.errorStyle,
      listItemStyle: listItemStyle ?? this.listItemStyle,
      overlayScrollbarDecoration:
          overlayScrollbarDecoration ?? this.overlayScrollbarDecoration,
      searchFieldDecoration:
          searchFieldDecoration ?? this.searchFieldDecoration,
      listItemDecoration: listItemDecoration ?? this.listItemDecoration,
    );
  }

  static const Color _defaultFillColor = Colors.white;
}
