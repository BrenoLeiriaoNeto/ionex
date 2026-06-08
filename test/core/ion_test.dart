import 'package:flutter_test/flutter_test.dart';
import 'package:ionex/ionex.dart';

void main() {
  group('Ion Core Tests -', () {
    test('Should initialize with the correct default value', () {
      final counterIon = Ion<int>(0);

      expect(counterIon.state, equals(0));
      expect(counterIon.value, equals(0));
    });

    test('Should mutate state correctly using set()', () {
      final statusIon = Ion<String>('initial');

      statusIon.set('loading');
      expect(statusIon.state, equals('loading'));

      statusIon.set('success');
      expect(statusIon.state, equals('success'));
    });

    test('Should mutate state correctly based on previous state using update()',
        () {
      final counterIon = Ion<int>(10);

      counterIon.update((state) => state + 5);
      expect(counterIon.state, equals(15));

      counterIon.update((state) => state * 2);
      expect(counterIon.state, equals(30));
    });

    test('Should reset state to initial/new specified value using reset()', () {
      final themeIon = Ion<String>('dark');

      themeIon.set('light');
      expect(themeIon.state, equals('light'));

      themeIon.reset();
      expect(themeIon.state, equals('dark'));
    });

    test('Should notify listeners when state changes', () {
      final counterIon = Ion<int>(0);
      int notificationCount = 0;

      counterIon.addListener(() {
        notificationCount++;
      });

      counterIon.set(1);
      counterIon.update((state) => state + 1);

      counterIon.set(2);

      expect(notificationCount, equals(2));
      expect(counterIon.state, equals(2));
    });

    test(
        'Should force notification on update() even when mutating collection in-place',
        () {
      final listIon = Ion<List<String>>(['Thing', 'Anything']);
      int notificationCount = 0;

      listIon.addListener(() {
        notificationCount++;
      });

      listIon.update((list) {
        list.add('Something');
        return list;
      });

      expect(notificationCount, equals(1));
      expect(listIon.state, contains('Something'));
      expect(listIon.state.length, equals(3));
    });
  });
}
