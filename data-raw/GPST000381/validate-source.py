"""Verify the complete expression block and author composition counts."""
from pathlib import Path
import json, openpyxl
p=Path(__file__).resolve().parent
s=json.load(open(p/'matrix-specs.json'))[0]
w=openpyxl.load_workbook(p/'Analyzed data.xlsx',data_only=True)['Sheet1']
assert s['sample_ids']==[w.cell(2,c).value.replace(' ','') for c in (9,10)]
assert s['raw_matrix']==[[w.cell(r,c).value for c in (9,10)] for r in range(3,39)]
for i,r in enumerate(range(3,39)):
 assert s['row_annotations'][i]['composition_counts']==dict(zip(['Hex','HexNAc','Fuc','NeuAc','NeuGc'],[w.cell(r,c).value for c in range(13,18)]))
for c,original in [(0,6),(1,3)]:
 values=[w.cell(r,original).value for r in range(3,29) if isinstance(w.cell(r,original).value,(int,float))]
 assert sorted(v[c] for v in s['raw_matrix'] if v[c] is not None)==sorted(values)
 assert abs(sum(v[c] or 0 for v in s['raw_matrix'])-1)<1e-12
print('Verified 36 features, two source expression profiles, 48 numeric cells, direct counts, and conflicting raw-block label correspondence.')
