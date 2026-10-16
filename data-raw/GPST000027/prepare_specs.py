"""Build the reviewed brain panel mapping from the double-checked S2C transcription."""
from pathlib import Path
from collections import Counter
import csv
import hashlib
import json
import math
import re

D = Path(__file__).resolve().parent
source = D / "152506_2_supp_372524_pvkzw0.pdf"
sha = "a9393edfc7c67eb19e6d5e59919813fd18e4369489744e84950cbca048b1df72"
assert hashlib.sha256(source.read_bytes()).hexdigest() == sha
rows = json.loads((D / "brain_s2c_features.json").read_text())
independent = list(csv.DictReader((D / "independent_s2c_numeric.csv").open()))
assert len(rows) == len(independent) == 51
annotations, raw, percent, labels = [], [], [], []
for i, (r, other) in enumerate(zip(rows, independent), 1):
    assert r["source_feature_label"] == other["feature"]
    values = [r["WT_peak_intensity"], r["KO_peak_intensity"]]
    rel = [float(r["WT_relative_abundance_percent_source"]), float(r["KO_relative_abundance_percent_source"])]
    assert values == [int(other["WT_EIC"]), int(other["KO_EIC"])]
    assert rel == [float(other["WT_relative_percent"]), float(other["KO_relative_percent"])]
    for j, denominator in enumerate([979000, 745500]):
        assert abs(rel[j] - values[j] / denominator * 100) <= 0.05000000001
    comp = r["source_composition"]
    assert "," not in comp
    assert re.sub(r"\(([^()]+)\)(\d+)|[+\s]", "", comp) == ""
    counts = Counter()
    for residue, count in re.findall(r"\(([^()]+)\)(\d+)", comp):
        counts[{"Deoxyhexose": "dHex"}.get(residue, residue)] += int(count)
    assert counts["Man"] == 3 and counts["GlcNAc"] == 2
    a = dict(r)
    a.update(source_table_row=i, composition_counts=dict(counts),
             composition_status="single_source_composition", structure_status="no_validated_topology")
    annotations.append(a)
    raw.append(values)
    percent.append(rel)
    labels.append(r["source_feature_label"])
assert len(set(labels)) == 51
assert [sum(r[j] for r in raw) for j in range(2)] == [1887230, 1762838]
assert [sum(r[j] == 0 for r in raw) for j in range(2)] == [3, 12]
kidney = json.loads((D.parent / "GPST000031/matrix-specs.json").read_text())[0]
s = {
    "name": "glyhub_GPST000027_N_Brain", "accession": "GPST000027",
    "doi": kidney["doi"], "title": "Mgat3 wild-type and knockout mouse brain N-glycan profiles",
    "description": "Complete Supplementary Figure S2C brain N-glycan peak table, retaining 51 chromatographic features across WT and Mgat3 KO profiles.",
    "details": "Source peak intensities are retained without averaging or renormalization. Original percentages are separately preserved to the printed one-decimal precision and are normalized to the high-mannose sum, not total glycome. The two accession raw filenames indicate TMT6 126/127 labels, but S2C does not identify exact runs or replicate numbers. File-to-column links are genotype/filename-based candidates, not confirmed source identifiers. The article reports three independent brain pairs, while this published table provides only two genotype-labelled columns; these are not expanded or assumed to be individual biological replicates. Cross-tissue intensity comparability is not inferred.",
    "unit": "source EIC peak intensity (instrument units)", "glycan_type": "N", "source_glycan_type": "N",
    "source_file": "data-raw/GPST000027/" + source.name,
    "source_url": "https://pmc.ncbi.nlm.nih.gov/articles/PMC6773561/",
    "source_md5": hashlib.md5(source.read_bytes()).hexdigest(), "source_sha256": sha,
    "sheet": "Supplementary Figure S2C (PDF page 4)", "row_indices": list(range(1, 52)),
    "column_indices": [1, 2], "feature_ids": labels, "sample_ids": ["Mgat3+/+", "Mgat3-/-"],
    "row_annotations": annotations, "composition": [None] * 51,
    "col_data": {
        "source_sample_name": ["Mgat3+/+", "Mgat3-/-"], "source_genotype": ["Mgat3+/+", "Mgat3-/-"],
        "condition": ["WT", "KO"], "organism": ["Mus musculus"] * 2, "tissue": ["brain"] * 2,
        "source_run_id": [None, None], "label": ["TMT6 (accession raw filenames)"] * 2,
        "source_run_id_candidate": ["15071834", "15071835"],
        "label_channel_candidate": ["126", "127"],
        "raw_file_mapping_basis": ["genotype and filename in accession; S2C has no run or replicate identifier"] * 2,
        "raw_file_mapping_status": ["inferred_candidate"] * 2,
        "source_accession": ["GPST000027"] * 2,
        "source_raw_file": [None, None],
        "source_raw_file_candidate": ["15071834_WT_TMT6_126.RAW", "15071835_GnT3KO_TMT6_127.RAW"],
        "replicate_type": [None] * 2,
    },
    "raw_matrix": raw, "raw_source_matrix": raw, "source_relative_abundance": percent,
    "high_mannose_denominator": [979000, 745500], "relative_percent_printed_digits": 1,
    "conflict_columns": [], "annotation": "Source composition groups retain generic residues plus the explicit Man3GlcNAc2 core. All 51 chromatographic features remain distinct. No validated topology is assigned.",
    "license": kidney["license"], "object_class": "GlycomicSE",
    "transcription_validation": {"primary": json.loads((D / "validation_primary.json").read_text()), "independent": json.loads((D / "validation_independent.json").read_text())},
}
s["license"] = dict(kidney["license"], evidence_scope="Publisher-deposited article version-of-record license metadata, effective 2020-09-19. The Supplemental Figures PDF has no separate file-specific license declaration; no additional restriction was located.")
(D / "matrix-specs.json").write_text(json.dumps([s], indent=2, ensure_ascii=False) + "\n")
print("Validated 51 brain features, 102 intensities, 102 rounded percentages and all source sums.")
