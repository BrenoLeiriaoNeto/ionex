import 'package:flutter/cupertino.dart';
import 'package:ionex/locator.dart';

abstract class IonexError extends Error {
  final String message;

  IonexError(this.message);

  @override
  String toString() => '❌ [IonexError] $message';
}

/// Thrown when [IonLocator] fails to find a registered dependency.
class IonLocatorDependencyNotFoundException extends IonexError {
  IonLocatorDependencyNotFoundException(Type type)
      : super(
          'The type "$type" was requested from IonLocator, but it hasn\'t been registered. \n'
          '👉 Fix: Make sure to call IonLocator.addSingleton<$type>() or IonLocator.addLazySingleton<$type>() before fetching it.',
        );
}

/// Thrown when [IonLocator] attempts to register a dependency twice.
class IonLocatorDuplicateRegistrationException extends IonexError {
  IonLocatorDuplicateRegistrationException(Type type)
      : super(
          'The type "$type" is already registered in IonLocator. \n'
          '👉 Fix: Review your initialization code to ensure you aren\'t registering the same dependency twice',
        );
}

/// Thrown when trying to look up an [Ion] controller via [BuildContext] but no
/// matching [IonProvider] is found higher up in the widget tree.
class IonProviderNotFoundException extends IonexError {
  IonProviderNotFoundException(Type ionType, Type callingWidgetType)
      : super(
          'Could not find the IonProvider<$ionType> above this [$callingWidgetType] Widget. \n'
          '👉 Fix: Ensure you wrap your widget tree with an IonProvider<$ionType> or include it in a MultiIonProvider before calling IonProvider.of<$ionType>(context)',
        );
}
