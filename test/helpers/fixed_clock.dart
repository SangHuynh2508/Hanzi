import 'package:doanmonhoc_hanzi/core/utils/clock.dart';

/// Clock frozen at [now]; tests move it by assigning.
class FixedClock implements Clock {
  FixedClock(this.now);

  DateTime now;

  @override
  DateTime nowUtc() => now;
}
