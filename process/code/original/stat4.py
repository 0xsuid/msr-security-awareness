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
JS_CSV = "count_cwe_groups_by_year_js.csv"
PY_CSV = "count_cwe_groups_by_year_py.csv"
js_reader = csv.reader(open(JS_CSV, 'r'), delimiter=',', quotechar='"')
py_reader = csv.reader(open(PY_CSV, 'r'), delimiter=',', quotechar='"')

years = [i for i in range(2006, 2020)]

next(js_reader)
next(py_reader)
y_dict = {cwe: [0]*len(years) for cwe in CWE}
for r in js_reader, py_reader:
    print(r)
    for row in r:
        cwe = row[1]
        year = int(row[0])
        count = int(row[2])
        if cwe not in CWE:
            continue
        y_dict[cwe][years.index(year)] = count
    for y in y_dict.keys():
        str_list = map(lambda x: str(x), y_dict[y])
        print(f"{y},{','.join(str_list)}")