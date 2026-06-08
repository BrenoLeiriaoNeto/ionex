import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ionex/ionex.dart';

class TestControllerA extends Ion<String> {
  TestControllerA() : super('A');
}

class TestControllerB extends Ion<int> {
  TestControllerB() : super(10);
}

void main() {
  testWidgets(
      'MultiIonProvider should resolve and provide multiple controllers correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MultiIonProvider(
        providers: [
          IonProvider<TestControllerA>(create: (_) => TestControllerA()),
          IonProvider<TestControllerB>(create: (_) => TestControllerB()),
        ],
        child: Scaffold(
            body: Column(
          children: [
            IonConsumer<TestControllerA, String>(
                builder: (context, state, _) => Text('ControllerA: $state')),
            IonConsumer<TestControllerB, int>(
                builder: (context, state, _) => Text('ControllerB: $state')),
          ],
        )),
      ),
    ));

    expect(find.text('ControllerA: A'), findsOneWidget);
    expect(find.text('ControllerB: 10'), findsOneWidget);

    final context = tester.element(find.text('ControllerA: A'));

    IonProvider.of<TestControllerA>(context, listen: false).set('A_MUTATED');
    IonProvider.of<TestControllerB>(context, listen: false).set(99);

    await tester.pump();

    expect(find.text('ControllerA: A_MUTATED'), findsOneWidget);
    expect(find.text('ControllerB: 99'), findsOneWidget);
  });
}
