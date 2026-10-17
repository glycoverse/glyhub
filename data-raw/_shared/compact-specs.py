"""Losslessly compact matrix specs. Run with one or more JSON paths."""
import argparse
import itertools
import json
from pathlib import Path

FORMAT = 'glyhub-compact-specs-v1'
MATRICES = {'raw_matrix', 'matrix', 'raw_source_matrix', 'source_cell_rows',
            'source_cell_columns', 'source_coverage'}


def dumps(value):
    return json.dumps(value, ensure_ascii=False, separators=(',', ':'), allow_nan=False)


def pack(specs):
    result = []
    for spec in specs:
        out = dict(spec)
        for key, value in spec.items():
            candidate = None
            if key in MATRICES and value and all(len(r) == len(value[0]) for r in value):
                flat = itertools.chain.from_iterable(value)
                runs = []
                for _, group in itertools.groupby(flat, key=dumps):
                    item = next(group)
                    runs.append([1 + sum(1 for _ in group), item])
                candidate = {'encoding': 'runs', 'dim': [len(value), len(value[0])], 'runs': runs}
            elif key == 'row_annotations' and value and all(list(r) == list(value[0]) for r in value):
                candidate = {'encoding': 'records', 'keys': list(value[0]),
                             'rows': [list(r.values()) for r in value]}
            if candidate is not None and len(dumps(candidate)) < len(dumps(value)):
                out[key] = candidate
        result.append(out)
    return {'format': FORMAT, 'specs': result}


def unpack(document):
    if isinstance(document, list):
        return document
    if document.get('format') != FORMAT:
        raise ValueError('Unsupported matrix spec format')
    result = []
    for spec in document['specs']:
        out = dict(spec)
        for key, value in spec.items():
            if key in MATRICES and isinstance(value, dict) and value.get('encoding') == 'runs':
                nr, nc = value['dim']
                flat = [r[1] for r in value['runs'] for _ in range(r[0])]
                if len(flat) != nr * nc:
                    raise ValueError('Invalid matrix run lengths')
                out[key] = [flat[i * nc:(i + 1) * nc] for i in range(nr)]
            elif key == 'row_annotations' and isinstance(value, dict) and value.get('encoding') == 'records':
                out[key] = [dict(zip(value['keys'], row, strict=True)) for row in value['rows']]
        result.append(out)
    return result


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('paths', nargs='+', type=Path)
    args = parser.parse_args()
    for path in args.paths:
        original = unpack(json.loads(path.read_text()))
        packed = pack(original)
        assert dumps(unpack(packed)) == dumps(original), 'Lossless round-trip failed'
        before = path.stat().st_size
        path.write_text(dumps(packed) + '\n')
        print(f'{path}: {before:,} -> {path.stat().st_size:,} bytes')
