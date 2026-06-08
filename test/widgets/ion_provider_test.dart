import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ionex/ionex.dart';

import '../mock/mock_lifecycle_ion.dart';

void main() {
  group('IonProvider Tests', () {
    testWidgets(
        'should provide instance and call dispose when removed from the tree',
        (WidgetTester tester) async {
      late MockLifecycleIon leakedIonReference;
      final toggleVisiblity = ValueNotifier<bool>(true);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<bool>(
              valueListenable: toggleVisiblity,
              builder: (context, visible, _) {
                if (!visible) return const Text('Provider Dead');

                return IonProvider<MockLifecycleIon>(
                  create: (_) {
                    leakedIonReference = MockLifecycleIon();
                    return leakedIonReference;
                  },
                  child: Builder(builder: (innerContext) {
                    final controller = IonProvider.of<MockLifecycleIon>(
                        innerContext,
                        listen: false);
                    return Text('Controller State: ${controller.state}');
                  }),
                );
              }),
        ),
      ));

      expect(find.text('Controller State: 0'), findsOneWidget);
      expect(leakedIonReference.isDisposed, isFalse);

      toggleVisiblity.value = false;
      await tester.pumpAndSettle();

      expect(find.text('Provider Dead'), findsOneWidget);
      expect(leakedIonReference.isDisposed, isTrue);
    });
  });
}
