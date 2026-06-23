import 'package:flutter_test/flutter_test.dart';
import 'package:ionex/locator.dart';
import 'package:ionex/src/core/errors.dart';

class MockService {
  final int id;
  MockService(this.id);
}

void main() {
  setUp(() {
    IonLocator.reset();
  });

  group('IonLocator Tests', () {
    test('should register and retrieve a singleton', () {
      final service = MockService(1);
      IonLocator.addSingleton<MockService>(service);

      final retrieved = IonLocator.get<MockService>();
      expect(retrieved, same(service));
      expect(retrieved.id, 1);
    });

    test('should register and retrieve a lazy singleton', () {
      int initCount = 0;
      IonLocator.addLazySingleton<MockService>(() {
        initCount++;
        return MockService(2);
      });

      expect(initCount, 0);

      final retrieved1 = IonLocator.get<MockService>();
      expect(initCount, 1);
      expect(retrieved1.id, 2);

      final retrieved2 = IonLocator.get<MockService>();
      expect(initCount, 1);
      expect(retrieved2, same(retrieved1));
    });

    test('should register and retrieve a transient dependency', () {
      int initCount = 0;
      IonLocator.addTransient<MockService>(() {
        initCount++;
        return MockService(initCount);
      });

      final retrieved1 = IonLocator.get<MockService>();
      expect(retrieved1.id, 1);

      final retrieved2 = IonLocator.get<MockService>();
      expect(retrieved2.id, 2);
      expect(retrieved2, isNot(same(retrieved1)));
    });

    test('should throw an exception when type is not registered', () {
      expect(() => IonLocator.get<MockService>(),
          throwsA(isA<IonLocatorDependencyNotFoundException>()));
    });

    test('should throw an exception when registering the same type twice', () {
      IonLocator.addSingleton(MockService(1));
      expect(() => IonLocator.addSingleton(MockService(2)),
          throwsA(isA<IonLocatorDuplicateRegistrationException>()));
    });

    test('should throw an exception when registering a transient twice', () {
      IonLocator.addTransient(() => MockService(1));
      expect(() => IonLocator.addTransient(() => MockService(2)),
          throwsA(isA<IonLocatorDuplicateRegistrationException>()));
    });

    test('should throw an exception when registering a lazy singleton twice',
        () {
      IonLocator.addLazySingleton(() => MockService(1));
      expect(() => IonLocator.addLazySingleton(() => MockService(2)),
          throwsA(isA<IonLocatorDuplicateRegistrationException>()));
    });

    test('should clear all registrations on reset', () {
      IonLocator.addSingleton(MockService(1));
      expect(IonLocator.get<MockService>(), isA<MockService>());

      IonLocator.reset();

      expect(() => IonLocator.get<MockService>(),
          throwsA(isA<IonLocatorDependencyNotFoundException>()));
    });

    test('private constructor coverage', () {
      expect(IonLocator(), isA<IonLocator>());
    });
  });
}
