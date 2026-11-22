import 'package:fsrs/fsrs.dart' as fsrs;

/// Scheduling state of one card. Our own type so the rest of the app never
/// depends on the `fsrs` package directly (only this file does).
class SrsState {
  const SrsState({
    required this.state,
    required this.step,
    required this.stability,
    required this.difficulty,
    required this.due,
    required this.lastReview,
  });

  /// 1 = learning, 2 = review, 3 = relearning (same values as FSRS).
  final int state;
  final int? step;

  /// Null until the first review.
  final double? stability;
  final double? difficulty;
  final DateTime due;
  final DateTime? lastReview;
}

/// FSRS-6 scheduler (pub `fsrs`, a port of py-fsrs commit 6fd0857).
///
/// Fuzzing is always off so replaying the same review logs always gives the
/// same state (needed when merging logs from two devices during sync).
class SrsScheduler {
  SrsScheduler({required double desiredRetention})
      : _s = fsrs.Scheduler(
          desiredRetention: desiredRetention,
          enableFuzzing: false,
        );

  final fsrs.Scheduler _s;

  SrsState newCard(DateTime nowUtc) {
    _requireUtc(nowUtc);
    return _toState(fsrs.Card(cardId: 0, due: nowUtc));
  }

  /// [rating]: 1 = Again, 2 = Hard, 3 = Good, 4 = Easy.
  ({SrsState next, double retrievabilityBefore}) review(
    SrsState s,
    int rating,
    DateTime nowUtc,
  ) {
    _requireUtc(nowUtc);
    final card = _toCard(s);
    final before = _s.getCardRetrievability(card, currentDateTime: nowUtc);
    final result = _s.reviewCard(
      card,
      fsrs.Rating.fromValue(rating),
      reviewDateTime: nowUtc,
    );
    return (next: _toState(result.card), retrievabilityBefore: before);
  }

  double retrievability(SrsState s, DateTime nowUtc) =>
      _s.getCardRetrievability(_toCard(s), currentDateTime: nowUtc);

  /// How long until the next review if the learner answers [rating] now.
  Duration previewInterval(SrsState s, int rating, DateTime nowUtc) =>
      review(s, rating, nowUtc).next.due.difference(nowUtc);

  /// E[S after review] - S = R·S'(Good) + (1-R)·S'(Again) - S.
  /// Used to order an overdue backlog (spec 9.3, strategy 3).
  double expectedStabilityGain(SrsState s, DateTime nowUtc) {
    final r = retrievability(s, nowUtc);
    final good = review(s, 3, nowUtc).next.stability!;
    final again = review(s, 1, nowUtc).next.stability!;
    return r * good + (1 - r) * again - (s.stability ?? 0);
  }

  static void _requireUtc(DateTime t) {
    if (!t.isUtc) throw ArgumentError.value(t, 'nowUtc', 'must be UTC');
  }

  static fsrs.Card _toCard(SrsState s) => fsrs.Card(
        cardId: 0,
        state: fsrs.State.fromValue(s.state),
        step: s.step,
        stability: s.stability,
        difficulty: s.difficulty,
        due: s.due,
        lastReview: s.lastReview,
      );

  static SrsState _toState(fsrs.Card c) => SrsState(
        state: c.state.value,
        step: c.step,
        stability: c.stability,
        difficulty: c.difficulty,
        due: c.due,
        lastReview: c.lastReview,
      );
}
