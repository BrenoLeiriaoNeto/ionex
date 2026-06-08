import 'package:flutter/material.dart';
import 'ion_provider.dart';

/// A structural widget that merges multiple [IonProvider]s into a single linear list.
///
/// This eliminates the nesting boilerplate ("Pyramid of Doom") when
/// injecting multiple scoped controllers at the same level of the widget tree.
class MultiIonProvider extends StatelessWidget {
  ///The list of [IonProvider]s to be injected into the tree.
  final List<IonProvider> providers;

  /// The widget child that will have access to all provided controllers.
  final Widget child;

  const MultiIonProvider(
      {super.key, required this.providers, required this.child});

  @override
  Widget build(BuildContext context) {
    Widget current = child;

    for (final provider in providers.reversed) {
      current = provider.copyWithChild(current);
    }

    return current;
  }
}
