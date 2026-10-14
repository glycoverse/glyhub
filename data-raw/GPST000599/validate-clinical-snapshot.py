"""Verify retained clinical values and source row mapping without changing data."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent
snapshot=json.load(open(P/'clinical-source-snapshot.json'))
mapping=json.load(open(P/'clinical-source-mapping.json'))['sample_mappings']
s=json.load(open(P/'matrix-specs.json'))[0]
fields={1:'survivorship',2:'sex',3:'age_years',4:'height_m',5:'weight_kg',6:'bmi',7:'disease_causing_pathogen',8:'baseline_APACHE',9:'baseline_SOFA',10:'total_icu_days',19:'overall_blood_products_received'}
def clean(x):return None if x in ['N/A','Unavailable','Unknown','N.A.','NA'] else x
assert len(mapping)==134
for i,m in enumerate(mapping):
 assert m['sample_id']==s['sample_ids'][i]
 row=snapshot['rows'][m['clinical_source_row']-1]
 assert row[0]==m['subject_id']
 for col,key in fields.items():assert clean(row[col])==s['col_data'][key][i]
 assert row[m['sampling_date_source_column']-1][:10]==s['col_data']['sampling_date'][i]
 assert m['metadata']=={k:v[i] for k,v in s['col_data'].items()}
original=P/'mmc4.xlsx'
if original.exists():
 assert hashlib.sha256(original.read_bytes()).hexdigest()==snapshot['source_sha256']
 import openpyxl,datetime
 rows=list(openpyxl.load_workbook(original,read_only=True,data_only=True)['Table S1'].values)
 def encode(x):return x.isoformat() if isinstance(x,(datetime.datetime,datetime.date)) else x
 assert [[encode(v) for v in r] for r in rows]==snapshot['rows']
 print('Verified original workbook hash, source cells, and all 134 clinical mappings.')
else:print('Verified all 134 clinical mappings against retained source-cell snapshot; original XLSX not present.')
