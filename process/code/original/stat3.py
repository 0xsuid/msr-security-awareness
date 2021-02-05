import csv
import datetime
import collections
import statistics 

# > 150 fixes in any of the languages
CWE = [
        "CWE-79",
        "CWE-399",
        "CWE-200",
        "CWE-20",
        "CWE-264",
        "CWE-400",
        "CWE-119",
        "CWE-22"
      ]
JS_CSV = "result_js.csv"
PY_CSV = "result_py.csv"
js_reader = csv.reader(open(JS_CSV, 'r'), delimiter=',', quotechar='"')
py_reader = csv.reader(open(PY_CSV, 'r'), delimiter=',', quotechar='"')

next(js_reader)
next(py_reader)
for r in js_reader, py_reader:
    print(r)
    y_dict = collections.defaultdict(list)
    for row in r:
        if row[5]:
            cwe = row[4]
            if cwe not in CWE:
                continue
            commit_date = datetime.datetime.strptime(row[2].split('+')[0], '%Y-%m-%d %H:%M:%S')
            publish_date = datetime.datetime.strptime(row[5], '%Y-%m-%dT%H:%MZ')
            delta = (commit_date-publish_date).days if (commit_date-publish_date).days>0 else 0
            y_dict[cwe].append(delta)
    for y in y_dict.keys():
        print(f"{y},{statistics.mean(y_dict[y])}")