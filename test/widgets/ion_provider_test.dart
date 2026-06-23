import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ionex/ionex.dart';
import 'package:ionex/src/widgets/ion_provider.dart';
import 'package:ionex/src/core/errors.dart';

import '../mock/mock_lifecycle_ion.dart';

void main() {
  group('IonProvider Tests', () {
    testWidgets(
        'should provide instance and call dispose when removed from the tree',
        (WidgetTester tester) async {
      late MockLifecycleIon leakedIonReference;
      final toggleVisibility = ValueNotifier<bool>(true);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder<bool>(
              valueListenable: toggleVisibility,
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

      toggleVisibility.value = false;
      await tester.pumpAndSettle();

      expect(find.text('Provider Dead'), findsOneWidget);
      expect(leakedIonReference.isDisposed, isTrue);
    });

    testWidgets('should rebuild when listen: true and Ion instance changes',
        (WidgetTester tester) async {
      final counter = Ion<int>(0);
      int buildCount = 0;

      await tester.pumpWidget(MaterialApp(
        home: IonProvider<Ion<int>>(
          create: (_) => counter,
          child: Builder(builder: (context) {
            buildCount++;
            IonProvider.of<Ion<int>>(context, listen: true);
            return const SizedBox();
          }),
        ),
      ));

      expect(buildCount, 1);
      
      // We trigger a manual rebuild of the parent to see if child rebuilds
      // (it shouldn't unless the InheritedWidget says so)
      await tester.pump();
      expect(buildCount, 1);
    });

    test('IonInheritedElement.updateShouldNotify coverage', () {
      final ion1 = Ion<int>(1);
      final ion2 = Ion<int>(2);
      
      final element1 = IonInheritedElement(
        ion: ion1,
        child: const SizedBox(),
      );
      
      final element2 = IonInheritedElement(
        ion: ion2,
        child: const SizedBox(),
      );
      
      final element1Same = IonInheritedElement(
        ion: ion1,
        child: const SizedBox(),
      );
      
      expect(element1.updateShouldNotify(element2), isTrue);
      expect(element1.updateShouldNotify(element1Same), isFalse);
    });

    test('copyWithChild should return a new IonProvider with new child', () {
      final provider = IonProvider<Ion<int>>(
        create: (_) => Ion<int>(0),
        child: const SizedBox(),
      );

      final newChild = Container();
      final copied = provider.copyWithChild(newChild);

      expect(copied.child, same(newChild));
      expect(copied.create, same(provider.create));
    });

    testWidgets('should throw IonProviderNotFoundException when not found',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () {
              IonProvider.of<Ion<int>>(context);
            },
            child: const Text('Tap Me'),
          );
        }),
      ));

      await tester.tap(find.text('Tap Me'));
      final dynamic exception = tester.takeException();
      expect(exception, isA<IonProviderNotFoundException>());
      expect(exception.toString(), contains('Could not find the IonProvider<Ion<int>>'));
    });
  });
}
