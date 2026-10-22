# Adding a dataset

1. **Create the folder.** Copy `templates/new-dataset/` to `datasets/<firstauthor>-<year>/`. Use lowercase with hyphens, e.g. `smith-2024`. If an author has more than one dataset from the same year, add a short suffix, e.g. `smith-2024-studs`.

2. **Add the original files to `raw/` exactly as received.** Never edit them. If a file is larger than about 50 MB, put it on Zenodo instead, and list it in `dataset.yaml` under `external_files`.

3. **Write `convert.py`.** It reads `raw/` and writes `processed/specimens.csv` and `processed/measurements.csv` (and optionally `point_clouds.csv`), following [SCHEMA.md](SCHEMA.md). It should:
   - convert to mm and rad
   - map the source's field names onto the shared `imperfection_type` and `location` terms
   - fill `source_field` so every value can be traced back to `raw/`
   - read values from the source files rather than retyping them

4. **Fill in `dataset.yaml` and `README.md`.** The README must cover:
   - the test program
   - how each imperfection was measured
   - the bow and camber axis and sign conventions
   - where `z = 0` is
   - what each `processing` value means
   - known problems with the data

5. **Check your work.**
   ```bash
   pip install -r requirements.txt
   python datasets/<id>/convert.py
   python tools/validate.py <id>
   ```

6. **Open a pull request.** CI runs every `convert.py`, checks that the committed `processed/` files match the output, and runs the validator.

7. **Add your dataset** to the table in the top-level `README.md`.

If your data needs a column or term the schema doesn't have, propose the schema change in the same pull request (see SCHEMA.md).
