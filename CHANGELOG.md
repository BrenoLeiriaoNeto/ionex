# Changelog

All notable changes to this project will be documented in this file.

## [2.0.0] - 2026-06-08

### Breaking Changes

- **Redesigned `Ion.reset`:** The `.reset()` method no longer accepts an arbritary value as a parameter. it is now smart and automatically resets the state back to the exact initial value passed to the `Ion(initialValue)` constructor.
- **Optional `IonProvider(child)`:** To enable the existence of `MultiIonProvider`, the child parameter of `IonProvider` is no longer required in the constructor. Note: _A runtime assert ensures that if used standalone, the `child` must still be provided_.

### New Resources

- **`IonConsumer<T, S>`:** A new, surgical widget introduced to consume states injected via context. It eliminates the need to manually look up the controller via `IonProvider.of(context)` before listening to the state. The `builder` directly exposes the `context`, the updated `state`, and the `controller` instance itself for easy method calls.
- **`MultiIonProvider`:** A new structural widget created to annihilate the "Pyramid of Doom" (nested widget hell). It Allows you to merge and inject a linear list of multiple `IonProvier`s into a single level of the widget tree, keeping your architecture clean and scalable.

### Improvements

- **Internal Refactoring of `IonProvider`:** Added the public `copyWithChild(Widget newChild)` method. This change allows the component to be cloned and dynamically injected by linear tree managers like `MultiIonProvider`, keeping the reactivity of each scope completely isolated.
- **Boilerplate Reduction in Scoped UI:** With the arrival of the `IonProvider` + `IonConsumer` ecosystem, workflows based on Screen Controllers now require up to 50% fewer lines of code to retrieve and listen to instances.

### Fixes

- **Fixed Hidden Collection Mutations(`Ion.update`):** Fixed a bug inherited from the default behavior of `ValueNotifier`, where _in-place_ mutations performed directly on collection references (such as `List.add()`, `Map[] = value`) did not trigger an interface rebuild because the memory reference remained identical. Now, the `.update()` method checks if `oldState == newState` and forces `notifyListeners()` to fire, guaranteeing an immediate and precise UI update for any complex data type.

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
