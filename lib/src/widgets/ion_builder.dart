import 'package:flutter/material.dart';
import 'package:ionex/src/core/ion.dart';

/// The [IonBuilder] is the reactive widget responsible for listening to changes in an [Ion].
///
/// Every time the provided [ion] state is modified via `.set()` or `.update()`,
/// only the scope delimited by the [builder] method will re-render,
/// ensuring surgical performance in the user interface.
class IonBuilder<T> extends StatelessWidget {
  /// The [Ion] that this widget will reactively observe.
  final Ion<T> ion;

  /// The function that rebuilds the widget tree based on the new [Ion] value.
  ///
  /// Provides the current [BuildContext] and the real-time state [value].
  final Widget Function(BuildContext context, T value) builder;

  /// Creates an [IonBuilder] associated with an [ion] and a [builder] rendering function.
  const IonBuilder({
    super.key,
    required this.ion,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: ion,
      builder: (context, value, _) => builder(context, value),
    );
  }
}
