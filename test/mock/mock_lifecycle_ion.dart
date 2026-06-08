import 'package:ionex/ionex.dart';

class MockLifecycleIon extends Ion<int> {
  bool isDisposed = false;

  MockLifecycleIon() : super(0);

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
