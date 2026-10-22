# Data schema (v1.0.0)

Every dataset writes the same tables to `datasets/<id>/processed/`. The machine-readable version of this file is [schema/schema.yaml](schema/schema.yaml), and `tools/validate.py` enforces it.

**Units:** lengths are in **mm** and rotations in **rad**. Convert in `convert.py`, and record the original units in `dataset.yaml`.

## `specimens.csv`: one row per specimen

| Column | Required | Description |
|---|---|---|
| `dataset_id` | yes | Folder name of the dataset, e.g. `padilla-llano-2015` |
| `specimen_id` | yes | Unique within the dataset. Use the source's own naming where possible. |
| `section` | yes | Section designation, e.g. SSMA `600S162-33` |
| `member_type` | yes | `column` or `beam` |
| `target_buckling_mode` | no | `global`, `distortional`, or `local`: the mode the test was designed for |
| `loading_protocol` | no | `monotonic`, `cyclic`, or `none` (imperfection survey only) |
| `length_mm` | yes | Specimen length used to compute `z_over_L` |
| `web_depth_mm` | no | Measured web depth (out-to-out) |
| `flange_width_east_mm`, `flange_width_west_mm` | no | Measured flange widths, one per side |
| `thickness_mm` | no | Measured thickness |
| `notes` | no | Anything a user should know about this specimen |

## `measurements.csv`: one row per reading

Long format: a profile along the member is many rows that share the same `specimen_id`, `measurement_set`, `imperfection_type`, and `location`.

| Column | Required | Description |
|---|---|---|
| `dataset_id`, `specimen_id` | yes | Must match a row in `specimens.csv` |
| `measurement_set` | yes | One measurement session, e.g. the source variable or file name. It keeps repeat measurements apart. |
| `method` | yes | `manual`, `photogrammetry`, `laser_scan`, or `other` |
| `imperfection_type` | yes | See the list below |
| `location` | yes | `member`, `web`, `east_flange`, or `west_flange` |
| `processing` | yes | How the value relates to the raw reading, e.g. `as_measured_includes_out_of_plumb`, `out_of_plumb_removed`, `derived_from_point_cloud`. Define each value in the dataset README. |
| `z_mm` | yes | Position along the member length |
| `z_over_L` | yes | `z_mm / length_mm` |
| `value` | yes | The imperfection magnitude |
| `unit` | yes | `mm` or `rad` |
| `source_field` | yes | Where the value came from in `raw/`, precise enough to trace by hand |

### Imperfection types

| `imperfection_type` | Allowed `location` | Unit | Meaning |
|---|---|---|---|
| `bow` | `member` | mm | Global out-of-straightness (sweep) |
| `camber` | `member` | mm | Global out-of-straightness in the other principal direction |
| `twist` | `member` | rad | Cross-section rotation about the member axis |
| `local_web` | `web` | mm | Out-of-plane web deviation (δ1, Type 1) |
| `distortional_flange` | `east_flange`, `west_flange` | mm | Flange–lip deviation (δ2, Type 2) |

Researchers use different axis conventions for bow and camber. Each dataset README must state which principal axis each one refers to, and its sign convention.

## `point_clouds.csv` (optional): raw scan points

| Column | Description |
|---|---|
| `dataset_id`, `specimen_id`, `measurement_set` | As above |
| `x_mm`, `y_mm`, `z_mm` | Point coordinates. Describe the coordinate frame in the dataset README. |

If the point clouds would be more than about 50 MB, don't commit them. Put them on Zenodo, and list the DOI and checksum in `dataset.yaml` under `external_files`.

## Changing the schema

Add columns or vocabulary terms by pull request. Update `schema/schema.yaml` and this file together, and bump the version: minor for additions, major for anything that breaks existing datasets.
