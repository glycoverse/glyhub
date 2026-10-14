#!/usr/bin/env python3
"""Independently pivot saved public Panorama query JSONs; optionally compare reviewed specs.
Usage: python validate_gpst000128_source.py --source-dir PATH --spec FILE --output FILE
Standard library only. No network, raw-MS processing, or absolute workspace paths.
Inputs are complete public query-selectRows.api snapshots (query.maxRows=2000).
"""
import argparse, collections, json, pathlib, re, sys
from urllib.parse import urlparse, parse_qs

def read_snapshot(root, name):
    paths=list(root.rglob(name+'.json'))
    if len(paths)!=1: raise ValueError(f'Expected exactly one {name}.json under {root}; found {len(paths)}')
    obj=json.loads(paths[0].read_text())
    if len(obj['rows'])!=obj['rowCount']: raise ValueError(f'Incomplete snapshot: {name}')
    return obj['rows']

def unique(rows, key):
    out={r[key]:r for r in rows}
    if len(out)!=len(rows): raise ValueError(f'Duplicate key {key}')
    return out

def composition(name):
    counts={}
    aliases={'Man':'Hex','GlcNAc':'HexNAc','Deoxyhexose':'Fuc'}
    for token, count in re.findall(r'\((HexNAc|Hex|Deoxyhexose|NeuAc|NeuGc|Man|GlcNAc)\)(\d+)',name):
        token=aliases.get(token,token);counts[token]=counts.get(token,0)+int(count)
    glucose=re.fullmatch(r'Glc\((\d+)\)',name)
    if glucose: counts={'Hex':int(glucose.group(1))}
    short=None if not counts or counts.get('NeuGc') else ''.join(k+str(counts[n]) for k,n in [('H','Hex'),('N','HexNAc'),('F','Fuc'),('S','NeuAc')] if counts.get(n))
    return counts,short

def reconstruct(root):
    molecules=unique(read_snapshot(root,'Molecule'),'Id')
    precursors=read_snapshot(root,'MoleculePrecursor');unique(precursors,'Id')
    replicates=unique(read_snapshot(root,'Replicate'),'Id')
    files=unique(read_snapshot(root,'SampleFile'),'Id')
    rows=read_snapshot(root,'PrecursorChromInfo')
    areas={(r['PrecursorId'],r['SampleFileId']):r for r in rows}
    if len(areas)!=len(rows): raise ValueError('Duplicate precursor/sample quantitative record; refusing aggregation')
    out=[];used=set()
    # Verified document IDs from public Panorama experiment 986.
    for run,kind in [(92565,'N'),(92564,'O')]:
        selected=[]
        for precursor in precursors:
            url=precursor['_labkeyurl_MoleculeId/Molecule']
            mid=int(parse_qs(urlparse(url).query)['id'][0])
            molecule=molecules[mid]
            if molecule['PeptideGroupId/RunId/File']==run: selected.append((precursor,molecule))
        sample_files=sorted([f for f in files.values() if replicates[f['ReplicateId']]['RunId']==run],key=lambda f:replicates[f['ReplicateId']]['Name'])
        raw=[];normalized=[];annotations=[];shorts=[]
        for precursor,molecule in selected:
            values=[];norm=[]
            for f in sample_files:
                key=(precursor['Id'],f['Id'])
                if key not in areas: raise ValueError(f'Missing source quantitative record {key}; not silently filling')
                record=areas[key];used.add(key)
                values.append(record['TotalArea']);norm.append(record['TotalAreaNormalized'])
            raw.append(values);normalized.append(norm)
            counts,short=composition(molecule['CustomIonName']);shorts.append(short)
            annotations.append({'precursor_id':precursor['Id'],'molecule_id':molecule['Id'],'source_molecule_name':molecule['CustomIonName'],'composition_counts':counts,'charge':precursor['Charge'],'mz':precursor['Mz'],'source_standard_type':molecule['StandardType'],'source_group':molecule['PeptideGroupId/Label']})
        sample_ids=[replicates[f['ReplicateId']]['Name'] for f in sample_files]
        if len(set(sample_ids))!=len(sample_ids): raise ValueError('Duplicate sample names')
        out.append({'name':'gpst000128_'+kind.lower()+'_precursor','accession':'GPST000128','glycan_type':kind,'panorama_run_id':run,'feature_ids':[str(p['Id']) for p,m in selected],'sample_ids':sample_ids,'raw_matrix':raw,'matrix':[[None if x==0 else x for x in r] for r in raw],'composition':shorts,'row_annotations':annotations,'source_sample_file_ids':[f['Id'] for f in sample_files],'source_normalized_area':normalized})
    if used!=set(areas): raise ValueError('Unaccounted-for source quantitative records')
    return out

def compare(actual,expected):
    errors=[]
    for a in actual:
        matches=[s for s in expected if s.get('name','').lower().removeprefix('glyhub_')==a['name']]
        if len(matches)!=1: errors.append('Missing/duplicate reviewed spec '+a['name']);continue
        e=matches[0]
        for field in ['feature_ids','sample_ids','raw_matrix','matrix','composition']:
            if a[field]!=e.get(field): errors.append(a['name']+': mismatch '+field)
        if len(a['row_annotations'])!=len(e.get('row_annotations',[])):
            errors.append(a['name']+': annotation length');continue
        for i,(ar,er) in enumerate(zip(a['row_annotations'],e['row_annotations'])):
            for field in ['precursor_id','molecule_id','source_molecule_name','charge','mz','source_standard_type','source_group','composition_counts']:
                if ar[field]!=er.get(field):errors.append(a['name']+f': annotation row {i+1} mismatch {field}')
    return errors

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--source-dir',type=pathlib.Path,required=True);p.add_argument('--spec',type=pathlib.Path);p.add_argument('--output',type=pathlib.Path);a=p.parse_args()
    objects=reconstruct(a.source_dir)
    if a.output:a.output.write_text(json.dumps(objects,ensure_ascii=False,indent=2))
    if a.spec:
        expected=json.loads(a.spec.read_text())
        if isinstance(expected,dict):expected=expected.get('objects',expected.get('specs',[expected]))
        errors=compare(objects,expected)
        if errors:
            print('\n'.join(errors),file=sys.stderr);return 1
    print(json.dumps({'status':'passed','objects':[{'name':o['name'],'shape':[len(o['feature_ids']),len(o['sample_ids'])],'source_records':sum(len(r) for r in o['raw_matrix']),'source_zeros':sum(v==0 for r in o['raw_matrix'] for v in r if v is not None)} for o in objects]},indent=2));return 0
if __name__=='__main__':sys.exit(main())
