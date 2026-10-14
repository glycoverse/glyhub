#!/usr/bin/env python3
"""Extract annotated MALDI peak records without inventing cross-spectrum identity."""
from pathlib import Path
import collections,csv,hashlib,json,re
import openpyxl

OUT=Path(__file__).resolve().parent
FILENAME='41467_2026_70850_MOESM3_ESM.xlsx'
SOURCE=OUT/FILENAME
SOURCE_URL='https://media.springernature.com/original/springer-static/esm/art%3A10.1038%2Fs41467-026-70850-0/MediaObjects/41467_2026_70850_MOESM3_ESM.xlsx'
EXPECTED_SOURCE_SHA256='e5ea07ba142a319b98dce1540de4c74888a535cacfb29baa62aea7a8af62a87b'
assert SOURCE.is_file(), f'Missing required input: {SOURCE}'
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest()==EXPECTED_SOURCE_SHA256, 'Source workbook differs from the reviewed input'

ARTICLE_URL='https://www.nature.com/articles/s41467-026-70850-0'
DOI='10.1038/s41467-026-70850-0'
TITLE='Major human schistosome species express different glycans with immunological and diagnostic implications'
wb=openpyxl.load_workbook(SOURCE,data_only=True)
wf=openpyxl.load_workbook(SOURCE,data_only=False)
mapping=json.loads((OUT/'source-peaklist-mapping.json').read_text())
sha256=hashlib.sha256(SOURCE.read_bytes()).hexdigest()
md5=hashlib.md5(SOURCE.read_bytes()).hexdigest()
DATE='2026-10-14T10:11:00+00:00'
FIELDS=['measured_mz','signal_to_noise','resolution','peak_intensity','source_relative_intensity','peak_area','source_composition','source_accuracy_ppm','source_theoretical_mz','source_deviation']
SHEETS=[('(A) Sh GSL glycans','Sh_GSL','Schistosoma haematobium','GSL'),('(B) Sm GSL glycans','Sm_GSL','Schistosoma mansoni','GSL'),('(C) Sh N-glycans','Sh_N','Schistosoma haematobium','N'),('(D) Sm N-glycans','Sm_N','Schistosoma mansoni','N'),('(E) Sh O-glycans','Sh_O','Schistosoma haematobium','O')]
LICENSE={'name':'Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (article/Supplementary Information notice)', 'url':'https://creativecommons.org/licenses/by-nc-nd/4.0/', 'evidence_url':ARTICLE_URL+'#rightslink', 'source_scope':'Springer Nature Supplementary Data 1 / Table S1, MOESM3 workbook accompanying the article. Source bytes are from Springer, not a GlycoPOST quantitative-table deposit.', 'redistribution_review_required':True, 'redistribution_note':'The article notice restricts commercial use and sharing adapted material. Whether the factual extracted data are independently reusable is not established here. Do not substitute GlycoPOST raw-data repository terms for the actual source license; review before public packaging/distribution.'}

def save(name,obj):
 (OUT/name).write_text(json.dumps(obj,ensure_ascii=False,indent=2,allow_nan=False)+'\n')
def counts(label):
 core=re.sub(r'-(AA|redEnd)$','',label.strip())
 toks=re.findall(r'(HexNAc|HexA|dHex|Hex|Pen)(\d+)',core)
 if ''.join(a+b for a,b in toks)!=core: return None
 c=collections.Counter()
 for k,v in toks:c[k]+=int(v)
 return dict(c)
def parse_sample(label):
 stage=label.split(' - ')[0].split(' (PNG')[0].strip()
 if stage=='Eggs  (PNG-A)':stage='Eggs'
 stage=re.sub(r'\s*\(PNG-[AF]\).*','',stage).strip()
 rep=re.search(r'(biological|technical) replicate #(\d+)',label)
 enz=re.search(r'\(PNG-([AF])\)',label)
 fraction=next((x for x in ['Acidic fraction','Neutral fraction','Total'] if x in label),None)
 return {'life_stage':stage,'replicate_type':rep.group(1) if rep else None,'replicate_number':int(rep.group(2)) if rep else None,'fraction':fraction,'release_enzyme':('PNGase '+enz.group(1)) if enz else None,'figure_reference':label[label.find('Fig'):].strip() if 'Fig' in label else None}

def record(sh,b,bi,r,tag):
 c0=b['mz_column']; vals={f:sh.cell(r,c0+j).value for j,f in enumerate(FIELDS)}
 cells={f:sh.cell(r,c0+j).coordinate for j,f in enumerate(FIELDS)}
 forms={f:wf[sh.title].cell(r,c0+j).value for j,f in enumerate(FIELDS) if wf[sh.title].cell(r,c0+j).data_type=='f'}
 return {'source_peak_id':f'GPST000602::{tag}::spectrum_{bi:02d}::r{r:03d}', 'source_file':FILENAME, 'source_sheet':sh.title,'source_block_index':bi,'source_sample_label':b['sample_label'],'source_row':r,'source_block_first_column':c0,'source_column':b['intensity_column'],'source_assay_cell':sh.cell(r,b['intensity_column']).coordinate,'source_cells':cells,'source_values':vals,'source_formulas':forms}

specs=[];retained=[];removed=[];summary=[];groups=[];anomalies=[]
for sheet,tag,species,glytype in SHEETS:
 sh=wb[sheet];blocks=mapping[sheet]
 rows=[];per_sample=[];sample_ids=[];cd=collections.defaultdict(list);bycomp=collections.defaultdict(list)
 for bi,b in enumerate(blocks,1):
  actual_rows=[r for r in range(4,sh.max_row+1) if isinstance(sh.cell(r,b['mz_column']).value,(int,float))]
  assert actual_rows==b['rows'],(sheet,bi,'mapping does not cover all numeric source peaks')
  assert isinstance(sh.cell(2,b['mz_column']).value,str)
  assert sh.cell(2,b['mz_column']).value==b['sample_label']
  sample_ids.append(f'GPST000602_{tag}_spectrum_{bi:02d}')
  start=len(rows);drop_start=len(removed)
  for r in actual_rows:
   rec=record(sh,b,bi,r,tag); label=rec['source_values']['source_composition']
   if label is None or str(label).strip().lower() in ('','null','na','n/a','unknown','nd'):
    rec['exclusion_reason']='missing_composition_annotation' if label is None or not str(label).strip() else 'literal_null_composition_annotation'
    rec['user_selection_rule']='Retain only annotated rows; five source sheets remain five objects.'
    removed.append(rec);continue
   cc=counts(label)
   assert cc is not None,('unparsed annotated composition',rec)
   assert isinstance(rec['source_values']['peak_intensity'],(int,float)),rec
   rec['composition_counts']=cc
   rec['source_feature_label']=label
   rec['label_modification']=next((x for x in ['AA','redEnd'] if label.endswith('-'+x)),None)
   rec['annotation_level']='source_putative_glycan_composition'
   rec['feature_identity_basis']='source_sheet + source_spectrum_block + source_row; no cross-spectrum equivalence asserted'
   rec['calculated_mass_error_ppm']=None
   rec['source_mass_annotation_testable']=False
   rec['source_mass_annotation_flag']=False
   rec['source_mass_annotation_flag_reason']=None
   rec['source_reported_accuracy_ppm']=rec['source_values']['source_accuracy_ppm']
   mz=rec['source_values']['measured_mz'];theory=rec['source_values']['source_theoretical_mz']
   if isinstance(theory,(int,float)) and theory!=0:
    rec['source_mass_annotation_testable']=True
    rec['calculated_mass_error_ppm']=1e6*(mz-theory)/theory
    if abs(rec['calculated_mass_error_ppm'])>300:
     rec['source_mass_annotation_flag']=True
     rec['source_mass_annotation_flag_reason']='Calculated absolute mass error exceeds 300 ppm: 1e6 * abs(measured_mz - source_theoretical_mz) / abs(source_theoretical_mz). Review indicator only; source values and annotation are unchanged and the record remains included.'
     anomalies.append({'source_peak_id':rec['source_peak_id'],'sheet':sheet,'source_cells':rec['source_cells'],'measured_mz':mz,'source_theoretical_mz':theory,'calculated_mass_error_ppm':rec['calculated_mass_error_ppm'],'source_accuracy_ppm':rec['source_values']['source_accuracy_ppm'],'handling':'Preserved verbatim. No source correction or mass-tolerance filtering.'})
   rows.append(rec);retained.append(rec);bycomp[label].append(rec)
  per_sample.append({'sample_id':sample_ids[-1],'source_sample_label':b['sample_label'],'source_block_index':bi,'source_peaks':len(actual_rows),'retained_annotated_peaks':len(rows)-start,'removed_unannotated_peaks':len(removed)-drop_start})
  meta={'source_sample_label':b['sample_label'],'source_sheet':sheet,'source_block_index':bi,'source_label_cell':sh.cell(2,b['mz_column']).coordinate,'source_mz_column':b['mz_column'],'source_intensity_column':b['intensity_column'],'species':species,'source_species_abbreviation':tag.split('_')[0],'glycan_class':glytype,'assay_role':'MALDI_TOF_MS_spectrum','ion_mode':'positive' if glytype=='O' else 'negative','measured_ion':'[M+Na]+' if glytype=='O' else '[M-H]-','sample_preparation':'reduced and permethylated O-glycans' if glytype=='O' else '2-aminobenzoic-acid-labeled released glycans',**parse_sample(b['sample_label'])}
  for k,v in meta.items():cd[k].append(v)
 nr=len(rows);nc=len(blocks)
 raw=[[None]*nc for _ in rows];cover=[[False]*nc for _ in rows];source_rows=[[None]*nc for _ in rows];source_cols=[[None]*nc for _ in rows];source_text=[[None]*nc for _ in rows]
 for i,rec in enumerate(rows):
  j=rec['source_block_index']-1
  raw[i][j]=rec['source_values']['peak_intensity'];source_text[i][j]=rec['source_values']['peak_intensity'];cover[i][j]=True;source_rows[i][j]=rec['source_row'];source_cols[i][j]=rec['source_column']
 mat=[[None if v==0 else v for v in r] for r in raw]
 zero=[[i+1,j+1] for i,r in enumerate(raw) for j,v in enumerate(r) if v==0]
 for comp,records in bycomp.items():
  spectrum_counts=collections.Counter(r['source_block_index'] for r in records)
  theory=[r['source_values']['source_theoretical_mz'] for r in records if isinstance(r['source_values']['source_theoretical_mz'],(int,float))]
  groups.append({'sheet':sheet,'source_composition':comp,'composition_counts':records[0]['composition_counts'],'peak_count':len(records),'spectrum_count':len(spectrum_counts),'has_within_spectrum_multiplicity':any(v>1 for v in spectrum_counts.values()),'source_peak_ids':[r['source_peak_id'] for r in records],'source_theoretical_mz_values':sorted(set(theory)),'measured_mz_range':[min(r['source_values']['measured_mz'] for r in records),max(r['source_values']['measured_mz'] for r in records)],'used_for_alignment':False,'reason':'Composition and theoretical mass are candidate grouping evidence only; no author peak-level identity crosswalk. Distinct source peaks are never summed or assigned by row position.'})
 description=f'Annotated {species} {glytype}-glycan MALDI-TOF-MS peak-intensity records from Supplementary Data 1, sheet {sheet}; {nr} source-specific peak records across {nc} spectra.'
 details='Each retained source peak is a separate feature identified by sheet, spectrum block and row. The sparse matrix organizes spectrum-specific measurements without asserting cross-spectrum molecular identity. Off-spectrum entries have source_coverage=FALSE and are not measured missing values or biological absence. The object scope is one object per source worksheet across the five source worksheets. This object is not a ready-to-use cross-sample aligned feature matrix; cross-spectrum comparisons require an independently justified feature alignment. Only rows with a non-null author composition annotation are retained. Raw workbook bytes and complete retained/dropped cell-level ledgers preserve source evidence. No averaging, summation, normalization, imputation, mass filtering, peak selection by intensity, or raw-MS processing is performed. All retained numeric assay zeros become NA; nonzero values are unchanged. Putative compositions do not establish exact structures or distinguish isomers. AA and redEnd labels are stored separately from monosaccharide counts.'
 spec={'name':f'glyhub_GPST000602_{tag}','accession':'GPST000602','doi':DOI,'title':TITLE,'description':description,'details':details,'unit':'MALDI-TOF-MS peak intensity (source instrument units; arbitrary units)','source_quantitative_field':'Intens.','glycan_type':glytype,'source_glycan_type':glytype,'source_file':'data-raw/GPST000602/'+FILENAME,'source_url':SOURCE_URL,'sheet':sheet,'table':'Supplementary Data 1 / Table S1 - Raw MALDI-TOF-MS data','row_indices':[],'column_indices':[],'source_coordinate_mode':'per_cell_nonrectangular','source_cell_rows':source_rows,'source_cell_columns':source_cols,'source_coverage':cover,'raw_matrix':raw,'raw_source_matrix':source_text,'matrix':mat,'feature_ids':[r['source_peak_id'] for r in rows],'sample_ids':sample_ids,'composition':[''.join(f'{k}{v}' for k,v in r['composition_counts'].items()) for r in rows],'row_annotations':rows,'col_data':dict(cd),'zero_to_na':zero,'missing_policy':'Only quantitative numeric zero values are converted to null/NA. Off-spectrum unaligned combinations are null with source_coverage=false and no source coordinates. They are not measured zeros or measured missing values. Original source intensity values are preserved in raw_matrix.','source_sha256':sha256,'source_md5':md5,'reviewed_at':DATE,'feature_type':'source_specific_annotated_MALDI_peak_record','composition_dictionary':{'Hex':'hexose','HexNAc':'N-acetylhexosamine','HexA':'hexuronic acid','dHex':'deoxyhexose; not silently promoted to Fuc','Pen':'pentose; not silently promoted to Xyl','AA':'2-aminobenzoic acid label; excluded from monosaccharide counts','redEnd':'reduced end annotation; excluded from monosaccharide counts'},'license':LICENSE,'license_url':LICENSE['url'],'features':nr,'observations':nc,'source_files':[{'file':FILENAME,'url':SOURCE_URL,'sha256':sha256,'md5':md5}],'annotation':'All retained features have source putative composition annotations parsed to typed monosaccharide counts; exact glycan structures remain NA. Original labels, m/z values, all source block values and source formulas are preserved.','selection_rule':{'requested':'仅保留有注释的行，五个工作表分别作为5个对象','criterion':'Source Putative glycan composition is nonblank and not the literal null placeholder','removed_ledger':'data-raw/GPST000602/removed-row-ledger.json','retained_ledger':'data-raw/GPST000602/retained-peak-ledger.json','no_additional_filtering':True},'alignment_method':'source-namespaced per-spectrum sparse union; no cross-spectrum matching','alignment_assessment':'data-raw/GPST000602/alignment-audit.json','keep_source_sheet_as_separate_object':True,'prevent_study_type_merge':True}
 specs.append(spec)
 summary.append({'object':spec['name'],'sheet':sheet,'features':nr,'observations':nc,'source_peaks':sum(x['source_peaks'] for x in per_sample),'removed_unannotated':sum(x['removed_unannotated_peaks'] for x in per_sample),'retained_annotated':nr,'measured_cells':sum(sum(x) for x in cover),'unmeasured_unaligned_cells':nr*nc-nr,'quantitative_zeros_to_na':len(zero),'typed_compositions':sum(r['composition_counts'] is not None for r in rows),'typed_structures':0,'mass_annotation_review_flags':sum(r['source_mass_annotation_flag'] for r in rows),'samples':per_sample})

assert len(retained)==1607 and len(removed)==729
assert len({r['source_peak_id'] for r in retained+removed})==2336
save('matrix-specs.json',specs)
save('retained-peak-ledger.json',retained)
save('removed-row-ledger.json',{'accession':'GPST000602','source_file':FILENAME,'source_sha256':sha256,'selection_rule':'User-directed annotated rows only; remove only blank/literal-null source composition annotation.','removed_count':len(removed),'reason_counts':dict(collections.Counter(r['exclusion_reason'] for r in removed)),'rows':removed})
save('candidate-composition-groups.json',groups)
save('source-mass-annotation-anomalies.json',anomalies)
save('object-summary.json',summary)
for name,records in [('retained-peak-ledger.csv',retained),('removed-row-ledger.csv',removed)]:
 columns=['source_peak_id','source_file','source_sheet','source_block_index','source_sample_label','source_row','source_block_first_column','source_column','source_assay_cell','exclusion_reason']+FIELDS
 with (OUT/name).open('w',newline='') as f:
  writer=csv.DictWriter(f,fieldnames=columns);writer.writeheader()
  for r in records:writer.writerow({**{k:r.get(k) for k in columns if k not in FIELDS},**r['source_values']})
source_evidence={'article_url':ARTICLE_URL,'source_workbook_url':SOURCE_URL,'source_workbook_sha256':sha256,'article_title':TITLE,'doi':DOI,'source_definition_cells':{'sample_and_sheet_key':'Key!A3:C8','measurement_definitions':'Key!A11:B23','null_definition':'Key!B20'},'method_summary':'MALDI-TOF-MS source peak lists. AA-labeled GSL and N glycans were measured in negative mode; reduced permethylated O-glycans in positive mode. The Methods describe 300 ppm initial composition assignment, manual curation, and follow-up structural characterization of selected ions. No sample-level retention-time/structure crosswalk accompanies the 32 peak lists.','source_license':LICENSE}
save('source-evidence.json',source_evidence)
audit={'accession':'GPST000602','source_peaks':2336,'retained_annotated_peaks':1607,'removed_unannotated_peaks':729,'source_spectrum_blocks':32,'output_objects':5,'chosen_representation':'source-specific peak records in one sparse union per worksheet','cross_spectrum_alignment_performed':False,'row_number_alignment_performed':False,'composition_summing_performed':False,'assessed_methods':[{'method':'Align by workbook row number','decision':'Rejected','evidence':'The sheets contain independent m/z-sorted lists in column blocks, not shared rows. For example (A) Sh GSL A4=789.090 whereas K4=989.314.'},{'method':'Align solely by composition or composition + theoretical mass','decision':'Rejected as molecular-feature identity','evidence':'Two within-spectrum duplicate groups share exact composition and theoretical mass but distinct measured peaks: (A) Sh GSL BA42:BJ43 and BA59:BJ60. Selecting one, summing, or assigning by nearest order would lose/assume information.'},{'method':'Global measured-mass tolerance matching','decision':'Not used','evidence':'The article allows 300 ppm for initial putative composition assignment, not as a validated inter-spectrum feature matcher. This broad tolerance does not distinguish the same-composition duplicate peaks. Source theoretical-mass inconsistencies and varied sample fractions create further ambiguities.'},{'method':'Author-curated MOESM4/5/6 structure tables','decision':'Useful contextual annotation, insufficient crosswalk','evidence':'These characterize selected ions, often with multiple isomeric structures for one composition/theoretical mass, and do not map every MOESM3 sample-specific peak row to a unique structure/feature ID. MOESM4 Sh eggs, P7 and P9 explicitly refer to two isomeric structures.'}],'duplicate_composition_groups':[g for g in groups if g['has_within_spectrum_multiplicity']],'candidate_groups_file':'candidate-composition-groups.json','mass_annotation_anomalies_file':'source-mass-annotation-anomalies.json','anomalous_mass_record_count':len(anomalies),'row_annotation_flag_field':'source_mass_annotation_flag','mass_annotation_flag_rule':'Calculated absolute mass error >300 ppm; informational review flag only. Preserve source values, retain rows, and make no inferred corrections.','limitations':['There are 1607 retained peak records, not 1607 established unique molecular glycans.','Every feature has exactly one measured source spectrum. Off-spectrum NA is an unaligned/unmeasured combination, not absence.','Within-matrix between-sample differential abundance is not directly valid until feature correspondence is independently resolved.','Three measurements (Intens., %Intens., Area) are available. The assay uses direct source peak intensity; source relative intensity and area are retained verbatim as annotations and are not rescaled.','Article/SI license needs review before derived data redistribution.'], 'objects':summary, 'candidate_group_statistics':{'source_label_groups':len(groups),'groups_occurring_in_multiple_spectra':sum(g['spectrum_count']>1 for g in groups),'groups_within_spectrum_duplicates':sum(g['has_within_spectrum_multiplicity'] for g in groups)}}
save('alignment-audit.json',audit)
print(json.dumps({'objects':[(s['name'],s['features'],s['observations']) for s in specs],'retained':len(retained),'removed':len(removed),'anomalous_mass_records':len(anomalies),'duplicate_groups':len(audit['duplicate_composition_groups'])},indent=2))
