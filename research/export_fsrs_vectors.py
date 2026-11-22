"""Export FSRS reference vectors from py-fsrs (commit 6fd0857).

The Dart package `fsrs` 2.0.1 is a port of this exact py-fsrs commit.
`test/data/srs/srs_scheduler_test.dart` replays every sequence below through
our Dart `SrsScheduler` and requires the same stability, difficulty and due.

Usage (from repo root):
    research/.venv/Scripts/python research/export_fsrs_vectors.py test/fixtures/fsrs_vectors.json
"""

import json
import random
import sys
from datetime import datetime, timedelta, timezone

from fsrs import Card, Rating, Scheduler

START = datetime(2026, 1, 1, 8, 0, tzinfo=timezone.utc)

# A step is (rating, mode, value):
#   mode "due"   -> review at card.due + value days (negative = early review)
#   mode "after" -> review value hours after the previous review (same-day review)
G, A, H, E = 3, 1, 2, 4
SEQUENCES = {
    "all_good": [(G, "due", 0)] * 8,
    "again_then_good": [(A, "due", 0)] + [(G, "due", 0)] * 4,
    "easy_first": [(E, "due", 0)] + [(G, "due", 0)] * 3,
    "hard_good_alternating": [(H, "due", 0), (G, "due", 0)] * 3,
    "forget_after_30_days_late": [(G, "due", 0)] * 4 + [(A, "due", 30), (G, "due", 0), (G, "due", 0)],
    "two_reviews_same_day": [(G, "due", 0), (G, "after", 2), (G, "after", 3), (G, "due", 0), (G, "due", 0)],
    "early_review": [(G, "due", 0)] * 4 + [(G, "due", -3), (G, "due", 0)],
    "all_again": [(A, "due", 0)] * 5,
    "late_every_time": [(G, "due", 5)] * 6,
    "easy_streak": [(E, "due", 0)] * 6,
    "lapse_in_relearning": [(G, "due", 0)] * 3 + [(A, "due", 0), (A, "due", 0), (G, "due", 0), (G, "due", 0)],
    "mixed_fixed": [(r, "due", 0) for r in (3, 1, 3, 3, 2, 4, 1, 3, 3, 3)],
}
RETENTION_SEQUENCES = {
    "retention_085_all_good": (0.85, [(G, "due", 0)] * 6),
    "retention_095_all_good": (0.95, [(G, "due", 0)] * 6),
}


def random_sequence(seed: int):
    rnd = random.Random(seed)
    steps = []
    for _ in range(12):
        rating = rnd.choice([1, 2, 3, 3, 3, 4])
        if rnd.random() < 0.15:
            steps.append((rating, "after", rnd.choice([1, 4, 8])))
        else:
            steps.append((rating, "due", rnd.choice([-1, 0, 0, 0, 2, 7])))
    return steps


def iso(dt):
    return None if dt is None else dt.astimezone(timezone.utc).isoformat()


def run(name, retention, steps):
    scheduler = Scheduler(desired_retention=retention, enable_fuzzing=False)
    card = Card(card_id=0, due=START)
    prev = None
    out = []
    for rating, mode, value in steps:
        if prev is None:
            at = START
        elif mode == "after":
            at = prev + timedelta(hours=value)
        else:
            at = max(card.due + timedelta(days=value), prev + timedelta(minutes=1))
        r_before = scheduler.get_card_retrievability(card, current_datetime=at)
        card, _ = scheduler.review_card(card, Rating(rating), review_datetime=at)
        out.append({
            "rating": rating,
            "at": iso(at),
            "r_before": r_before,
            "state": card.state.value,
            "step": card.step,
            "stability": card.stability,
            "difficulty": card.difficulty,
            "due": iso(card.due),
            "last_review": iso(card.last_review),
        })
        prev = at
    return {"name": name, "desired_retention": retention, "start": iso(START), "steps": out}


def main(path):
    vectors = [run(n, 0.9, s) for n, s in SEQUENCES.items()]
    vectors += [run(n, r, s) for n, (r, s) in RETENTION_SEQUENCES.items()]
    vectors += [run(f"random_seed_{i}", 0.9, random_sequence(i)) for i in range(6)]
    with open(path, "w", encoding="utf-8") as f:
        json.dump(vectors, f, indent=1)
    print(f"wrote {len(vectors)} sequences to {path}")


if __name__ == "__main__":
    main(sys.argv[1])
