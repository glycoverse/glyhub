import json,re,collections,pathlib
p=pathlib.Path(__file__).parent;r=json.load(open(p/'source-mapping.json'));g=json.load(open(p/'glytoucan_parsed.json'));m={x['glytoucan_id']:x for x in g}
for x in r:
 a=m.get(x['glytoucan_id']);x['registry_annotation']=a
 src=collections.Counter()
 for k,v in re.findall('(GlcNAc|GalNAc|NeuAc|NeuGc|Neu5Ac|Neu5Gc|HexNAc|Man|Gal|Glc|Fuc|Hex)([0-9]+)',x['source_composition']):src[{'NeuAc':'Neu5Ac','NeuGc':'Neu5Gc'}.get(k,k)]+=int(v)
 x['source_full_composition_counts']=dict(src)
 if not a or not a['parsed']:
  x['composition_counts_match_registry']=None;x['annotation_status']='registry_parse_failed';print('failed',x['glycan_number'],a['error'] if a else 'missing');continue
 dst=dict((k,int(v)) for k,v in re.findall(r'([A-Za-z0-9]+)\(([0-9]+)\)',a['parsed']['composition']))
 x['composition_counts_match_registry']=src==dst
 x['annotation_status']='consistent' if src==dst else 'source_registry_composition_conflict'
 if src!=dst:print('mismatch',x['glycan_number'],x['source_composition'],dict(src),dst)
json.dump(r,open(p/'verified-mapping.json','w'),indent=2)
print(collections.Counter(x['annotation_status'] for x in r))
