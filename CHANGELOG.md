# Changelog


### Added
- Advanced feature engineering: wind × distance interaction, form momentum
  (rolling-3 vs rolling-5 delta), speed-vs-loft ratio.
- Ensemble model option (RandomForestRegressor + HistGradientBoostingRegressor
  via VotingRegressor) used automatically when training data is large enough
  (60+ rows, 3+ features); falls back to a single RandomForestRegressor
  otherwise.
- Time-series cross-validation (`TimeSeriesSplit`) alongside the existing
  chronological holdout split, to reduce the risk of an inflated accuracy
  score from random splitting.
- Permutation-based feature importance report, plus a bar chart of the
  top 15 features.
- Composite ranking score combining:
  - 45% ML predicted speed
  - 20% internal AI/training score
  - 15% recent form
  - 10% family/pairing strength
  - 10% consistency (lower race-to-race variance scores higher)
- `Prediction_Audit` output table recording run metadata: candidate rule,
  row counts, birds with/without race history, model name, MAE, R².
- `Pair_Performance_Available_Birds` output summarizing parent-pair
  performance for birds on the current season's available list.

### Changed
- Candidate filtering rule clarified and enforced end-to-end: a bird is
  only eligible for prediction if `Race Cage Year(s)` contains the
  configured season AND `Status` is Active (if no Status column exists,
  all birds are treated as active).
- Weather feature calculation now uses proper haversine great-circle
  bearings (previously flat-Earth approximation) for computing headwind/
  tailwind components.

### Notes
- This notebook version (`GitHub-safe`) is built to run against the
  aliased `LoftIQ.csv` export, where real ring numbers are replaced with
  `LOFTIQ-BIRD-XXXX` IDs. The private ring-alias mapping file is
  intentionally excluded from version control (see `.gitignore`).
- Not a betting or guaranteed-winner system — see README "Limitations"
  section.
