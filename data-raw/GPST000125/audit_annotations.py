from pathlib import Path
import json,re,collections
D=Path(__file__).resolve().parent
p=json.loads((D/'source-cell-records.json').read_text()); cells={};cur=None
for l in p['text'].splitlines():
 if l.startswith('TAB NAME: '):cur=l[10:-1];cells[cur]={}
 if l.startswith('{'):
  q=json.loads(l);cells[cur][q['cell']]=q
P={x['glytoucan_id']:x for x in json.loads((D/'glytoucan_parsed.json').read_text())}
seqs={x['id']['value'].split('/')[-1]:x['seq']['value'] for x in json.loads((D/'glytoucan_sequences.json').read_text())['results']['bindings']}
def generic_comp(comp):
 d=collections.Counter()
 for k,v in re.findall(r'([A-Za-z0-9]+)\((\d+)\)',comp):
  key={'Man':'H','Gal':'H','Glc':'H','Hex':'H','HexNAc':'N','GlcNAc':'N','GalNAc':'N','Fuc':'F','dHex':'F','Neu5Ac':'S'}.get(k)
  if key is None:return None
  d[key]+=int(v)
 return ''.join(k+str(d[k]) for k in 'HNFS' if d[k])
def base_wurcs(w):
 m=re.fullmatch(r'WURCS=2.0/(\d+),(\d+),(\d+)/((?:\[[^\]]+\])+)/([0-9-]+)/(.*)',w)
 if not m:return None
 units=re.findall(r'\[([^\]]+)\]',m[4]); inds=[int(x)-1 for x in m[5].split('-')]
 if len(inds)!=int(m[2]) or len(units)!=int(m[1]):return None
 types={'axxxxh-1x_1-5':'H','axxxxh-1x_1-5_2*NCC/3=O':'N','axxxxm-1x_1-5':'F','Aad21122h-2x_2-6_5*NCC/3=O':'S'}
 if not all(x in types for x in units):return None
 d=collections.Counter(types[units[x]] for x in inds)
 return ''.join(k+str(d[k]) for k in 'HNFS' if d[k])
def source_name_comp(n,kind):
 n=n.replace('\xa0',' ')
 if kind=='N':
  ts=re.findall(r'(LacdiNAc|SA|Gal|Glc|M|N|F)(\d+)',n)
  if ''.join(k+v for k,v in ts)!=n:return None
  d=collections.Counter()
  for k,v in ts:d[{'LacdiNAc':'N','SA':'S','Gal':'H','Glc':'H','M':'H','N':'N','F':'F'}[k]]+=int(v)*(2 if k=='LacdiNAc' else 1)
 elif kind=='GSL':
  ts=re.findall(r'(HexNAc|SA|Hex|F)(\d+)',n)
  if ''.join(k+v for k,v in ts)!=n.replace('+','').replace('Cer',''):return None
  d=collections.Counter()
  for k,v in ts:d[{'HexNAc':'N','SA':'S','Hex':'H','F':'F'}[k]]+=int(v)
 else:return None
 return ''.join(k+str(d[k]) for k in 'HNFS' if d[k])
if __name__=='__main__':
 s=cells['Table_S4_1'];out=[]
 for kind,rr in [('N',range(4,45)),('O',range(48,62)),('GSL',range(65,77))]:
  for r in rr:
   name=s['B'+str(r)]['value']; cid=re.findall(r'G\d{5}[A-Z]{2}',s['D'+str(r)]['value'])[0];ids=re.findall(r'G\d{5}[A-Z]{2}',s['E'+str(r)]['value'])
   cc=base_wurcs(seqs[cid]) or (generic_comp(P[cid]['parsed']['composition']) if P[cid]['parsed'] else None)
   sc=source_name_comp(name,kind)
   alt={i:generic_comp(P[i]['parsed']['composition']) if P[i]['parsed'] else None for i in ids}
   conflicts=[]
   if sc and cc and sc!=cc:conflicts.append('source_name_component_id_mismatch')
   if any(v is not None and v!=cc for v in alt.values()):conflicts.append('source_structure_component_id_mismatch')
   if sc and any(v is not None and v!=sc for v in alt.values()):conflicts.append('source_structure_name_mismatch')
   out.append({'type':kind,'row':r,'source_name':name,'component_id':cid,'component_composition':cc,'source_name_composition':sc,'candidate_compositions':alt,'conflicts':conflicts})
 (D/'annotation_audit.json').write_text(json.dumps(out,indent=2))
 for x in out:
  if x['conflicts'] or not x['component_composition']:print(x)
 print('Rows',len(out),'conflict rows',sum(bool(x['conflicts']) for x in out),'component known',sum(x['component_composition'] is not None for x in out))
