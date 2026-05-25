# ionex

[![Pub Version](https://img.shields.io/badge/pub-v1.0.0-blueviolet?style=for-the-badge)](https://pub.dev)
[![Dart SDK](https://img.shields.io/badge/dart-3.0+-blue?style=for-the-badge)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/flutter-3.0+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)
[![Coverage](https://img.shields.io/badge/Coverage-100%25-success?style=for-the-badge)](https://github.com)

Ionex is a lightweight Flutter state-management package for small, explicit, and predictable UI state. It revolves around a single reactive primitive, Ion<T>, and two small widgets that make it easy to observe and inject state without introducing a heavy framework.

## Highlights

- A typed reactive core built on top of Flutter's native ValueNotifier
- Simple mutation helpers: set, update, and reset
- Minimal widget helpers for reactive rendering and dependency injection
- A working example app that demonstrates both global and context-based usage
- A tested and analyzed codebase with current release metadata in place

## Current project status

This repository is currently in version 1.0.0.

Verified project health:

- Flutter tests: passing
- Flutter analyzer: no issues found
- License: MIT
- Changelog: updated for 1.0.0

## Installation

Add ionex to your pubspec.yaml:

```yaml
dependencies:
  ionex: ^1.0.0
```

Then install dependencies:

```bash
flutter pub get
```

## Requirements

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0 < 4.0.0

## Package layout

- lib/ionex.dart: public exports
- lib/src/core/ion.dart: the Ion<T> reactive state primitive
- lib/src/widgets/ion_builder.dart: rebuilds only the part of the UI that depends on an Ion
- lib/src/widgets/ion_provider.dart: injects an Ion into the widget tree
- example/lib/main.dart: runnable demonstration app
- test/core/ion_test.dart: unit tests for the core state engine

## Core API

### Ion<T>

Ion<T> is the basic building block of the package. It stores a typed value and notifies listeners whenever the value changes.

```dart
final counter = Ion<int>(0);

counter.state; // 0
counter.set(1);
counter.update((current) => current + 1);
counter.reset(0);
```

### Available methods

- set(newValue): replaces the current state immediately
- update((current) => nextValue): derives the next value from the current one
- reset(initialValue): restores the ion to a known value
- state: returns the current value synchronously

## UI helpers

### IonBuilder<T>

IonBuilder<T> listens to an Ion and rebuilds the provided builder callback when the value changes.

```dart
IonBuilder<int>(
  ion: counter,
  builder: (context, value) {
    return Text('Count: $value');
  },
);
```

### IonProvider

IonProvider injects an Ion into the widget tree so descendants can read it without passing it through constructors.

```dart
IonProvider(
  ion: authStatus,
  child: const ProfileScreen(),
);
```

Retrieve it from the context with IonProvider.of<T>(context):

```dart
final authStatus = IonProvider.of<String>(context);
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

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Ion<ThemeMode>(ThemeMode.light);

    return IonProvider(
      ion: Ion<String>('Hello from IonProvider Context!'),
      child: MaterialApp(
        themeMode: theme.state,
        home: Builder(
          builder: (context) {
            final message = IonProvider.of<String>(context);

            return Scaffold(
              body: Center(
                child: Text(message.state),
              ),
            );
          },
        ),
      ),
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

The example application in example/lib/main.dart demonstrates two common flows:

- Global state with a shared Ion for the counter and theme
- Context-based access with IonProvider and IonProvider.of<T>(context)

To run the example:

```bash
cd example
flutter run
```

## Testing and verification

Current verification commands and results:

- flutter test → passed
- flutter analyze → no issues found

The core behavior covered by tests includes:

- initialization and default values
- set() updates
- update() derivation from the current state
- reset() restoration to a known value
- listener notifications on state changes

## Changelog

See CHANGELOG.md for the published release notes.

## License

Ionex is distributed under the MIT License. See LICENSE for the full text.

## Contributing

Contributions are welcome. A good contribution generally includes:

1. Updating or adding tests for any behavior change
2. Updating documentation when the public API changes
3. Keeping examples aligned with the current package API
4. Verifying the package with flutter test and flutter analyze
