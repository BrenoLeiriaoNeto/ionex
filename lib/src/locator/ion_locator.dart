import 'package:flutter/material.dart';
import 'package:ionex/src/core/errors.dart';

/// A lightweight and synchronous Service Locator inspired by ASP.NET DI,
/// custom-built for the Ionex ecosystem.
class IonLocator {
  @visibleForTesting
  IonLocator();

  static final Map<Type, Object Function()> _factories = {};

  static final Map<Type, Object> _singletons = {};

  /// Registers a dependency as a **Transient** (Factory).
  ///
  /// A new instance will be created every time [get] is called.
  /// Throws an [IonLocatorDuplicateRegistrationException] if the type is already registered.
  static void addTransient<T extends Object>(T Function() factory) {
    _factories.containsKey(T)
        ? throw IonLocatorDuplicateRegistrationException(T)
        : _factories[T] = factory;
  }

  /// Registers a dependency as a **Lazy Singleton**.
  ///
  /// The instance will only be created the first time it is requested
  /// and then kept in cache for subsequent calls.
  /// Throws an [IonLocatorDuplicateRegistrationException] if the type is already registered.
  static void addLazySingleton<T extends Object>(T Function() factory) {
    if (_factories.containsKey(T)) {
      throw IonLocatorDuplicateRegistrationException(T);
    }

    _factories[T] = () {
      if (!_singletons.containsKey(T)) {
        _singletons[T] = factory();
      }
      return _singletons[T]!;
    };
  }

  /// Registers an already existing instance as a **Singleton**
  ///
  /// Useful for pre-configured objects or third-party dependencies initialized
  /// asynchronously during app startup (e.g., SharedPreferences).
  /// Throws an [IonLocatorDuplicateRegistrationException] if the type is already registered.
  static void addSingleton<T extends Object>(T instance) {
    if (_factories.containsKey(T)) {
      throw IonLocatorDuplicateRegistrationException(T);
    }
    _singletons[T] = instance;
    _factories[T] = () => _singletons[T]!;
  }

  /// Retrieves the registered instance of type [T].
  ///
  /// Throws an [IonLocatorDependencyNotFoundException] if the type has not been registered.
  static T get<T extends Object>() {
    final factory = _factories[T];
    if (factory == null) {
      throw IonLocatorDependencyNotFoundException(T);
    }
    return factory() as T;
  }

  /// Clears all registrations from the locator.
  ///
  /// Essential for resetting the state between unit test executions.
  @visibleForTesting
  static void reset() {
    _factories.clear();
    _singletons.clear();
  }
}
