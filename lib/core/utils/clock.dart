/// Source of "now". Repositories take one so tests can freeze time.
class Clock {
  const Clock();

  DateTime nowUtc() => DateTime.now().toUtc();
}
