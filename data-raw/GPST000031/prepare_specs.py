"""Extract the complete, checksum-pinned Supplemental Table S2 kidney matrix.

Run from the package root with Python and xlrd. This reads cached original XLS
cells; no formulas, macros, chart streams, or other embedded code are executed.
"""
from collections import Counter
from pathlib import Path
import hashlib
import json
import math
import re

import xlrd

D = Path(__file__).resolve().parent
SOURCE = D / "152506_2_supp_372529_pvkzs0.xls"
SHA256 = "854f238cc3507723d095d810bb6b8e40f6d21c98ebb8a1d51c2f08429e2e7ad2"
assert hashlib.sha256(SOURCE.read_bytes()).hexdigest() == SHA256
sheet = xlrd.open_workbook(SOURCE).sheet_by_name("WT&Mgat3KO")
assert (sheet.nrows, sheet.ncols) == (294, 21)
cells = [sheet.row_values(i) for i in range(sheet.nrows)]
sample_ids = cells[1][9:13]
run_ids = [str(int(v)) for v in cells[0][9:13]]
assert sample_ids == ["WT1K_TMT", "KO3K_TMT", "WT2K_TMT", "KO4K_TMT"]
assert run_ids == ["19060303", "19060304", "19060305", "19060306"]
genotypes = cells[3][9:13]
denominators = cells[291][9:13]
assert cells[291][7] == "SUM of Hign Man"


def composition_counts(label):
    # The author's explicit (Man)3(GlcNAc)2 core is additive, not redundant.
    # Preserve generic Hex/HexNAc/dHex rather than assuming Gal/GlcNAc/Fuc.
    tokens = re.findall(r"\(([^()]+)\)(\d+)", label)
    assert re.sub(r"\(([^()]+)\)(\d+)|[+\s]", "", label) == ""
    counts = Counter()
    for residue, count in tokens:
        assert residue in {"Hex", "HexNAc", "Deoxyhexose", "Man", "GlcNAc", "NeuAc", "NeuGc"}
        counts[{"Deoxyhexose": "dHex"}.get(residue, residue)] += int(count)
    assert counts["Man"] == 3 and counts["GlcNAc"] == 2
    return dict(counts)


annotations, raw, percent, ids = [], [], [], []
number, label, label_row = None, None, None
for excel_row in range(5, 292):
    row = cells[excel_row - 1]
    if row[0] != "":
        number = int(row[0])
        assert row[6] != "", "A new source number must supply its own composition"
    if row[6] != "":
        label, label_row = row[6], excel_row
    assert number is not None and label is not None
    suffix = row[1]
    feature_id = str(number) + suffix
    candidates = [v.strip() for v in label.split(",")]
    candidate_counts = [composition_counts(v) for v in candidates]
    values = row[9:13]
    relative = row[13:17]
    assert all(isinstance(v, (int, float)) and math.isfinite(v) and v >= 0 for v in values + relative)
    for j in range(4):
        assert math.isclose(relative[j], values[j] / denominators[j] * 100, rel_tol=1e-12, abs_tol=1e-12)
    annotations.append({
        "source_excel_row": excel_row,
        "source_number": number,
        "source_suffix": suffix,
        "source_feature_id": feature_id,
        "source_composition_cell": row[6],
        "source_composition": label,
        "source_composition_row": label_row,
        "source_composition_inherited": row[6] == "",
        "candidate_compositions": candidates,
        "candidate_composition_counts": candidate_counts,
        "composition_counts": candidate_counts[0] if len(candidates) == 1 else None,
        "composition_status": "single_source_composition" if len(candidates) == 1 else "multiple_source_candidates",
        "source_observed_mass_4H": row[2],
        "source_observed_mass_3H": row[3],
        "source_observed_mass_2H": row[4],
        "source_calculated_mass_M_plus_H": row[5],
        "source_EIC_mz": row[7],
        "source_charge": row[8],
        "source_diagnostic_ms2_scan_ids": row[17:21],
        "structure_status": "no_validated_topology",
    })
    ids.append(feature_id)
    raw.append(values)
    percent.append(relative)

assert len(ids) == len(set(ids)) == 287
assert len(set(a["source_number"] for a in annotations)) == 89
ambiguous = [a["source_feature_id"] for a in annotations if a["composition_counts"] is None]
assert len(ambiguous) == 32
zeros = [sum(row[j] == 0 for row in raw) for j in range(4)]
assert zeros == [28, 123, 29, 129]
all_zero = [ids[i] for i, row in enumerate(raw) if all(v == 0 for v in row)]
assert len(all_zero) == 5
assert [sum(row[j] for row in raw) for j in range(4)] == cells[293][9:13]

description = "Complete Supplemental Table S2 kidney N-glycan EIC peak-intensity matrix from two Mgat3 wild-type and two Mgat3 knockout source-labelled samples/runs."
details = (
    "All 287 author-labelled chromatographic features and all four quantitative columns are retained, including 32 features with multiple candidate compositions and five all-zero source features. "
    "The assay contains the source EIC peak intensities, not reporter-ion intensities or total-glycome-normalized percentages. Only assay zeros become NA; raw values and masks are retained. "
    "The original percentage block is retained separately as metadata(x)$source_relative_abundance. Each percentage is intensity divided by the corresponding source high-mannose intensity sum, multiplied by 100; column totals can exceed 100%. "
    "No averaging, imputation, rescaling, candidate expansion or composition-based feature collapse is performed. "
    "The source sample names and run IDs exactly match the four kidney raw files under GPST000031. The related brain accession GPST000027 is not represented by this workbook. "
    "The source distinguishes WT and KO samples but does not establish independent biological replication, pairing, sex or age; these are not inferred. "
    "Diagnostic MS/MS scan identifiers are retained as evidence, not interpreted as a complete structural assignment."
)
annotation = (
    "255 features have one source composition, encoded with the explicit Man3GlcNAc2 core plus the stated generic residues; Deoxyhexose maps to generic dHex rather than assumed Fuc. "
    "For the 32 multiple-candidate features, typed composition is NA while every candidate and original string remains in source_annotations. "
    "Chromatographic subpeak suffixes remain distinct even when compositions are identical. No feature has a validated topology, so no glycan_structure column is created."
)
spec = {
    "name": "glyhub_GPST000031_N_Kidney",
    "accession": "GPST000031",
    "doi": "10.1074/mcp.RA119.001534",
    "title": "Mgat3 wild-type and knockout mouse kidney N-glycan profiles",
    "description": description,
    "details": details,
    "unit": "source EIC peak intensity (instrument units)",
    "glycan_type": "N",
    "source_glycan_type": "N",
    "source_file": "data-raw/GPST000031/" + SOURCE.name,
    "source_url": "https://pmc.ncbi.nlm.nih.gov/articles/PMC6773561/",
    "source_md5": hashlib.md5(SOURCE.read_bytes()).hexdigest(),
    "source_sha256": SHA256,
    "sheet": sheet.name,
    "row_indices": list(range(5, 292)),
    "column_indices": [10, 11, 12, 13],
    "feature_ids": ids,
    "sample_ids": sample_ids,
    "row_annotations": annotations,
    "composition": [None] * len(ids),
    "col_data": {
        "source_sample_name": sample_ids,
        "source_run_id": run_ids,
        "source_genotype": genotypes,
        "condition": ["WT", "KO", "WT", "KO"],
        "organism": ["Mus musculus"] * 4,
        "tissue": ["kidney"] * 4,
        "label": ["aminoxyTMT0"] * 4,
        "source_accession": ["GPST000031"] * 4,
        "raw_file_mapping_basis": ["exact workbook run ID and sample-label match to accession raw filename"] * 4,
        "raw_file_mapping_status": ["exact_source_id_match"] * 4,
        "source_raw_file": ["19060303_WT1_TMT0_kidney.raw", "19060304_GnT3KO3_TMT0_kidney.raw", "19060305_WT2_TMT0_kidney.raw", "19060306_GnT3KO4_TMT0_kidney.raw"],
        "replicate_type": [None] * 4,
    },
    "raw_matrix": raw,
    "raw_source_matrix": raw,
    "source_relative_abundance": percent,
    "source_relative_column_indices": [14, 15, 16, 17],
    "high_mannose_denominator": denominators,
    "source_summary_rows": {"292": cells[291], "293": cells[292], "294": cells[293]},
    "conflict_columns": [],
    "annotation": annotation,
    "license": {
        "name": "Creative Commons Attribution 4.0 International",
        "url": "https://creativecommons.org/licenses/by/4.0/",
        "evidence_url": "https://api.crossref.org/works/10.1074/mcp.RA119.001534",
        "evidence_scope": "Publisher-deposited version-of-record license metadata, effective 2020-09-19; no separate restriction located for Supplemental Table S2.",
        "attribution": "Nakano et al. (2019), Bisecting GlcNAc Is a General Suppressor of Terminal Modification of N-glycan. DOI: 10.1074/mcp.RA119.001534. Source cells preserved; assay zeros represented as NA and annotations conservatively typed by glyhub.",
    },
    "object_class": "GlycomicSE",
}
(D / "matrix-specs.json").write_text(json.dumps([spec], indent=2, ensure_ascii=False) + "\n")
audit = {
    "source_sha256": SHA256,
    "source_sheet": sheet.name,
    "feature_rows": [5, 291],
    "excluded_summary_rows": [292, 293, 294],
    "dimensions": [287, 4],
    "typed_compositions": 255,
    "ambiguous_feature_ids": ambiguous,
    "all_zero_feature_ids": all_zero,
    "zero_counts_by_sample": dict(zip(sample_ids, zeros)),
    "source_column_sums": dict(zip(sample_ids, cells[293][9:13])),
    "high_mannose_denominators": dict(zip(sample_ids, denominators)),
    "relative_percent_formula": "100 * EIC peak intensity / sample-specific source SUM of Hign Man",
    "relative_percent_cells_checked": 1148,
    "diagnostic_ms2_nonempty_by_sample": [sum(cells[i][j] != "" for i in range(4, 291)) for j in range(17, 21)],
    "typed_structures": 0,
}
(D / "extraction-audit.json").write_text(json.dumps(audit, indent=2) + "\n")
print(json.dumps(audit, indent=2))
