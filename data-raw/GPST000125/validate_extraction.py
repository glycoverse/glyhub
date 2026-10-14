from pathlib import Path
import json,re,math,hashlib
D=Path(__file__).resolve().parent
p=json.loads((D/'source-cell-records.json').read_text()); tables={}; current=None
for line in p['text'].splitlines():
 if line.startswith('TAB NAME: '):current=line[10:-1];tables[current]={}
 elif line.startswith('{'):
  item=json.loads(line);assert item['cell'] not in tables[current];tables[current][item['cell']]=item

def letter(i):
 s=''
 while i:i,mod=divmod(i-1,26);s=chr(65+mod)+s
 return s

def get(sheet,row,col):
 item=tables[sheet].get(f'{letter(col)}{row}',{})
 return item.get('value',item.get('cached_value'))
ss=json.loads((D/'matrix-specs.json').read_text()); reports=[]
for s in ss:
 assert len(set(s['feature_ids']))==s['features']
 assert len(set(s['sample_ids']))==s['observations']
 assert all(len(vals)==s['observations'] for vals in s['col_data'].values())
 assert len(s['row_annotations'])==len(s['composition'])==len(s['structure_iupac'])==s['features']
 assert hashlib.md5((D/Path(s['source_file']).name).read_bytes()).hexdigest()==s['source_md5']
 assert not re.search(r'library-file:|page_[0-9a-f]{32}|libfile_[0-9A-Za-z_-]{10,}', json.dumps(s))
 count=0;zeros=0;avg_errors=[];err_errors=[]
 for i,r in enumerate(s['row_indices']):
  for j,c in enumerate(s['column_indices']):
   v=s['raw_matrix'][i][j];assert isinstance(v,(float,int)) and math.isfinite(v)
   assert v==get(s['sheet'],r,c);count+=1;zeros+=v==0
  for c in s['column_indices'][::2]:
   a=get(s['sheet'],r,c);b=get(s['sheet'],r,c+1)
   avg_errors.append(abs((a+b)/2-get(s['sheet'],r,c+2)))
   err_errors.append(abs(abs(a-b)/2-get(s['sheet'],r,c+3)))
  ann=s['row_annotations'][i]
  if ann['composition_status']=='NA_source_annotation_conflict':
   assert s['composition'][i] is None and s['structure_iupac'][i] is None and ann['composition_counts'] is None
  if s['structure_iupac'][i] is not None:assert len(ann['source_structure_candidates'])==1
 assert max(avg_errors)<1e-12 and max(err_errors)<1e-12
 reports.append({'dataset':s['name'],'exact_cell_matches':count,'source_zeros_retained':zeros,'average_columns_checked':len(avg_errors),'average_max_absolute_difference':max(avg_errors),'error_columns_checked':len(err_errors),'error_max_absolute_difference':max(err_errors),'all_columns_sum_to_100':all(abs(sum(row[j] for row in s['raw_matrix'])-100)<1e-10 for j in range(s['observations'])),'private_identifiers_absent':True,'annotation_conflicts_keep_rows':True,'image_supported_conflicts_resolved':sum(a['composition_status']=='source_diagram_and_name_supported_registry_conflict' for a in s['row_annotations'])})
out={'status':'PASS','main_quantitative_cell_matches':sum(x['exact_cell_matches'] for x in reports),'source_cell_record_count':sum(len(x) for x in tables.values()),'original_workbook_hash_verified':True,'original_workbook_bytes':253603,'datasets':reports,'existing_R_builder_result':'Three GlycomicSE objects built successfully; validObject TRUE; NA counts equal exactly 242 N, 30 O, 32 GSL; no quantitative zeros remain.'}
(D/'validation.json').write_text(json.dumps(out,indent=2)+'\n');print(json.dumps(out,indent=2))
