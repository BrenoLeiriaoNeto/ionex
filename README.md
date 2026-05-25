# ionex

A lightweight Flutter state-management package built around a tiny reactive `Ion` primitive and a couple of focused widgets for easy consumption in the UI.

Ionex is designed to be small, explicit, and easy to understand. It gives you a simple state container with `set`, `update`, and `reset` helpers, plus `IonBuilder` and `IonProvider` so you can rebuild only the widgets that care about a particular piece of state.

## What this package provides

### Core API

- `Ion<T>`: a typed reactive state container built on top of `ValueNotifier`
- `set(T newValue)`: replace the current state
- `update(T Function(T currentState) updateFn)`: derive the next state from the current one
- `reset(T initialValue)`: restore the ion to a known starting value

### UI helpers

- `IonBuilder<T>`: listens to an `Ion` and rebuilds only the widget subtree you provide
- `IonProvider`: injects an `Ion` into the widget tree so children can access it without prop drilling

### Project status

This package is currently in an **early development** phase. The public API is present, but the project still needs cleanup in a few areas:

- `README.md` was previously a template and has been replaced with package-specific documentation
- `CHANGELOG.md` still contains placeholder text
- `LICENSE` still needs to be filled in
- the test scaffold in `test/ionex_test.dart` is currently a placeholder and does not reflect the package’s real API

## Installation

Add `ionex` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  ionex: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Requirements

- Flutter SDK `>=2.5.0`
- Dart SDK `>=3.0.0 <4.0.0`

## Project structure

A quick overview of the repository layout:

- `lib/ionex.dart`: public exports for the package
- `lib/src/core/ion.dart`: the `Ion<T>` state primitive
- `lib/src/widgets/ion_builder.dart`: the reactive `IonBuilder` widget
- `lib/src/widgets/ion_provider.dart`: the `IonProvider` injection widget
- `test/ionex_test.dart`: current test entry point
- `pubspec.yaml`: package metadata and dependencies
- `CHANGELOG.md`: release notes
- `LICENSE`: package license

## Usage

### 1. Create a state atom

Use `Ion<T>` to hold any piece of mutable state:

```dart
import 'package:ionex/ionex.dart';

final counter = Ion<int>(0);
final title = Ion<String>('Hello, Ionex');
```

### 2. Read and update state

`Ion` behaves like a typed `ValueNotifier`, so you can read its current value via `state` or by using it directly in widgets:

```dart
import 'package:ionex/ionex.dart';

final counter = Ion<int>(0);

counter.set(1);
counter.update((current) => current + 1);
counter.reset(0);

print(counter.state); // 0
```

### 3. Rebuild a widget subtree with `IonBuilder`

`IonBuilder` listens to a single `Ion` and calls your builder whenever the value changes:

```dart
import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    final counter = Ion<int>(0);

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

> In a real application, it is better to keep the `Ion` instance in a `StatefulWidget`, a controller, or your own state layer so it is not recreated on every build.

### 4. Inject an `Ion` into the widget tree with `IonProvider`

Use `IonProvider` when you want descendants to access the same atom without threading it through constructors:

```dart
import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final authStatus = Ion<String>('signed_out');

    return IonProvider(
      ion: authStatus,
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            final currentAuth = IonProvider.of<String>(context);

            return Scaffold(
              body: Center(
                child: Text(currentAuth.state),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

### 5. Typical patterns

#### Counter

```dart
final counter = Ion<int>(0);

counter.update((current) => current + 1);
```

#### Form fields

```dart
final email = Ion<String>('');

email.set('hello@example.com');
```

#### Resettable filters

```dart
final filter = Ion<String>('all');

filter.reset('all');
```

## API reference

### `Ion<T>`

Constructors:

- `Ion(T initialValue)`

Methods:

- `set(T newValue)`
- `update(T Function(T currentState) updateFn)`
- `reset(T initialValue)`

Getter:

- `state`: returns the current value

### `IonBuilder<T>`

Properties:

- `ion`: the `Ion<T>` being observed
- `builder`: a callback receiving `BuildContext` and the current value

### `IonProvider`

- `ion`: the `Ion<dynamic>` that will be exposed to descendants
- `of<T>(BuildContext context)`: retrieves the nearest `Ion<T>` from the tree

## Development

### Running tests

At the moment, `flutter test` is available, but the current test file is a placeholder and fails to compile because it references a `Calculator` class that does not exist in this package.

To run the current test suite:

```bash
flutter test
```

### Linting

```bash
flutter analyze
```

## Current limitations

- No example app has been added yet
- No published docs site or usage guide exists yet
- `CHANGELOG.md` still needs a real release summary
- `LICENSE` is not yet defined
- `pubspec.yaml` metadata (`description`, `homepage`) still needs to be finalized

## Roadmap

The next improvements would be:

1. Replace the placeholder test with real package-level tests
2. Add an example application or `example/` folder
3. Fill out `CHANGELOG.md` and `LICENSE`
4. Improve package metadata in `pubspec.yaml`
5. Document recommended usage patterns for larger applications

## Contributing

Contributions are welcome. If you want to improve the package:

1. Open or review an issue describing the change
2. Add or update tests for the behavior you want to preserve
3. Update documentation and examples if the public API changes
4. Verify the package with `flutter test` and `flutter analyze`

## License

The package license is not yet finalized in the repository. `LICENSE` currently contains placeholder text.
