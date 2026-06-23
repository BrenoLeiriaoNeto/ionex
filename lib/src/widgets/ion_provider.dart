import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:ionex/src/core/errors.dart';

@visibleForTesting
class IonInheritedElement<T extends Ion> extends InheritedWidget {
  final T ion;

  const IonInheritedElement({
    super.key,
    required this.ion,
    required super.child,
  });

  @override
  bool updateShouldNotify(IonInheritedElement<T> oldWidget) {
    return ion != oldWidget.ion;
  }
}

/// An [IonProvider] is responsible for injecting and propagating an [Ion]
/// down the widget tree using Flutter's native context mechanisms.
///
/// It manages the lifecycle of the provided [Ion] (calling dispose automatically)
/// and allows any child widget to access its instance without constructor-based
/// prop drilling, acting as a scoped Service Locator.
class IonProvider<T extends Ion> extends StatefulWidget {
  /// The factory callback used to instantiate the [Ion] controller.
  final T Function(BuildContext context) create;

  /// The widget below this provider in the tree.
  ///
  /// Can be null when this provider is used inside a [MultiIonProvider].
  /// Must not be null when used as a standalone provider.
  final Widget? child;

  /// Creates an [IonProvider] that injects the [Ion] and wraps the provided [child].
  const IonProvider({super.key, required this.create, this.child});

  /// Creates a copy of this [IonProvider] with a new [child] widget.
  ///
  /// Used internally by [MultiIonProvider] to flatten and linearize the widget tree.
  IonProvider<T> copyWithChild(Widget newChild) {
    return IonProvider<T>(
      key: key,
      create: create,
      child: newChild,
    );
  }

  /// Looks up the closest [IonProvider] managing an [Ion] of type [T] up the widget tree.
  ///
  /// By default, [listen] is set to `false`, making it optimal for fetching the instance
  /// to call actions/methods without triggering unnecessary widget rebuilds. Set [listen]
  /// to `true` if the calling widget needs to rebuild whenever the dependent [Ion] changes.
  ///
  /// Throws an [IonProviderNotFoundException] if no matching [IonProvider] is found in the current scope.
  ///
  /// Example:
  /// ```dart
  /// final authController = IonProvider.of<AuthController>(context);
  /// ```
  static T of<T extends Ion>(BuildContext context, {bool listen = false}) {
    final inheritedWidget = listen
        ? context.dependOnInheritedWidgetOfExactType<IonInheritedElement<T>>()
        : context.getInheritedWidgetOfExactType<IonInheritedElement<T>>();

    if (inheritedWidget == null) {
      throw IonProviderNotFoundException(T, context.widget.runtimeType);
    }
    return inheritedWidget.ion;
  }

  @override
  State<IonProvider<T>> createState() => _IonProviderState<T>();
}

class _IonProviderState<T extends Ion> extends State<IonProvider<T>> {
  late final T _ion;

  @override
  void initState() {
    super.initState();
    _ion = widget.create(context);
  }

  @override
  void dispose() {
    _ion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.child != null,
        'IonProvider requires a child widget when used standalone.');

    return IonInheritedElement<T>(
      ion: _ion,
      child: widget.child!,
    );
  }
}

// Removed the old private class
