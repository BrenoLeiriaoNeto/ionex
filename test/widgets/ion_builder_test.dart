import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ionex/ionex.dart';

void main() {
  group('IonBuilder Tests', () {
    testWidgets(
        'should render initial state and rebuild when global Ion changes',
        (WidgetTester tester) async {
      final counter = Ion<int>(10);

      await tester.pumpWidget(MaterialApp(
        home: IonBuilder(
            ion: counter, builder: (context, state) => Text('Count: $state')),
      ));

      expect(find.text('Count: 10'), findsOneWidget);

      counter.set(25);
      await tester.pump();

      expect(find.text('Count: 25'), findsOneWidget);
    });
  });
}
