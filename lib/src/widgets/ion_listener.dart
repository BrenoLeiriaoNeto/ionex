import 'package:flutter/widgets.dart';
import 'package:ionex/ionex.dart';

/// A widget that listens to state changes in an [Ion] and triggers a callback.
///
/// Unlike [IonBuilder] or [IonConsumer], [IonListener] does not rebuild its child
/// widget when the state changes. It is explicitly designed for executing
/// one-time UI side effects such as routing navigation, showing snackbars, or popping dialogs
class IonListener<T> extends StatefulWidget {
  /// The [Ion] instance whose state changes will monitored.
  final Ion<T> ion;

  /// A callback function triggered whenever the [Ion] state emits a notification.
  ///
  /// It provides the current [BuildContext] and the updated [state] value.
  final void Function(BuildContext context, T state) listener;

  /// The widget subtree that remains unaffected by the state changes.
  final Widget child;

  /// Creates an [IonListener] to handle discrete atomic state side effects.
  const IonListener({
    super.key,
    required this.ion,
    required this.listener,
    required this.child
  });

  @override
  State<IonListener<T>> createState() => _IonListenerState<T>();
}

class _IonListenerState<T> extends State<IonListener<T>> {

  @override
  void initState() {
    super.initState();
    widget.ion.addListener(_handleNotification);
  }

  @override
  void didUpdateWidget(covariant IonListener<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.ion != widget.ion) {
      oldWidget.ion.removeListener(_handleNotification);
      widget.ion.addListener(_handleNotification);
    }
  }

  @override
  void dispose() {
    widget.ion.removeListener(_handleNotification);
    super.dispose();
  }

  void _handleNotification() {
    if (mounted) {
      widget.listener(context, widget.ion.state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
