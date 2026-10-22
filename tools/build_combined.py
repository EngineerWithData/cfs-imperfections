"""Merge every dataset's processed tables into combined/ (one file per table).

    python tools/build_combined.py

combined/ is a build output: it is git-ignored and attached to GitHub releases.
Run tools/validate.py first.
"""
from pathlib import Path

import pandas as pd
import yaml

ROOT = Path(__file__).resolve().parent.parent
SCHEMA = yaml.safe_load((ROOT / "schema" / "schema.yaml").read_text())
OUT = ROOT / "combined"


def main():
    OUT.mkdir(exist_ok=True)
    datasets = sorted(p for p in (ROOT / "datasets").iterdir() if (p / "processed").is_dir())
    for name, spec in SCHEMA["tables"].items():
        parts = [pd.read_csv(p / "processed" / spec["file"], low_memory=False)
                 for p in datasets if (p / "processed" / spec["file"]).exists()]
        if not parts:
            continue
        df = pd.concat(parts, ignore_index=True)[list(spec["columns"])]
        df.to_parquet(OUT / f"{name}.parquet", index=False)
        print(f"{name}: {len(df)} rows from {len(parts)} dataset(s)")


if __name__ == "__main__":
    main()
