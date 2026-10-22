"""Convert raw/ to processed/ for this dataset. See SCHEMA.md and datasets/padilla-llano-2015/convert.py."""
from pathlib import Path

import pandas as pd

HERE = Path(__file__).resolve().parent
RAW = HERE / "raw"
OUT = HERE / "processed"
DATASET_ID = HERE.name


def main():
    OUT.mkdir(exist_ok=True)
    specimens = pd.DataFrame(columns=[
        "dataset_id", "specimen_id", "section", "member_type", "target_buckling_mode",
        "loading_protocol", "length_mm", "web_depth_mm", "flange_width_east_mm",
        "flange_width_west_mm", "thickness_mm", "notes"])
    measurements = pd.DataFrame(columns=[
        "dataset_id", "specimen_id", "measurement_set", "method", "imperfection_type",
        "location", "processing", "z_mm", "z_over_L", "value", "unit", "source_field"])
    # ... read RAW files, fill the tables, convert to mm / rad ...
    specimens.to_csv(OUT / "specimens.csv", index=False)
    measurements.to_csv(OUT / "measurements.csv", index=False)


if __name__ == "__main__":
    main()
