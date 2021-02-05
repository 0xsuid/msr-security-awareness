import csv
import datetime
import collections
import os
import statistics


JS_CSV = os.path.join("..", "data", "count_cwe_groups_by_year_js.csv")
PY_CSV = os.path.join("..", "data", "count_cwe_groups_by_year_py.csv")
# js_reader = csv.reader(open(JS_CSV, 'r'), delimiter=',', quotechar='"')
# py_reader = csv.reader(open(PY_CSV, 'r'), delimiter=',', quotechar='"')

for f in [JS_CSV, PY_CSV]:
    r = csv.reader(open(f, 'r'), delimiter=',', quotechar='"')
    yearly = dict()
    print(r)
    for row in r:
        cwe = row[1]
        year = int(row[0])
        count = int(row[2])
        if year not in yearly:
            yearly[year] = count
        yearly[year] += count
        print(row)

    out = "yearly_commits_"+f[-6:]
    with open(out, "w", encoding="utf8") as fp:
        for y, c in yearly.items():
            fp.write(f"{y};{c}\n")
