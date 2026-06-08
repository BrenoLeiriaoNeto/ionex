# ionex

[![Pub Version](https://img.shields.io/badge/pub-v2.0.0-blueviolet?style=for-the-badge)](https://pub.dev/packages/ionex)
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
- `MultiIonProvider` to flatten provider structures and kill nesting boilerplate.
- 100% Widget and Unit test coverage verified.
- Example application included in `example/lib/main.dart`

## Current project status

- Version: `2.0.0`
- Flutter tests: passing
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
  ionex: ^2.0.0
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
- `lib/src/core/ion.dart`: `Ion<T>` reactive state primitive
- `lib/src/widgets/ion_builder.dart`: scoped UI rebuild widget
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

## Breaking changes in 2.0.0

- **Smart`Ion.reset()`**: No longer accepts an input argument. It implicitly rolls the state back to the original `initialValue` given during construction.
- **Simplified `IonProvider` Signature**: Constraints changed from `T extends Ion<dynamic>` to simply `T extends Ion`, improving syntactic clarity and IDE autocomplete engines.
- **Flexible `IonProvider(child)`**: The `child` property is now optional inside the `IonProvider` constructor to support `MultiIonProvider` flattening. Standalone implementations are guarded by a runtime assertion requiring a non-null `child`.

## Usage examples

### A complete, working integration showcasing the power of global atoms alongside clean, scoped multi-controllers injection:

```dart
import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';

// Global Atoms (Application wide states)
final counterIon = Ion<int>(0);
final themeIon = Ion<ThemeMode>(ThemeMode.light);

// Scoped Context Controllers (Screen specific business logic)
class LabMessageController extends Ion<String> {
  LabMessageController(super.value);
  void changeMessage(String msg) => set(msg);
}

class LabStatusController extends Ion<bool> {
  LabStatusController(super.value);
  void toggleStatus() => set(!state);
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return IonBuilder<ThemeMode>(
      ion: themeIon,
      builder: (context, currentTheme) {
        return MaterialApp(
          themeMode: currentTheme,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          home: MultiIonProvider(
            providers: [
              IonProvider<LabMessageController>(create: (_) => LabMessageController('Atomic Lab Active')),
              IonProvider<LabStatusController>(create: (_) => LabStatusController(true)),
            ],
            child: const HomeScreen(),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ionex Molecular Lab'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => themeIon.update(
              (c) => c == ThemeMode.light ? ThemeMode.dark : ThemeMode.light,
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Consuming context via IonConsumer
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
            const SizedBox(height: 24),
            // Consuming sister controller from MultiIonProvider
            IonConsumer<LabStatusController, bool>(
              builder: (context, isActive, controller) {
                return ActionChip(
                  label: Text(isActive ? 'SYSTEM: ONLINE' : 'SYSTEM: OFFLINE'),
                  onPressed: () => controller.toggleStatus(),
                );
              },
            ),
            const Divider(height: 48),
            // Consuming global atoms via IonBuilder
            IonBuilder<int>(
              ion: counterIon,
              builder: (context, count) => Text('Count: $count', style: const TextStyle(fontSize: 32)),
            ),
            ElevatedButton(
              onPressed: () => counterIon.update((c) => c + 1),
              child: const Text('Increment Global Atom'),
            )
          ],
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
