"""Convert the Padilla-Llano (2015) MATLAB files in raw/ to the shared schema in processed/.

Run from anywhere:  python datasets/padilla-llano-2015/convert.py

Field meanings come from the author's plotting scripts in raw/ (plotImpPGandDG2a*.m).
Only the series those scripts plot are exported. Everything else (fits, alternate
series, axes) is still in the raw .mat files.
"""
import re
from pathlib import Path

import numpy as np
import pandas as pd
import scipy.io as sio

HERE = Path(__file__).resolve().parent
RAW = HERE / "raw"
OUT = HERE / "processed"
DATASET_ID = "padilla-llano-2015"
IN2MM = 25.4

MEMBER = {"A": "column", "F": "beam"}
MODE = {"G": "global", "D": "distortional", "L": "local"}
PROTOCOL = {"C": "cyclic", "M": "monotonic"}

# Test code after the depth, e.g. GAC122, GAM1a26, GAC117b:
#   mode, member, protocol, replicate digit, optional a/b, specimen number, optional a/b
CODE_RE = re.compile(r"^([GDL])([AF])([CM])(\d)([ab]?)(\d+)([ab]?)$")
# Manual short depths in the flexural file (IMan080..., IMan120...) -> full depth
FLEX_DEPTH = {"080": "800", "100": "1000", "120": "1200"}

NOTES = {
    "362LAC25": "Section label in mIMPERFECT.mat is 362S162-33, but the measured thickness in "
                "plotImpPGandDG2a.m (0.0568 in) matches 54 mil, like the other 362L specimens.",
}

# (imperfection_type, location, unit, value accessor, source_field) per method.
# Photogrammetry: cell {1} is z, the listed cell is the value (as indexed in the .m scripts).
PG_SERIES = [
    ("bow", "member", "in", lambda r: r.Bow.Sweep, 1, "Bow.Sweep{2}"),
    ("camber", "member", "in", lambda r: r.Camber.Sweep, 1, "Camber.Sweep{2}"),
    ("twist", "member", "rad", lambda r: r.Twist.Phi, 1, "Twist.Phi{2}"),
    ("local_web", "web", "in", lambda r: r.IWeb.Imp, 1, "IWeb.Imp{2}"),
    ("distortional_flange", "east_flange", "in", lambda r: r.ID2.Imp2, 2, "ID2.Imp2{3}"),
    ("distortional_flange", "west_flange", "in", lambda r: r.ID2.Imp2, 3, "ID2.Imp2{4}"),
]
# Manual: M1 = readings as taken (still include out-of-plumb), M2 = out-of-plumb removed.
MAN_SERIES = [
    ("bow", "member", "in", "M1", "Bow"),
    ("twist", "member", "rad", "M1", "Twist"),
    ("local_web", "web", "in", "M1", "d1"),
    ("distortional_flange", "east_flange", "in", "M1", "d2E"),
    ("distortional_flange", "west_flange", "in", "M1", "d2W"),
    ("bow", "member", "in", "M2", "Bow"),
    ("twist", "member", "rad", "M2", "Twist"),
    ("local_web", "web", "in", "M2", "d1"),
]
PROCESSING = {
    "M1": "as_measured_includes_out_of_plumb",
    "M2": "out_of_plumb_removed",
    "pg": "derived_from_point_cloud",
}


def load(name):
    d = sio.loadmat(RAW / name, squeeze_me=True, struct_as_record=False)
    return {k: v for k, v in d.items() if not k.startswith("__")}


def parse_code(code):
    m = CODE_RE.match(code)
    if not m:
        raise ValueError(f"unrecognized test code {code!r}")
    mode, member, protocol, rep, _, num, _ = m.groups()
    return f"{mode}{member}{protocol}{rep}{num}", MODE[mode], MEMBER[member], PROTOCOL[protocol]


def specimen_from_var(var):
    """IM600GAC122 / IMan600GAM1a26 / IMan120GFC16 -> 600GAC122 / 600GAM126 / 1200GFC16."""
    m = re.match(r"^IM(an)?(\d+)(.+)$", var)
    manual, depth, code = m.groups()
    if manual and depth in FLEX_DEPTH and code[1] == "F":
        depth = FLEX_DEPTH[depth]
    return depth + parse_code(code)[0], code


def section_from_name(name):
    """'0800S16297GFC21' -> '800S162-97' (SSMA designation)."""
    m = re.match(r"^0*(\d+S\d{3})(\d+?)(?=[GDL][AF][CM])", name)
    return f"{m.group(1)}-{m.group(2)}"


def parse_m_arrays(path, names):
    """Read numeric/cell arrays like `LL=[90,90,...];` from a MATLAB script."""
    text = path.read_text(errors="replace")
    out = {}
    for name in names:
        m = re.search(rf"^\s*{name}\s*=\s*([\[{{])(.*?)[\]}}]", text, re.S | re.M)
        body = re.sub(r"%[^\n]*", "", m.group(2)).replace("...", " ")
        if m.group(1) == "{":
            out[name] = re.findall(r"'([^']+)'", body)
        else:
            out[name] = [float(x) for x in re.split(r"[,\s;]+", body.strip()) if x]
    return out


def metadata_from_script(script):
    a = parse_m_arrays(RAW / script, ["fls", "LL", "tck", "FEw", "FWw", "WW"])
    rows = {}
    for i, var in enumerate(a["fls"]):
        sid, _ = specimen_from_var(var)
        rows[sid] = {
            "length_mm": a["LL"][i] * IN2MM,
            "thickness_mm": a["tck"][i] * IN2MM,
            "flange_width_east_mm": a["FEw"][i] * IN2MM,
            "flange_width_west_mm": a["FWw"][i] * IN2MM,
            "web_depth_mm": a["WW"][i] * IN2MM,
        }
    return rows


def series_rows(sid, mset, method, itype, loc, unit, z, v, processing, field, length_in):
    z = np.asarray(z, dtype=float)
    v = np.asarray(v, dtype=float)
    keep = ~(np.isnan(z) | np.isnan(v))
    z, v = z[keep], v[keep]
    if unit == "in":
        v = v * IN2MM
    return pd.DataFrame({
        "dataset_id": DATASET_ID,
        "specimen_id": sid,
        "measurement_set": mset,
        "method": method,
        "imperfection_type": itype,
        "location": loc,
        "processing": processing,
        "z_mm": z * IN2MM,
        "z_over_L": z / length_in,
        "value": v,
        "unit": "mm" if unit == "in" else unit,
        "source_field": field,
    })


def main():
    OUT.mkdir(exist_ok=True)
    meta = {**metadata_from_script("plotImpPGandDG2a.m"),
            **metadata_from_script("plotImpPGandDG2a4Flex.m")}

    specimens, meas, clouds = {}, [], []

    for fname in ["mIMPERFECT.mat", "mIMPFlex.mat"]:
        for var, rec in sorted(load(fname).items()):
            sid, code = specimen_from_var(var)
            _, mode, member, protocol = parse_code(code)
            m1_z = np.asarray(rec.M1.Bow[0], dtype=float)
            sp = specimens.setdefault(sid, {
                "dataset_id": DATASET_ID, "specimen_id": sid,
                "section": section_from_name(rec.Name[0]),
                "member_type": member, "target_buckling_mode": mode, "loading_protocol": protocol,
                # Manual stations span the full specimen, 0..L
                "length_mm": np.nanmax(m1_z) * IN2MM,
                **meta.get(sid, {}),
                "notes": NOTES.get(sid),
            })
            length_in = sp["length_mm"] / IN2MM
            for itype, loc, unit, m, field in MAN_SERIES:
                cell = getattr(getattr(rec, m), field)
                meas.append(series_rows(sid, var, "manual", itype, loc, unit, cell[0], cell[1],
                                        PROCESSING[m], f"{fname}:{var}.{m}.{field}{{2}}", length_in))

    for fname in ["pgIMPERFECT3.mat", "pgIMPFlex.mat"]:
        for var, rec in sorted(load(fname).items()):
            if var == "Note":
                continue
            sid, _ = specimen_from_var(var)
            length_in = specimens[sid]["length_mm"] / IN2MM
            for itype, loc, unit, get, idx, field in PG_SERIES:
                cell = get(rec)
                meas.append(series_rows(sid, var, "photogrammetry", itype, loc, unit, cell[0], cell[idx],
                                        PROCESSING["pg"], f"{fname}:{var}.{field}", length_in))
            pc = np.asarray(rec.PointCloud_Global, dtype=float) * IN2MM
            clouds.append(pd.DataFrame({
                "dataset_id": DATASET_ID, "specimen_id": sid, "measurement_set": var,
                "x_mm": pc[:, 0], "y_mm": pc[:, 1], "z_mm": pc[:, 2],
            }))

    cols = ["dataset_id", "specimen_id", "section", "member_type", "target_buckling_mode",
            "loading_protocol", "length_mm", "web_depth_mm", "flange_width_east_mm",
            "flange_width_west_mm", "thickness_mm", "notes"]
    sp = pd.DataFrame(specimens.values()).reindex(columns=cols).sort_values("specimen_id")
    sp.to_csv(OUT / "specimens.csv", index=False, float_format="%.4f")
    pd.concat(meas).to_csv(OUT / "measurements.csv", index=False, float_format="%.6g")
    pd.concat(clouds).to_csv(OUT / "point_clouds.csv", index=False, float_format="%.4f")
    print(f"{len(sp)} specimens, {sum(map(len, meas))} measurements, "
          f"{sum(map(len, clouds))} point-cloud points -> {OUT.relative_to(HERE.parent.parent)}")


if __name__ == "__main__":
    main()
