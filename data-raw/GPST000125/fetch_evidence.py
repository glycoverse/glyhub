from pathlib import Path
import json,re,urllib.request,urllib.parse,hashlib,time,concurrent.futures
D=Path(__file__).resolve().parent
p=json.loads((D/'source-cell-records.json').read_text())
ids=sorted(set(re.findall(r'G[0-9]{5}[A-Z]{2}',p['text'])))
print('IDS',len(ids),flush=True)
url='https://pmc.ncbi.nlm.nih.gov/articles/instance/8086148/bin/NIHMS1683936-supplement-5.xlsx'
try:
 with urllib.request.urlopen(url,timeout=35) as r:
  b=r.read();ct=r.headers.get('Content-Type');final=r.url
 meta={'requested_url':url,'final_url':final,'content_type':ct,'bytes':len(b),'sha256':hashlib.sha256(b).hexdigest(),'xlsx_magic':b[:4]==b'PK\x03\x04'}
 if meta['xlsx_magic']:(D/'mmc5.xlsx').write_bytes(b)
 (D/'public_download_check.json').write_text(json.dumps(meta,indent=2));print('PUBLIC',meta,flush=True)
except Exception as e:print('PUBLIC FAILED',str(e),flush=True)
query_prefix='PREFIX glycan: <http://purl.jp/bio/12/glyco/glycan#> SELECT ?id ?seq ?format WHERE { VALUES ?id { '
queries=[query_prefix+' '.join('<http://rdf.glycoinfo.org/glycan/'+i+'>' for i in ids[n:n+40])+' } ?id glycan:has_glycosequence ?s . ?s glycan:has_sequence ?seq ; glycan:in_carbohydrate_format ?format . }' for n in range(0,len(ids),40)]
(D/'glytoucan_queries.json').write_text(json.dumps(queries,indent=2))
def fetch(pair):
 n,q=pair;u='https://ts.glytoucan.org/sparql?'+urllib.parse.urlencode({'query':q,'format':'application/sparql-results+json'})
 with urllib.request.urlopen(u,timeout=90) as r:p=json.load(r)
 (D/f'glytoucan_batch_{n+1}.json').write_text(json.dumps(p,indent=2));print('GTC BATCH',n+1,len(p['results']['bindings']),flush=True)
 return p['results']['bindings']
with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:allrows=[x for rows in pool.map(fetch,enumerate(queries)) for x in rows]
(D/'glytoucan_sequences.json').write_text(json.dumps({'results':{'bindings':allrows}},indent=2))
print('COMPLETE',len(allrows),flush=True)
