import 'package:flutter/material.dart';
import 'package:ionex/src/core/ion.dart';

/// The [IonProvider] is the widget responsible for injecting and propagating an [Ion]
/// down the widget tree using Flutter's native context.
///
/// It allows any child widget to access the [Ion] state without the need
/// to pass it via constructors (prop drilling), using the Service Locator pattern.
class IonProvider<T extends Ion<dynamic>> extends InheritedWidget {
  /// The [Ion] that will be made available to the widget tree below this provider.
  final T ion;

  /// Creates an [IonProvider] that injects the [Ion] and wraps the provided [child].
  const IonProvider({super.key, required this.ion, required super.child});

  /// Searches for an [Ion] of the specified type [T] in the widget tree closest
  /// above the provided [context].
  ///
  /// Throws an [Exception] if the [IonProvider] is not found in the current scope.
  ///
  /// Usage example:
  /// `final authController = IonProvider.of<AuthController>(context);`
  static T of<T extends Ion<dynamic>>(BuildContext context) {
    final IonProvider<T>? provider =
        context.dependOnInheritedWidgetOfExactType<IonProvider<T>>();

    if (provider == null) {
      throw Exception("No IonProvider of type $T found in the current context. "
          "Certify to wrap your widget tree with an IonProvider<$T>");
    }
    return provider.ion;
  }

  @override
  bool updateShouldNotify(IonProvider oldWidget) {
    // Since the Ion itself has its internal listener notification mechanism
    // (ValueNotifier), the InheritedWidget does not need to force a rebuild
    // of the entire tree if the Ion instance remains the same.
    return ion != oldWidget.ion;
  }
}
