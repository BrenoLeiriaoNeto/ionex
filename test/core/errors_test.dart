import 'package:flutter_test/flutter_test.dart';
import 'package:ionex/src/core/errors.dart';
import 'package:flutter/widgets.dart';

class MockWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const SizedBox();
}

void main() {
  group('IonexError Tests', () {
    test('IonLocatorDependencyNotFoundException toString()', () {
      final error = IonLocatorDependencyNotFoundException(String);
      expect(error.toString(), contains('❌ [IonexError]'));
      expect(error.toString(), contains('The type "String" was requested from IonLocator'));
    });

    test('IonLocatorDuplicateRegistrationException toString()', () {
      final error = IonLocatorDuplicateRegistrationException(int);
      expect(error.toString(), contains('❌ [IonexError]'));
      expect(error.toString(), contains('The type "int" is already registered in IonLocator'));
    });

    test('IonProviderNotFoundException toString()', () {
      final error = IonProviderNotFoundException(String, MockWidget);
      expect(error.toString(), contains('❌ [IonexError]'));
      expect(error.toString(), contains('Could not find the IonProvider<String> above this [MockWidget] Widget'));
    });
  });
}
