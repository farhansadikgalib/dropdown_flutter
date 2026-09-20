part of '../custom_dropdown.dart';

/// Custom matching for objects used in local-search dropdowns.
///
/// Implement this mixin when matching should consider more than [Object.toString].
mixin CustomDropdownListFilter {
  /// Whether this item matches the query supplied to [DropdownFlutter.search]
  /// or [DropdownFlutter.multiSelectSearch].
  bool filter(String query);
}
