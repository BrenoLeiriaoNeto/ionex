import 'package:flutter/material.dart';
import 'package:ionex/ionex.dart';

final counterIon = Ion<int>(0);
final themeIon = Ion<ThemeMode>(ThemeMode.light);

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
          home: IonProvider(
            ion: Ion<String>('Hello from IonProvider Context!'),
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
    final contextMessageIon = IonProvider.of<String>(context);

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
            Text(
              contextMessageIon.state,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const Text('You have reacted to this Ion this many times:'),

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
        onPressed: () => counterIon.reset(0),
        icon: const Icon(Icons.refresh),
        label: const Text('Reset Lab'),
      ),
    );
  }
}
