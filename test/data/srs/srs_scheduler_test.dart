import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:hanzi/data/srs/srs_scheduler.dart';

final _start = DateTime.utc(2026, 1, 1, 8);

void main() {
  group('matches py-fsrs reference vectors', () {
    final vectors = jsonDecode(
      File('test/fixtures/fsrs_vectors.json').readAsStringSync(),
    ) as List;

    for (final v in vectors) {
      test(v['name'] as String, () {
        final scheduler = SrsScheduler(
          desiredRetention: (v['desired_retention'] as num).toDouble(),
        );
        var state = scheduler.newCard(DateTime.parse(v['start'] as String));
        var i = 0;
        for (final step in v['steps'] as List) {
          final at = DateTime.parse(step['at'] as String);
          final result = scheduler.review(state, step['rating'] as int, at);
          final where = '${v['name']} step $i';

          expect(result.retrievabilityBefore,
              closeTo((step['r_before'] as num).toDouble(), 1e-9),
              reason: '$where r_before');
          expect(result.next.state, step['state'], reason: '$where state');
          expect(result.next.step, step['step'], reason: '$where step');
          expect(result.next.stability,
              closeTo((step['stability'] as num).toDouble(), 1e-6),
              reason: '$where stability');
          expect(result.next.difficulty,
              closeTo((step['difficulty'] as num).toDouble(), 1e-6),
              reason: '$where difficulty');
          expect(result.next.due, DateTime.parse(step['due'] as String),
              reason: '$where due');
          state = result.next;
          i++;
        }
      });
    }
  });

  group('hand-computed against the FSRS-6 wiki formulas', () {
    final s = SrsScheduler(desiredRetention: 0.9);

    test('first Good gives S0 = w[2] = 3.2602', () {
      final r = s.review(s.newCard(_start), 3, _start);
      expect(r.next.stability, closeTo(3.2602, 1e-9));
    });

    test('first Good gives D0(3) = w4 - e^(w5*(3-1)) + 1', () {
      final r = s.review(s.newCard(_start), 3, _start);
      final d0 = 7.0114 - math.exp(0.57 * 2) + 1;
      expect(r.next.difficulty, closeTo(d0, 1e-9));
    });
  });

  group('behaviour', () {
    final s = SrsScheduler(desiredRetention: 0.9);

    SrsState graduated() {
      var st = s.newCard(_start);
      var t = _start;
      for (var i = 0; i < 4; i++) {
        st = s.review(st, 3, t).next;
        t = st.due;
      }
      return st;
    }

    test('new card has retrievability 0 and is due now', () {
      final st = s.newCard(_start);
      expect(st.due, _start);
      expect(s.retrievability(st, _start), 0);
    });

    test('retrievability is 1 right after review, ~desiredRetention at due',
        () {
      final st = graduated();
      expect(st.state, 2, reason: 'should be in review state');
      expect(s.retrievability(st, st.lastReview!), closeTo(1, 1e-9));
      expect(s.retrievability(st, st.due), closeTo(0.9, 0.01));
    });

    test('previewInterval orders Again < Hard < Good < Easy', () {
      final st = graduated();
      final now = st.due;
      final iv = [1, 2, 3, 4].map((r) => s.previewInterval(st, r, now)).toList();
      expect(iv[0] < iv[1] && iv[1] < iv[2] && iv[2] < iv[3], isTrue,
          reason: '$iv');
    });

    test('expectedStabilityGain is positive when R is high', () {
      final st = graduated();
      expect(s.expectedStabilityGain(st, st.due), greaterThan(0));
    });

    test('rejects non-UTC times', () {
      expect(() => s.newCard(DateTime(2026)), throwsArgumentError);
    });
  });
}
