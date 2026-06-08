import 'package:flutter/foundation.dart';

/// The [Ion] is the fundamental unit of reactive state in the Ionex library.
///
/// It encapsulates a piece of molecular state and manages its listeners
/// efficiently by extending the native capabilities of [ValueNotifier].
class Ion<T> extends ValueNotifier<T> {
  final T _initialValue;

  /// Initializes the [Ion] with a mandatory default initial value.
  Ion(super.value) : _initialValue = value;

  /// Returns the current state of the Ion.
  ///
  /// Acts exactly like reading the raw value in memory.
  T get state => value;

  /// Updates the state of the Ion with a brand new value.
  ///
  /// Equivalent to Jotai's `setAtom` or a molecular `setState`.
  /// Automatically notifies all listening widgets if the value changes.
  void set(T newValue) {
    value = newValue;
  }

  /// Mutates the current state using an [updateFn] callback.
  ///
  /// If the state is mutated in-place (e.g., modifying a [List] or [Map]
  /// without changing its reference), it automatically forces a notification
  /// to ensure the UI rebuilds properly.
  void update(T Function(T currentState) updateFn) {
    final oldState = value;
    final newState = updateFn(value);

    if (oldState == newState) {
      value = newState;
      notifyListeners();
    } else {
      value = newState;
    }
  }

  /// Resets the state back to its original initial value.
  void reset() {
    value = _initialValue;
  }
}
