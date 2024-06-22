part of '../custom_dropdown.dart';

class CustomDropdownDisabledDecoration {
  /// [DropdownFlutter] field color (disabled state).
  ///
  /// Default to Color(0xFFF3F3F3).
  final Color? fillColor;

  /// [DropdownFlutter] box shadow (disabled state).
  final List<BoxShadow>? shadow;

  /// Suffix icon for disabled state of [DropdownFlutter].
  final Widget? suffixIcon;

  /// Prefix icon for disabled state of [DropdownFlutter].
  final Widget? prefixIcon;

  /// Border for disabled state of [DropdownFlutter].
  final BoxBorder? border;

  /// Border radius for disabled state of [DropdownFlutter].
  final BorderRadius? borderRadius;

  /// The style to use for the [DropdownFlutter] header hint (disabled state).
  final TextStyle? hintStyle;

  /// The style to use for the [DropdownFlutter] header text (disabled state).
  final TextStyle? headerStyle;

  const CustomDropdownDisabledDecoration({
    this.fillColor,
    this.shadow,
    this.suffixIcon,
    this.prefixIcon,
    this.border,
    this.borderRadius,
    this.headerStyle,
    this.hintStyle,
  });
}
