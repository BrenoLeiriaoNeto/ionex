import 'package:flutter/material.dart';
import 'package:ionex/src/core/ion.dart';
import 'ion_provider.dart';

/// A widget that automatically looks up an [Ion] controller of type [T]
/// from the context and listens to its state changes of tyé [S]
///
/// It eliminates the boilerplate of calling `IonProvider.of<T>(context)` manually.
/// The [builder] function provides the [context], the current[state],
/// and the [controller] instance for quick method triggers.
class IonConsumer<T extends Ion<S>, S> extends StatelessWidget {
  /// Function build the widget tree dynamically based on the latest state.
  final Widget Function(BuildContext context, S state, T controller) builder;

  const IonConsumer({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final controller = IonProvider.of<T>(context, listen: false);

    return ValueListenableBuilder<S>(
      valueListenable: controller,
      builder: (context, state, _) => builder(context, state, controller),
    );
  }
}
