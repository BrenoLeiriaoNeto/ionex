import 'package:flutter/foundation.dart';

/// The [Ion] is the fundamental unit of reactive state in the Ionex library.
///
/// It encapsulates a piece of molecular state and manages its listeners
/// efficiently by extending the native capabilities of [ValueNotifier].
class Ion<T> extends ValueNotifier<T> {
  /// Initializes the [Ion] with a mandatory default initial value.
  Ion(super.value);

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

  /// Modifies the current state based on the previous state value.
  ///
  /// Highly useful for increments, list manipulation, or object mutation.
  /// Example: `counterIon.update((c) => c + 1);`
  void update(T Function(T currentState) updateFn) {
    value = updateFn(value);
  }

  /// Resets the Ion to a specific initial value.
  ///
  /// Helper syntax for better readability in logout flows or filter clearing.
  void reset(T initialValue) {
    value = initialValue;
  }
}
