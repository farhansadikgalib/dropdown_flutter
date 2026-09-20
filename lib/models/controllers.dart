part of '../custom_dropdown.dart';

/// Controls a nullable single selection and notifies listeners when it changes.
class SingleSelectController<T> extends ValueNotifier<T?> {
  /// Creates a controller with the given initial selection.
  SingleSelectController(super._value);

  /// Clears the current selection.
  void clear() {
    value = null;
  }

  /// Whether an item is selected.
  bool get hasValue => value != null;
}

/// Controls an immutable, duplicate-free list of selected items.
class MultiSelectController<T> extends ValueNotifier<List<T>> {
  /// Stores an immutable, duplicate-free snapshot of the selection.
  MultiSelectController(List<T> value)
      : super(List<T>.unmodifiable(value.toSet()));

  @override
  set value(List<T> newValue) {
    final next = List<T>.unmodifiable(newValue.toSet());
    if (listEquals(super.value, next)) return;
    super.value = next;
  }

  /// Selects an item, leaving already-selected items unchanged.
  void add(T valueToAdd) {
    value = [...value, valueToAdd];
  }

  /// Deselects the matching item, if present.
  void remove(T valueToRemove) {
    value = value.where((value) => value != valueToRemove).toList();
  }

  /// Clears the current selection.
  void clear() {
    value = [];
  }

  /// Whether at least one item is selected.
  bool get hasValues => value.isNotEmpty;
}
