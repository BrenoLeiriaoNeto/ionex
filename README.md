# ionex

[![Pub Version](https://img.shields.io/badge/pub-v2.1.0-blueviolet?style=for-the-badge)](https://pub.dev/packages/ionex)
[![Dart SDK](https://img.shields.io/badge/dart-3.0+-blue?style=for-the-badge)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/flutter-3.0+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Coverage](https://img.shields.io/badge/Coverage-100%25-success?style=for-the-badge)](https://github.com/BrenoLeiriaoNeto/ionex)

Ionex is a lightweight Flutter state-management package built around a single atomic reactive primitive: `Ion<T>`. It keeps UI state small, explicit, predictable, and easy to compose without introducing a heavy framework.

## Why Ionex?

- **Minimal API**: Zero friction, Fast, readable state creation and mutation.
- **Predictable Flow**: Built on Flutter's native `ValueNotifier` for predictable state flow.
- **No Magic Lifecycles**: No complex background streams or hidden garbage collection issues.
- **Hybrid Architecture**: Works flawlessly as global atoms (Signals/Jotai style) or as scoped local business logic components via context-driven injection (Bloc/Provider style).
- **Zero Dependencies**: Keeps your app bundle lightweight and future-proof.

## Highlights

- `Ion<T>` for strongly-typed reactive state.
- `IonBuilder<T>` for targeted, lightweight widget subtree rebuilds.
- `IonProvider<T extends Ion>` for type-safe, scoped tree dependency injection.
- `IonConsumer<T extends Ion<S>, S>` for automatic context lookup and state listening.
- `IonListener<T>` for side effects without rebuilding (navigation, snackbars).
- `IonLocator` for lightweight synchronous Service Location (DI).
- `MultiIonProvider` to flatten provider structures and kill nesting boilerplate.
- **Fail-Fast Runtime Safety**: Custom semantic errors (`IonexError`) that diagnose misconfigurations (like missing providers or duplicate locator registrations) instantly in the console with actionable fixes.
- 100% Widget and Unit test coverage verified.
- Example application included in `example/lib/main.dart`

## Current project status

- Version: `2.1.0`
- Flutter tests: passing (100% coverage)
- Flutter analyzer: no issues found
- License: MIT
- Changelog: `CHANGELOG.md`

## Installation

Add ionex to your project:

```bash
flutter pub add ionex
```

Or add it directly to `pubspec.yaml`:

```yaml
dependencies:
  ionex: ^2.1.0
```

Then fetch dependencies:

```bash
flutter pub get
```

## Requirements

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0 < 4.0.0

## Package layout

- `lib/ionex.dart`: public exports
- `lib/locator.dart`: service locator exports
- `lib/src/core/ion.dart`: `Ion<T>` reactive state primitive
- `lib/src/locator/ion_locator.dart`: `IonLocator` service locator
- `lib/src/widgets/ion_builder.dart`: scoped UI rebuild widget
- `lib/src/widgets/ion_listener.dart`: side-effect listener widget
- `lib/src/widgets/ion_provider.dart`: scoped controller injection
- `lib/src/widgets/ion_consumer.dart`: context-driven listener widget
- `lib/src/widgets/multi_ion_provider.dart`: multi-provider composition
- `example/lib/main.dart`: runnable demonstration app
- `test/`: unit and widget test coverage

## Core API

### `Ion<T>`

An `Ion<T>` is the fundamental reactive molecule of your application. It holds a typed state value and alerts listeners exclusively when its value changes.

```dart
// Instantiate with an initial value
final counter = Ion<int>(0);

print(counter.state); // Read synchronously: 0

counter.set(1); // Direct mutation
counter.update((current) => current + 1); // Derived mutation
counter.reset(); // Automatically snaps back to 0!
```

### Key methods

- `set(T newValue)`: Immediately replaces the state and triggers updates if the new value differs.
- `update(T Function(T currentState) updateFn)`: Mutates state using a callback function. Out-of-the-box support forces UI rebuilds even for in-place collection mutations (like `List.add`).
- `reset()`: Automatically rolls the state back to the exact initial value defined in the constructor.
- `state`: Getter that synchronously exposes the current value.

### `IonLocator`

A lightweight and synchronous Service Locator inspired by ASP.NET DI. It allows you to manage global dependencies or "Atoms" outside the widget tree.

```dart
import 'package:ionex/locator.dart';

// Register dependencies
IonLocator.addSingleton<MyService>(MyService());
IonLocator.addLazySingleton<MyController>(() => MyController());
IonLocator.addTransient<MyFactory>(() => MyFactory());

// Retrieve anywhere
final service = IonLocator.get<MyService>();
```

> Note: `IonLocator.reset()` is available for unit tests to clear all registrations between test runs.

> Note: `Ion.reset()` no longer accepts an arbitrary value. It always returns the controller to its original initial value.

## UI Components & Dependency Injection

### `IonBuilder<T>`

Listens to an external or global Ion atom and rebuilds only the builder's local widget tree layout.

```dart
IonBuilder<int>(
  ion: counter,
  builder: (context, value) {
    return Text('Count: $value');
  },
);
```

### `IonProvider<T extends Ion>`

Injects a state controller into a local widget subtree using Flutter's native `InheritedWidget` mechanisms. It encapsulates business logic lifecycle, calling `dispose()` automatically when removed from the tree.

```dart
class AuthController extends Ion<String> {
  AuthController() : super('unauthenticated');

  void login(String user) => set('Welcome, $user');
}

// Ingesting into the tree
IonProvider<AuthController>(
  create: (_) => AuthController(),
  child: const ProfileScreen(),
);
```

You can read the controller anywhere below using `IonProvider.of<T>(context)`.

`IonProvider.of<T>` also accepts a `listen` flag, so you can choose whether the caller rebuilds when the state changes:

```dart
// Fetch instance without listening (optimal for button action triggers)
final controller = IonProvider.of<AuthController>(context, listen: false);
controller.login('AtomicDev');
```

### `IonConsumer<T extends Ion<S>, S>`

Combines dependency lookup and state listening into a single sleek component. It automatically resolves the requested controller from the context, listens to its state variations, and exposes both values directly in the builder function.

```dart
IonConsumer<AuthController, String>(
  builder: (context, state, controller) {
    return Column(
      children: [
        Text('Status: $state'),
        ElevatedButton(
          onPressed: () => controller.login('User123'),
          child: const Text('Log In'),
        ),
      ],
    );
  },
);
```

### `IonListener<T>`

Listens to an `Ion<T>` and triggers a callback when the state changes. Unlike `IonBuilder`, it **does not rebuild** its child. This is perfect for navigation, showing SnackBar, or opening dialogs.

```dart
IonListener<int>(
  ion: counter,
  listener: (context, state) {
    if (state == 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reached 10!')),
      );
    }
  },
  child: MyComplexWidget(),
);
```

### `MultiIonProvider`

Annihilates the nested "Pyramid of Doom" widget tree when injecting multiple controllers at the same level.

```dart
MultiIonProvider(
  providers: [
    IonProvider<ThemeController>(create: (_) => ThemeController()),
    IonProvider<LabMessageController>(create: (_) => LabMessageController('Init')),
    IonProvider<LabStatusController>(create: (_) => LabStatusController(true)),
  ],
  child: const HomeScreen(),
);
```

## Runtime Safety & DX

Ionex is designed to fail fast during development rather than swallowing bugs or throwing generic runtime exceptions.
It features a tailored hierarchy to guide you when things are misconfigured:

- **`IonProviderNotFoundException`**: Thrown if you try to look up a controller via `BuildContext` but forgot to wrap the tree with an `IonProvider`. It automatically detects and prints the exact widget name that caused the failure.
- **`IonLocatorDependencyNotFoundException`**: Thrown if you call `IonLocator.get<T>()` before registering the dependency.
- **`IonLocatorDuplicateRegistrationException`**: Protects your memory state by crashing if you accidentally try to register the exact same type twice.

## Breaking changes in 2.0.0

- **Smart `Ion.reset()`**: No longer accepts an input argument. It implicitly rolls the state back to the original `initialValue` given during construction.
- **Simplified `IonProvider` Signature**: Constraints changed from `T extends Ion<dynamic>` to simply `T extends Ion`, improving syntactic clarity and IDE autocomplete engines.
- **Flexible `IonProvider(child)`**: The `child` property is now optional inside the `IonProvider` constructor to support `MultiIonProvider` flattening. Standalone implementations are guarded by a runtime assertion requiring a non-null `child`.

## Usage examples

### A complete, working integration showcasing the power of IonLocator (Service Location) alongside Scoped Providers and Listeners:

```dart
import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:ionex/locator.dart';

// 1. Define Global Atoms/Services
class CounterController extends Ion<int> {
  CounterController(super.value);
  void increment() => update((c) => c + 1);
}

// 2. Define Scoped Controllers
class LabMessageController extends Ion<String> {
  LabMessageController(super.value);
  void changeMessage(String msg) => set(msg);
}

void main() {
  // 3. Register Global Dependencies
  IonLocator.addLazySingleton<CounterController>(() => CounterController(0));
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiIonProvider(
        providers: [
          IonProvider<LabMessageController>(create: (_) => LabMessageController('Atomic Lab Active')),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = IonLocator.get<CounterController>();

    return IonListener<int>(
      ion: counter,
      listener: (context, count) {
        if (count == 5) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(' Milestone Reached: 5!')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Ionex Molecular Lab')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IonConsumer<LabMessageController, String>(
                builder: (context, message, controller) {
                  return Column(
                    children: [
                      Text(message),
                      ElevatedButton(
                        onPressed: () => controller.changeMessage('State mutated!'),
                        child: const Text('Mutate Message'),
                      ),
                    ],
                  );
                },
              ),
              const Divider(height: 48),
              IonBuilder<int>(
                ion: counter,
                builder: (context, count) => Text('Global Count: $count', style: const TextStyle(fontSize: 32)),
              ),
              ElevatedButton(
                onPressed: () => counter.increment(),
                child: const Text('Increment Global Atom'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
```

## Example app

The example app in `example/lib/main.dart` demonstrates:

- theme switching with a global `Ion<ThemeMode>`
- context-scoped controllers with `IonProvider`
- reactive UI updates with `IonConsumer` and `IonBuilder`
- flattened provider composition using `MultiIonProvider`

Run the example:

```bash
cd example
flutter run
```

## Testing and verification

- `flutter test` → passed
- `flutter analyze` → no issues found

The test suite validates:

- `Ion` initialization and state access
- `set()` and `update()` workflows
- `reset()` restoring original values
- listener notification behavior
- `IonBuilder` reactive rebuilds
- `IonListener` side-effect triggering
- `IonLocator` synchronous dependency resolution
- `IonProvider` disposal and context lookup
- `IonConsumer` implicit controller resolution
- `MultiIonProvider` provider composition

## Changelog

See `CHANGELOG.md` for full release notes.

## License

Ionex is distributed under the MIT License. See `LICENSE` for the full text.

## Contributing

Contributions are welcome. A good contribution generally includes:

1. updating or adding tests for any behavior change
2. updating documentation when the public API changes
3. keeping examples aligned with the current package API
4. verifying changes with `flutter test` and `flutter analyze`
