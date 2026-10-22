# Cold-Formed Steel Imperfection Database

Measured geometric imperfections of cold-formed steel members, collected from multiple research programs and converted to one shared, open format (CSV).

The imperfections covered are global bow, camber, and twist, local web imperfections, and distortional flange imperfections. They're measured along the member length, together with the specimen geometry needed to normalize them. The data is meant for calibrating imperfection magnitudes and shapes in finite element models, and for studying how imperfections vary with section, length, and fabrication.

## Datasets

| Dataset | Members | Specimens | Methods | Source |
|---|---|---|---|---|
| [padilla-llano-2015](datasets/padilla-llano-2015/) | Lipped channel columns and beams | 53 | Manual (dial gage), photogrammetry | [Padilla-Llano (2015)](http://hdl.handle.net/10919/52904) |

Each dataset folder has its own README (test program, methods, known issues), its own `dataset.yaml` (authors, citation, license), and the original files in `raw/`.

## Using the data

Every dataset has the same tables in `processed/`. The columns are defined in [SCHEMA.md](SCHEMA.md).

```python
import pandas as pd

ds = "datasets/padilla-llano-2015/processed"
specimens = pd.read_csv(f"{ds}/specimens.csv")
meas = pd.read_csv(f"{ds}/measurements.csv")

# Photogrammetry distortional imperfections, normalized by flange width
d2 = meas.query("method == 'photogrammetry' and imperfection_type == 'distortional_flange'")
d2 = d2.merge(specimens, on=["dataset_id", "specimen_id"])
d2["value_over_b"] = d2["value"] / d2["flange_width_east_mm"].where(
    d2["location"] == "east_flange", d2["flange_width_west_mm"])
```

To get every dataset in one table, run `python tools/build_combined.py`. It writes `combined/*.parquet`.

## Adding a dataset

See [CONTRIBUTING.md](CONTRIBUTING.md). In short: add a folder under `datasets/` with the raw files, a `convert.py` script, a README, and a `dataset.yaml`. Then run `python tools/validate.py` and open a pull request.

## Citing

Cite the original source of each dataset you use. Its `dataset.yaml` has the citation. To cite the database itself, see [CITATION.cff](CITATION.cff).

## License

Each dataset keeps the license chosen by its contributors (see its `dataset.yaml`). The code in `tools/` and `schema/` is MIT-licensed (see [LICENSE](LICENSE)).
