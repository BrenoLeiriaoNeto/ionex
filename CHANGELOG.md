# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2026-06-03

### Improvementes

- **Strict Type Propagation in IonProvider:** Enhanced `IonProvider` to be a generic class (`IonProvider<T extends Ion>`), ensuring that the Flutter framework differentiates between different controller instances within the widget tree.
- **Type-Safe Service Location:** Updated `IonProvider.of<T>` to fetch the exact exact `Ion` type requested via context, preventing type casting issues when nesting multiple providers.
- **Improved Error Messaging:** Enhanced runtime exception messages to explicitly show which specific `Ion` type (`$T`) was missing in the current context.

### Fixes

- **Context Shadowing Bug:** Fixed a critical bug where an inner `IonProvider` would shadow/block an outer `IonProvider` of a different type during lookups via `BuildContext`.

## [1.0.2] - 2026-05-26

### Fixed

- README.md corrections for a better presentation on pub.dev.

## [1.0.1] - 2026-05-25

### Fixed

- Standardized LICENSE text formatting for official OSI-approved recognitions on pub.dev.

## [1.0.0] - 2026-05-25

### Added

- Fundamental `Ion<T>` class for molecular, atomic state mutation extending native `ValueNotifier`.
- `IonBuilder<T>` widget to isolate UI re-renders surgically to the minimum expression.
- `IonProvider` inherited widget for clean, context-based dependency injection.
- Complete unit test suite with 100% code coverage for the core state engine.
- Interactive `example/` application demonstrating Global Atom and Contextual flows.
- Full API documentation comments in English aligned with Dart SDK standards.
