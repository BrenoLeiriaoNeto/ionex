import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ionex/ionex.dart';

import '../mock/mock_lifecycle_ion.dart';

void main() {
  group('IonConsumer Test', () {
    testWidgets(
        'should implicit resolve controller from context and trigger rebuilds',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: IonProvider<MockLifecycleIon>(
          create: (_) => MockLifecycleIon(),
          child: Scaffold(body: IonConsumer<MockLifecycleIon, int>(
              builder: (context, state, controller) {
            return Column(
              children: [
                Text('Consumer State: $state'),
                ElevatedButton(
                  onPressed: () => controller.set(state + 1),
                  child: const Text('Increment Context'),
                )
              ],
            );
          })),
        ),
      ));

      expect(find.text('Consumer State: 0'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(find.text('Consumer State: 1'), findsOneWidget);
    });
  });
}
