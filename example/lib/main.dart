import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';

final counterIon = Ion<int>(0);
final themeIon = Ion<ThemeMode>(ThemeMode.light);

class LabMessageController extends Ion<String> {
  LabMessageController(super.value);

  void changeMessage(String newMessage) => set(newMessage);
}

class LabStatusController extends Ion<bool> {
  LabStatusController(super.value);
  void toggleStatus() => set(!state);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return IonBuilder<ThemeMode>(
      ion: themeIon,
      builder: (context, currentTheme) {
        return MaterialApp(
          title: 'Ionex Example Playground',
          themeMode: currentTheme,
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ionex Molecular Lab'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              themeIon.update(
                (current) => current == ThemeMode.light
                    ? ThemeMode.dark
                    : ThemeMode.light,
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IonConsumer<LabMessageController, String>(
              builder: (context, message, controller) {
                return Column(
                  children: [
                    Text(
                      message,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                    isActive ? 'Core System: Online' : 'Core System: Offline',
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
              ion: counterIon,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => counterIon.update((c) => c - 1),
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrement'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => counterIon.update((c) => c + 1),
                  icon: const Icon(Icons.add),
                  label: const Text('Increment'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => counterIon.reset(),
        icon: const Icon(Icons.refresh),
        label: const Text('Reset Lab'),
      ),
    );
  }
}
