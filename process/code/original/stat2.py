import csv

js_csv = "count_cwe_groups_js.csv"
py_csv = "count_cwe_groups_py.csv"

js_r = csv.reader(open(js_csv, 'r'), delimiter=',', quotechar='"')
py_r = csv.reader(open(py_csv, 'r'), delimiter=',', quotechar='"')

js_cwe = dict()
py_cwe = dict()

next(js_r)
next(py_r)

for row in js_r:
    js_cwe[row[0]] = row[1]
    
for row in py_r:
    py_cwe[row[0]] = row[1]
    
cwes = set(js_cwe.keys())
cwes.update(py_cwe.keys())

print(f"JS CWEs: {len(js_cwe.keys())}, Py CWEs: {len(py_cwe.keys())}, Common: {len(cwes)}")

for cwe in cwes:
    js_count = js_cwe[cwe] if cwe in js_cwe.keys() else 0
    py_count = py_cwe[cwe] if cwe in py_cwe.keys() else 0
    if int(js_count) > 10 or int(py_count) > 10:
        print(f"{cwe},{js_count},{py_count}")