"""Validate reviewed inputs consumed by the shared R matrix builder.

Run from any directory with Python 3.10 or later. No source assets are needed.
"""
import importlib.util
import json
from pathlib import Path
import re
import unittest


ROOT = Path(__file__).resolve().parents[3]
MODULE_SPEC = importlib.util.spec_from_file_location(
    "compact_specs", Path(__file__).with_name("compact-specs.py")
)
COMPACT = importlib.util.module_from_spec(MODULE_SPEC)
MODULE_SPEC.loader.exec_module(COMPACT)


class MatrixSpecTests(unittest.TestCase):
    def test_shared_builder_inputs(self):
        paths = set()
        for script in (ROOT / "data-raw").rglob("*.R"):
            paths.update(re.findall(
                r'build_matrix_specs\("([^"]+)"\)', script.read_text()
            ))
        self.assertTrue(paths)
        for path in sorted(paths):
            specs = COMPACT.unpack(json.loads((ROOT / path).read_text()))
            for spec in specs:
                with self.subTest(path=path, dataset=spec["name"]):
                    samples = spec["sample_ids"]
                    features = spec["feature_ids"]
                    self.assertEqual(len(samples), len(set(samples)))
                    self.assertEqual(len(features), len(set(features)))
                    self.assertEqual(len(spec["raw_matrix"]), len(features))
                    self.assertTrue(all(
                        len(row) == len(samples) for row in spec["raw_matrix"]
                    ))
                    self.assertEqual(len(spec["composition"]), len(features))
                    self.assertEqual(len(spec["row_annotations"]), len(features))
                    # build_matrix_specs.R iterates names(s$col_data), so an
                    # array of row records would silently omit every column.
                    self.assertIsInstance(spec["col_data"], dict)
                    for values in spec["col_data"].values():
                        self.assertEqual(len(values), len(samples))

    def test_spike_ace2_sample_annotations(self):
        spec = json.loads(
            (ROOT / "data-raw/GPST000120/matrix-specs.json").read_text()
        )[0]
        self.assertEqual(spec["col_data"], {
            "source_column": [9, 10],
            "source_sample_label": ["SARS-CoV-2 Spike", "Human ACE2"],
            "group": ["Spike", "ACE2"],
            "replicate_type": [None, None],
            "biological_sample_id": [None, None],
        })


if __name__ == "__main__":
    unittest.main()
