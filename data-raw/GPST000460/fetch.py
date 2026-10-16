import openpyxl,json,re,urllib.request,urllib.parse,pathlib
p=pathlib.Path(__file__).parent
w=openpyxl.load_workbook(p/'Supplemental_Tables_S3-S8.xlsx',data_only=True)
rows=[]
for n,r in enumerate(w['Table_S4'].values,1):
 if n<3 or r[0] is None:continue
 rows.append(dict(source_row=n,glycan_number=r[0],source_composition=r[6],glytoucan_id=r[7],rrt=r[8]))
json.dump(rows,open(p/'source-mapping.json','w'),indent=2)
ids=sorted({m for r in rows for m in re.findall(r'G\d{5}[A-Z]{2}',str(r['glytoucan_id']))})
b=[];qs=[]
for i in range(0,len(ids),30):
 q='PREFIX glycan: <http://purl.jp/bio/12/glyco/glycan#> SELECT ?id ?seq ?format WHERE { VALUES ?id { '+' '.join('<http://rdf.glycoinfo.org/glycan/'+x+'>' for x in ids[i:i+30])+' } ?id glycan:has_glycosequence ?s . ?s glycan:has_sequence ?seq ; glycan:in_carbohydrate_format ?format . }'
 url='https://ts.glytoucan.org/sparql?'+urllib.parse.urlencode({'query':q,'format':'application/sparql-results+json'});z=json.load(urllib.request.urlopen(url,timeout=90));b+=z['results']['bindings'];qs.append({'query':q,'url':url});print(i,len(z['results']['bindings']),flush=True)
json.dump({'results':{'bindings':[x for x in b if 'wurcs' in x['format']['value'].lower()]}},open(p/'glytoucan_sequences.json','w'),indent=2)
json.dump(qs,open(p/'queries.json','w'),indent=2)
print('source rows',len(rows),'ids',len(ids))
