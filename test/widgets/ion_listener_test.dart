import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ionex/ionex.dart';

void main() {
  group('IonListener Tests', () {
    testWidgets('should call listener when state changes',
        (WidgetTester tester) async {
      final counter = Ion<int>(0);
      int? lastState;
      int callCount = 0;

      await tester.pumpWidget(MaterialApp(
        home: IonListener<int>(
          ion: counter,
          listener: (context, state) {
            lastState = state;
            callCount++;
          },
          child: const SizedBox(),
        ),
      ));

      expect(callCount, 0);

      counter.set(1);
      await tester.pump();

      expect(callCount, 1);
      expect(lastState, 1);

      counter.set(10);
      await tester.pump();

      expect(callCount, 2);
      expect(lastState, 10);
    });

    testWidgets('should update listener when Ion instance changes',
        (WidgetTester tester) async {
      final ion1 = Ion<int>(1);
      final ion2 = Ion<int>(2);
      int callCount = 0;

      await tester.pumpWidget(MaterialApp(
        home: IonListener<int>(
          ion: ion1,
          listener: (context, state) => callCount++,
          child: const SizedBox(),
        ),
      ));

      ion1.set(11);
      await tester.pump();
      expect(callCount, 1);

      // Change the Ion instance
      await tester.pumpWidget(MaterialApp(
        home: IonListener<int>(
          ion: ion2,
          listener: (context, state) => callCount++,
          child: const SizedBox(),
        ),
      ));

      // Should not trigger on ion1 anymore
      ion1.set(111);
      await tester.pump();
      expect(callCount, 1);

      // Should trigger on ion2
      ion2.set(22);
      await tester.pump();
      expect(callCount, 2);
    });

    testWidgets('should not call listener after dispose',
        (WidgetTester tester) async {
      final counter = Ion<int>(0);
      int callCount = 0;

      await tester.pumpWidget(MaterialApp(
        home: IonListener<int>(
          ion: counter,
          listener: (context, state) => callCount++,
          child: const SizedBox(),
        ),
      ));

      counter.set(1);
      await tester.pump();
      expect(callCount, 1);

      // Dispose the widget
      await tester.pumpWidget(const MaterialApp(home: SizedBox()));

      counter.set(2);
      await tester.pump();
      expect(callCount, 1); // Should still be 1
    });
  });
}
