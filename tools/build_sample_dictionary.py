"""Build assets/dictionary.sqlite from the hand-written 20-word sample.

Temporary: lets the app run before tools/build_dictionary.py (Dev 2) exists.
Usage: python tools/build_sample_dictionary.py lib/data/db/dictionary.drift test/fixtures/dictionary_sample.sql assets/dictionary.sqlite
"""
import os
import sqlite3
import sys

schema, sample, out = sys.argv[1:4]
if os.path.exists(out):
    os.remove(out)
con = sqlite3.connect(out)
con.executescript(open(schema, encoding="utf-8").read())
con.executescript(open(sample, encoding="utf-8").read())
con.execute("PRAGMA user_version = 1")
con.commit()
con.execute("VACUUM")
con.close()
print("wrote", out)
