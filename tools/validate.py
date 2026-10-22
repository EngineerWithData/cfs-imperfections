"""Check every dataset in datasets/ against schema/schema.yaml.

    python tools/validate.py                 # all datasets
    python tools/validate.py padilla-llano-2015

Exits non-zero and lists every problem if anything fails.
"""
import sys
from pathlib import Path

import pandas as pd
import yaml

ROOT = Path(__file__).resolve().parent.parent
SCHEMA = yaml.safe_load((ROOT / "schema" / "schema.yaml").read_text())
REQUIRED_META = ["id", "title", "authors", "citation", "license", "contact", "original_units"]


def check_table(name, spec, df, errors):
    cols = spec["columns"]
    missing = [c for c in cols if c not in df.columns]
    extra = [c for c in df.columns if c not in cols]
    if missing:
        errors.append(f"{name}: missing columns {missing}")
    if extra:
        errors.append(f"{name}: unknown columns {extra} (add them to schema/schema.yaml first)")
    for col, rule in cols.items():
        if col not in df.columns:
            continue
        s = df[col]
        if rule.get("required") and s.isna().any():
            errors.append(f"{name}.{col}: {s.isna().sum()} empty values in a required column")
        s = s.dropna()
        if rule["type"] == "number":
            num = pd.to_numeric(s, errors="coerce")
            if num.isna().any():
                errors.append(f"{name}.{col}: non-numeric values {s[num.isna()].unique()[:5].tolist()}")
            if "min" in rule and (num < rule["min"]).any():
                errors.append(f"{name}.{col}: values below {rule['min']}")
        if "vocabulary" in rule:
            allowed = SCHEMA["vocabularies"][rule["vocabulary"]]
            bad = sorted(set(s) - set(allowed))
            if bad:
                errors.append(f"{name}.{col}: {bad} not in vocabulary {rule['vocabulary']}={allowed}")


def check_dataset(path):
    errors = []
    meta_file = path / "dataset.yaml"
    if not meta_file.exists():
        return [f"missing dataset.yaml"]
    meta = yaml.safe_load(meta_file.read_text())
    errors += [f"dataset.yaml: missing '{k}'" for k in REQUIRED_META if k not in meta]
    if meta.get("id") != path.name:
        errors.append(f"dataset.yaml: id '{meta.get('id')}' must match folder name '{path.name}'")
    if not (path / "README.md").exists():
        errors.append("missing README.md")

    tables = {}
    for name, spec in SCHEMA["tables"].items():
        f = path / "processed" / spec["file"]
        if not f.exists():
            if not spec.get("optional"):
                errors.append(f"missing processed/{spec['file']}")
            continue
        df = pd.read_csv(f, low_memory=False)
        tables[name] = df
        check_table(name, spec, df, errors)
        if "dataset_id" in df and set(df["dataset_id"].dropna()) - {path.name}:
            errors.append(f"{name}: dataset_id must be '{path.name}' everywhere")

    sp = tables.get("specimens")
    if sp is not None:
        pk = SCHEMA["tables"]["specimens"]["primary_key"]
        dup = sp.duplicated(pk)
        if dup.any():
            errors.append(f"specimens: duplicate keys {sp.loc[dup, 'specimen_id'].tolist()[:5]}")
        for name, df in tables.items():
            fk = SCHEMA["tables"][name].get("foreign_key")
            if fk and "specimen_id" in df:
                orphans = sorted(set(df["specimen_id"]) - set(sp["specimen_id"]))
                if orphans:
                    errors.append(f"{name}: specimen_id not in specimens.csv: {orphans[:5]}")

    m = tables.get("measurements")
    if m is not None and {"imperfection_type", "location", "unit"} <= set(m.columns):
        for itype, rule in SCHEMA["pairings"].items():
            rows = m[m["imperfection_type"] == itype]
            bad_loc = sorted(set(rows["location"]) - set(rule["locations"]))
            if bad_loc:
                errors.append(f"measurements: {itype} cannot have location {bad_loc}")
            bad_unit = sorted(set(rows["unit"]) - {rule["unit"]})
            if bad_unit:
                errors.append(f"measurements: {itype} must use unit {rule['unit']}, found {bad_unit}")
    return errors


def main(names):
    datasets = sorted(p for p in (ROOT / "datasets").iterdir() if p.is_dir())
    if names:
        datasets = [p for p in datasets if p.name in names]
    failed = False
    for path in datasets:
        errors = check_dataset(path)
        print(f"{'FAIL' if errors else 'ok  '} {path.name}")
        for e in errors:
            print(f"     - {e}")
        failed |= bool(errors)
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main(sys.argv[1:])
