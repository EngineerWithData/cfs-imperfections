# Padilla-Llano (2015): imperfections of CFS columns and beams

Measured geometric imperfections of 53 cold-formed steel lipped channel (SSMA "S") members. They were tested at Virginia Tech as part of a study of the cyclic behavior of thin-walled members.

**Cite:** D. Padilla-Llano (2015), *A Framework for Cyclic Simulation of Thin-Walled Cold-Formed Steel Members in Structural Systems*, Ph.D. Dissertation, Virginia Tech. <http://hdl.handle.net/10919/52904>

## Test program

Each section was tested at a length chosen so that one buckling mode (global, distortional, or local) controls. Each length was tested under monotonic and cyclic loading.

| Member | Target mode | Sections | Length | Specimens |
|---|---|---|---|---|
| Column (axial) | Global | 362S137-68, 600S137-97 | 2286 mm (90 in) | 13 |
| Column (axial) | Distortional | 362S137-68, 600S137-68 | 610 mm (24 in) | 8 |
| Column (axial) | Local | 362S162-54, 600S162-33 | 305 mm (12 in) | 8 |
| Beam (flexural) | Global | 800S162-97, 1200S162-97 | 3048 mm (120 in) | 8 |
| Beam (flexural) | Distortional | 800S250-68, 1200S250-97 | 1626 mm (64 in) | 8 |
| Beam (flexural) | Local | 800S200-33, 1000S200-43 | 1626 mm (64 in) | 8 |

All 53 specimens have **manual** measurements, taken with dial gages read against a precision rail. Twenty of them also have **photogrammetry** measurements, which are much denser profiles computed from 3D point clouds:

> 1000LFC222, 1000LFM224, 1200DFC113, 1200DFM115, 1200GFC16, 362DAC212, 362DAM210, 362GAC219, 362LAC18, 362LAM27, 600DAC216, 600DAM215, 600LAC23, 600LAM21, 800DFC226, 800DFM227, 800GFC21, 800GFM22, 800LFC232, 800LFM228

## Specimen IDs

`specimen_id` = nominal web depth (in hundredths of an inch) + test code. For example, `600GAC122`:

| Part | Meaning |
|---|---|
| `600` | Web depth, 6.00 in (the SSMA designation is in the `section` column) |
| `G` / `D` / `L` | Target buckling mode: global / distortional / local |
| `A` / `F` | Axial (column) / flexural (beam) |
| `C` / `M` | Cyclic / monotonic loading |
| `1` | Replicate within the series |
| `22` | Specimen number |

The source files use the prefixes `IM` (photogrammetry) and `IMan` (manual), and some names end in an `a`/`b` suffix. The `measurement_set` column keeps the original variable name, so two manual measurements of the same specimen stay distinct (`IMan362GAC117a` and `IMan362GAC117b`, and `IMan362LAC25a` and `IMan362LAC25b`).

## What's in `processed/`

| File | Contents |
|---|---|
| `specimens.csv` | One row per specimen. Measured web depth, flange widths, and thickness come from the author's plotting scripts. They are blank for the 5 specimens that the scripts don't cover. |
| `measurements.csv` | One row per reading: specimen, method, imperfection type, position `z` along the member, and value. |
| `point_clouds.csv` | Raw photogrammetry points (`PointCloud_Global`) for the 20 photogrammetry specimens. |

All values are converted from inches to mm. Twist is in radians. `z_over_L` is `z` divided by the nominal length.

### Where each series comes from

The `source_field` column gives the exact `.mat` file, variable, and field for every row. The mapping follows the author's scripts `raw/plotImpPGandDG2a.m` and `raw/plotImpPGandDG2a4Flex.m`:

| `imperfection_type` | `location` | Manual (`IMan*`) | Photogrammetry (`IM*`) |
|---|---|---|---|
| bow | member | `M1.Bow`, `M2.Bow` | `Bow.Sweep{2}` |
| camber | member | — | `Camber.Sweep{2}` |
| twist | member | `M1.Twist`, `M2.Twist` | `Twist.Phi{2}` |
| local_web | web | `M1.d1`, `M2.d1` (δ1) | `IWeb.Imp{2}` |
| distortional_flange | east_flange | `M1.d2E` (δ2) | `ID2.Imp2{3}` |
| distortional_flange | west_flange | `M1.d2W` (δ2) | `ID2.Imp2{4}` |

In every case, cell `{1}` holds the position along the member and the other cells hold values.

### The `processing` column

- `as_measured_includes_out_of_plumb`: manual method M1, the gage readings as stored. A comment in the plot script says M1 "still retains the out of plumb trend", so these values include rigid-body tilt and an offset from the rail datum.
- `out_of_plumb_removed`: manual method M2, with the out-of-plumb trend removed. The author used this for bow, twist, and δ1 in the dissertation figures. M2 is stored at different stations than M1.
- `derived_from_point_cloud`: photogrammetry imperfections computed by the author's `getImp4` routine. The routine is not included here. Per the file's `Note`, the global imperfections are referenced to a pseudo-centroidal axis.

Values are exported exactly as stored. Before plotting, the author's scripts also applied a zero-order `detrend2` to the manual series and shifted them by the photogrammetry mean. `detrend2` isn't in the repository, so that step isn't reproduced here.

## Known issues and open questions

- **362LAC25 thickness:** the section label in the `.mat` file is 362S162-33, but the measured thickness (1.44 mm, about 54 mil) matches the other 362S162-54 specimens. The label is kept as stored, with a note in `specimens.csv`.
- **Bow legend label:** the axial plot script labels the manual bow curve "δC [m]" in the legend, but "δB" in the max-value annotation. Here it is treated as bow.
- **Undocumented series:** these are present in the raw files but not exported, because the plot scripts don't use them and their meaning isn't documented:
  - `Bow.Sweep{3,4}`
  - `IWeb.Imp{3}`
  - `M2.Bow{3,4}`
  - `M2.d1{3}`
  - `IEastFlange` / `IWestFlange`
  - `ID2.Imp1` / `Imp3` / `Imp4`
  - the fitted planes and axes
- **Conventions:** the sign convention and the end of the member where `z = 0` follow the source, and haven't been independently checked. Comparing manual and photogrammetry profiles for the same specimen is the best check.
- **Missing dimensions:** 362GAM118, 362GAM220, 600GAC021, 600GAM123, and 600GAM224 have manual imperfections but no measured cross-section dimensions.

## Regenerating

```bash
python datasets/padilla-llano-2015/convert.py
```

`raw/` holds the original files from <https://github.com/dpadilla-llano/Cold_Formed_Steel>, unchanged. `raw/README_original.md` is the original README.
