"""Export selected author XML cell strings unchanged, with deterministic gzip."""
import csv
import gzip
import hashlib
import io
import pathlib
import re
import sys
import xml.etree.ElementTree as ET
import zipfile

source, output = map(pathlib.Path, sys.argv[1:])
assert hashlib.sha256(source.read_bytes()).hexdigest() == "ef12cdb7bbf0c80da420c26a73160d6d2bd9b77f7067aeb584d6e477e554b915"
output.mkdir(parents=True, exist_ok=True)
ns = {"s": "http://schemas.openxmlformats.org/spreadsheetml/2006/main"}
with zipfile.ZipFile(source) as archive:
    strings = ["".join(node.itertext()) for node in ET.fromstring(archive.read("xl/sharedStrings.xml"))]
    sheets = ET.fromstring(archive.read("xl/workbook.xml")).find("s:sheets", ns)
    for number, name, nrows, ncols in [(2, "Intact_Normalized", 15512, 132), (3, "SPEG_normalized", 5115, 131)]:
        assert sheets[number - 1].attrib["name"] == name
        rows = ET.fromstring(archive.read(f"xl/worksheets/sheet{number}.xml")).findall("s:sheetData/s:row", ns)
        assert len(rows) == nrows + 1
        with open(output / f"{name}.tsv.gz", "wb") as handle:
            with gzip.GzipFile(fileobj=handle, filename="", mode="wb", mtime=0) as compressed:
                with io.TextIOWrapper(compressed, encoding="utf-8", newline="") as text:
                    writer = csv.writer(text, delimiter="\t", lineterminator="\n")
                    for row in rows:
                        values = [""] * ncols
                        for cell in row:
                            letters = re.match("[A-Z]+", cell.attrib["r"])[0]
                            col = 0
                            for letter in letters:
                                col = col * 26 + ord(letter) - 64
                            value = cell.findtext("s:v", default="", namespaces=ns)
                            assert col <= ncols
                            values[col - 1] = strings[int(value)] if cell.attrib.get("t") == "s" and value else value
                        writer.writerow(values)
