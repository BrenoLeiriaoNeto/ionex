import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';
import 'package:ionex/locator.dart';

/// A dummy configuration class representing a pre-initialized third-party
/// dependency (e.g., SharedPreferences, Firebase or Environment variables).
class LabConfig {
  final String apiKey;
  final String environment;
  LabConfig({required this.apiKey, required this.environment});
}

/// Global Theme State managed out of context using IonLocator.
class ThemeController extends Ion<ThemeMode> {
  ThemeController(super.value);

  void toggleTheme() {
    set(state == .light ? .dark : .light);
  }
}

/// Global Counter State managed out of context using IonLocator.
class CounterController extends Ion<int> {
  CounterController(super.value);

  void increment() => update((c) => c + 1);
  void decrement() => update((c) => c - 1);
}

/// Scoped controller that will depend on Flutter's BuildContext lifecycle.
class LabMessageController extends Ion<String> {
  LabMessageController(super.value);

  void changeMessage(String newMessage) => set(newMessage);
}

/// Scoped Controller that will depend on Flutter's BuildContext lifecycle.
class LabStatusController extends Ion<bool> {
  LabStatusController(super.value);
  void toggleStatus() => set(!state);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.delayed(const Duration(milliseconds: 200));

  IonLocator.addSingleton<LabConfig>(
    LabConfig(apiKey: 'ION-SECURE-KEY-99X', environment: 'Production'),
  );

  IonLocator.addLazySingleton<ThemeController>(() => ThemeController(.light));
  IonLocator.addLazySingleton<CounterController>(() => CounterController(0));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = IonLocator.get<ThemeController>();

    return IonBuilder<ThemeMode>(
      ion: themeController,
      builder: (context, currentTheme) {
        return MaterialApp(
          title: 'Ionex Example Playground',
          themeMode: currentTheme,
          theme: .light(useMaterial3: true),
          darkTheme: .dark(useMaterial3: true),
          home: MultiIonProvider(
            providers: [
              IonProvider<LabMessageController>(
                create: (_) => LabMessageController('Atomic Lab Active'),
              ),
              IonProvider<LabStatusController>(
                create: (_) => LabStatusController(true),
              ),
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
    final config = IonLocator.get<LabConfig>();
    final counterController = IonLocator.get<CounterController>();
    final themeController = IonLocator.get<ThemeController>();

    return IonListener<int>(
      ion: counterController,
      listener: (context, count) {
        if (count == 5 || count == -5) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '🧬 Quantum Milestone! Counter reached $count items.',
              ),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (count == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🔄 Lab Counter reset to initial state.'),
              duration: Duration(milliseconds: 800),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Ionex Molecular Lab \nEnv: ${config.environment}'),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () {
                themeController.toggleTheme();
              },
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: .center,
              children: [
                IonConsumer<LabMessageController, String>(
                  builder: (context, message, controller) {
                    return Column(
                      children: [
                        Text(
                          message,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            controller.changeMessage(
                              '🔬 Atomic state mutated at ${DateTime.now().second}s!',
                            );
                          },
                          child: const Text('Mutate Context Message'),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                IonConsumer<LabStatusController, bool>(
                  builder: (context, isActive, controller) {
                    return ActionChip(
                      label: Text(
                        isActive
                            ? 'Core System: Online'
                            : 'Core System: Offline',
                      ),
                      avatar: Icon(
                        Icons.circle,
                        color: isActive ? Colors.green : Colors.red,
                        size: 16,
                      ),
                      onPressed: () => controller.toggleStatus(),
                    );
                  },
                ),

                const Divider(height: 64, indent: 32, endIndent: 32),

                const Text('You have reacted to this Ion this many times:'),
                const SizedBox(height: 12),

                IonBuilder<int>(
                  ion: counterController,
                  builder: (context, count) {
                    return Text(
                      '$count',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => counterController.decrement(),
                      icon: const Icon(Icons.remove),
                      label: const Text('Decrement'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () => counterController.increment(),
                      icon: const Icon(Icons.add),
                      label: const Text('Increment'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => counterController.reset(),
          icon: const Icon(Icons.refresh),
          label: const Text('Reset Lab'),
        ),
      ),
    );
  }
}
