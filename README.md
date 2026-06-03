# ionex

[![Pub Version](https://img.shields.io/badge/pub-v1.1.0-blueviolet?style=for-the-badge)](https://pub.dev/packages/ionex)
[![Dart SDK](https://img.shields.io/badge/dart-3.0+-blue?style=for-the-badge)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/flutter-3.0+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Coverage](https://img.shields.io/badge/Coverage-100%25-success?style=for-the-badge)](https://github.com/BrenoLeiriaoNeto/ionex)

Ionex is a tiny Flutter state-management package for small, explicit, and predictable UI state. It centers on a single typed reactive primitive, `Ion<T>`, and two lightweight widgets for observing and providing state without introducing a heavy framework.

## Why Ionex?

- Minimal API designed for concise state mutation
- Built on Flutter's native `ValueNotifier` for predictable updates
- No bulky framework concepts or hidden lifecycle complexity
- Great for feature-level state, simple reactive UIs, and reusable controller objects

## Highlights

- `Ion<T>` as a lightweight reactive state container
- `IonBuilder<T>` for scoped rebuilds
- `IonProvider<Ion<T>>` for type-safe tree injection
- Example app included in `example/lib/main.dart`
- Unit tests covering core behavior

## Current project status

- Version: `1.1.0`
- Flutter tests: passing
- Flutter analyzer: no issues found
- License: MIT
- Changelog: available in `CHANGELOG.md`

## Installation

Add ionex to your project:

```bash
flutter pub add ionex
```

Or add it directly to `pubspec.yaml`:

```yaml
dependencies:
  ionex: ^1.1.0
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
- `lib/src/widgets/ion_builder.dart`: rebuilds only the widget subtree that depends on an Ion
- `lib/src/widgets/ion_provider.dart`: injects an Ion into the widget tree
- `example/lib/main.dart`: runnable demonstration app
- `test/core/ion_test.dart`: core unit tests

## Core API

### `Ion<T>`

`Ion<T>` is the fundamental reactive unit in Ionex. It stores a typed value and notifies listeners whenever the value changes.

```dart
final counter = Ion<int>(0);

counter.state; // 0
counter.set(1);
counter.update((current) => current + 1);
counter.reset(0);
```

### Available methods

- `set(newValue)`: replace the current state immediately
- `update((current) => nextValue)`: derive a new state from the current one
- `reset(initialValue)`: restore the ion to a known value
- `state`: access the current value synchronously

## UI helpers

### `IonBuilder<T>`

`IonBuilder<T>` listens to an `Ion` and rebuilds only the widget subtree that depends on it.

```dart
IonBuilder<int>(
  ion: counter,
  builder: (context, value) {
    return Text('Count: $value');
  },
);
```

### `IonProvider`

`IonProvider` installs an `Ion` into the widget tree so descendants can retrieve it without prop drilling.

```dart
final authStatus = Ion<String>('unauthenticated');

IonProvider<Ion<String>>(
  ion: authStatus,
  child: const ProfileScreen(),
);
```

Retrieve the injected `Ion` from the current `BuildContext`:

```dart
final authStatus = IonProvider.of<Ion<String>>(context);
print(authStatus.state);
```

## Usage examples

### 1. Simple counter

```dart
import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';

final counter = Ion<int>(0);

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IonBuilder<int>(
          ion: counter,
          builder: (context, value) {
            return Text('Count: $value');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => counter.update((current) => current + 1),
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### 2. Context-based state access

```dart
import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';

final themeIon = Ion<ThemeMode>(ThemeMode.light);
final messageIon = Ion<String>('Hello from IonProvider Context!');

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return IonBuilder<ThemeMode>(
      ion: themeIon,
      builder: (context, themeMode) {
        return IonProvider<Ion<String>>(
          ion: messageIon,
          child: MaterialApp(
            themeMode: themeMode,
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            home: Builder(
              builder: (context) {
                final message = IonProvider.of<Ion<String>>(context);

                return Scaffold(
                  body: Center(
                    child: Text(message.state),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
```

### 3. Resetting and deriving state

```dart
final filter = Ion<String>('all');
final count = Ion<int>(0);

filter.reset('all');
count.update((current) => current + 5);
```

## Example app

The example app in `example/lib/main.dart` demonstrates two common flows:

- shared global state for counter and theme
- context-scoped state access with `IonProvider` and `IonProvider.of<T>(context)`

Run the example:

```bash
cd example
flutter run
```

## Testing and verification

- `flutter test` → passed
- `flutter analyze` → no issues found

The core tests cover:

- initialization and default state
- `set()` updates
- `update()` derivation
- `reset()` restoration
- listener notifications on state changes

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
