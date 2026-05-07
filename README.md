# LoftIQ — Race Intelligence System
A pigeon racing intelligence system —  built to connect the dots for old-school operators who know their birds, but want the data to back their instincts.

A machine-learning project that turns messy pigeon racing records into a structured race-ranking and decision-support system.

This project was built from a real-world data problem: old Word documents, legacy spreadsheets, live race/timing data, inconsistent ring-number formats, and parent-pair notes that needed to be cleaned and connected before any useful AI model could be trained.

The goal is **not** to guarantee the race winner. Pigeon racing has too many unseen variables: bird health, training condition, trapping behaviour, route risk, weather changes, and race-day chaos. The goal is to create a disciplined shortlist and help a loft make better decisions from its own data.

---

## What the System Does

The pipeline:

1. Loads a cleaned master input worksheet.
2. Standardises pigeon ring numbers.
3. Filters birds that are available for the selected season.
4. Converts race, weather, form, and family fields into numeric features.
5. Builds rolling form features from past races.
6. Adds weather features such as headwind, tailwind, wind direction, and temperature.
7. Adds family and parent-pair performance features.
8. Trains a machine-learning model to estimate likely race speed.
9. Builds a composite ranking score using ML prediction, recent form, family strength, internal AI score, and consistency.
10. Writes output tables for predictions, best birds, audit checks, and pair-performance review.

---

## Core Idea

The system learns from historical race results, but it only ranks birds that are available for the selected season.

A bird is treated as available when:

```text
Race Cage Year(s) contains the selected season year
AND
Status = Active
```

If the `Status` column does not exist, the script assumes the bird is active.

---

## Why Ring Matching Matters

Ring numbers often appear in different formats across Word files, spreadsheets, and live timing data.

Example:

```text
ZA 2023 BPF 942
ZA-2023-BPF-0942
ZA2023BPF942
```

The script standardises these into one clean format so the same pigeon can be matched across different data sources.

---

## Features Used by the Model

The model can use features such as:

- Race distance
- Bird age
- Race experience
- Recent rolling speed
- Best recent speed
- Rest days between races
- Loft race average speed
- Historical temperature
- Historical wind speed
- Historical wind direction
- Tailwind/headwind component
- Family average speed
- Family best speed
- Family depth score
- Parent-pair offspring count
- Parent-pair offspring race rows
- Pairing performance history

---

## Model Approach

The baseline model uses a `RandomForestRegressor` to estimate expected race speed.

The advanced section adds:

- interaction features such as wind × distance,
- form momentum,
- speed-vs-loft ratio,
- time-series cross-validation,
- an ensemble model using Random Forest and gradient boosting,
- permutation-based feature importance.

The final output is not just raw predicted speed. It uses a composite score:

```text
45% ML predicted speed
20% internal AI/training score
15% recent form
10% family/pairing score
10% consistency
```

This protects the ranking from overreacting to one lucky race.

---

## Output Tables

The GitHub-safe script uses generic worksheet names:

| Output worksheet | Purpose |
|---|---|
| `Predictions_Available_Birds` | Full ranked prediction output |
| `Best_40_Available_Birds` | Top 40 shortlist |
| `Prediction_Audit` | Model run checks and data-quality audit |
| `Pair_Performance_Available_Birds` | Parent-pair performance summary |

The input worksheet should be renamed to:

```text
Master_Input
```

This is clearer than using a single-letter tab name.

---

## Pipeline Structure

```text
Raw records
  ↓
Word documents / old spreadsheets / live race data
  ↓
Cleaned master input table
  ↓
Ring-number standardisation
  ↓
Available-bird filtering
  ↓
Race-history feature engineering
  ↓
Weather feature engineering
  ↓
Family and parent-pair feature engineering
  ↓
ML model training
  ↓
Next-race prediction rows
  ↓
Composite ranking score
  ↓
Prediction, audit, and pair-performance outputs
```

---

## Required Columns

The script is flexible, and checks for several possible column names, but the master input should ideally include:

| Column | Purpose |
|---|---|
| `Ring Number` or `ring_norm` | Bird identity |
| `Race Cage Year(s)` | Used to filter available birds |
| `Status` | Used to filter active birds |
| `race_date` or `Date` | Race date |
| `speed_m_min_num` or `speed_m_min` | Race speed target |
| `distance_km_num` or `distance_km` | Race distance |
| `hist_temp_c` | Historical temperature |
| `hist_wind_kmh` | Historical wind speed |
| `hist_wind_dir` | Historical wind direction |
| `release_lat` and `release_lon` | Release-location coordinates |
| `parent_pair_key` or `pairing_key` | Parent-pair matching |

---

## Setup

Install the required Python packages:

```bash
pip install pandas numpy matplotlib scikit-learn gspread google-auth ipywidgets
```

For Google Colab, authenticate with Google and paste your private Google Sheet ID into the script:

```python
MASTER_SHEET_ID = "PASTE_YOUR_GOOGLE_SHEET_ID_HERE"
INPUT_TAB_NAME = "Master_Input"
```

## Limitations

This is a decision-support system, not a betting machine and not a guaranteed winner predictor.

The model can be wrong because it cannot fully know:

- bird health,
- final basket condition,
- training quality,
- trapping behaviour,
- route hazards,
- sudden weather changes,
- fancier handling decisions,
- missing or messy historical data.

The system improves as more clean race data is added over seasons.


---

## Project Story

What started as a side project to sharpen data science skills became a racing intelligence system.

The first job was not machine learning. The first job was cleaning the chaos: finding ring numbers, matching birds to past results, matching pairings, and connecting race history to family history.

Only after that did the AI/ML race predictor start making sense.

Not a crystal ball.

A racing intelligence system built to help a loft connect the dots.
