# Current model-quality branch

Work continues on `astra/model-quality-v3`, draft PR #3, stacked on the recovery
follow-up. Main and the two predecessor review branches are unchanged.

The broken v3 compiler/test syntax is repaired. `tools/character_geometry.py`
builds new actual meshes for all eight wrestlers and the neutral halo referee.
Integrated faces, fitted eyes/lids/lips, scalp-following hair, garment panels,
shoulder bridges, detailed palms, correctly spread fingers and medial thumbs are
implemented. Main rig landmarks, gameplay stats, damage, clocks and rules remain.
Neutral hand posture and bounded finger curls are improved; recovery has one owner.

Local checks pass: 408 mechanics, 126 scene physics, 35 presentation, 305 overhaul,
1941 paired contact, 56 animation polish and 142 recovery/event assertions, plus
7 Python tests. Counts overlap. Actual neutral-model and match captures are
available through repeatable tools; CI repeats them for the published revision.

See `docs/MODEL_QUALITY_V3.md` for source-checkout rebuilding, exact scope,
verification and remaining limitations. Compiled v3 GLBs are supplied in the CI
artifact/download package; a raw source checkout must rebuild its baseline GLBs.
No draft PR is merged, and no production-likeness, full-body collision or target-
hardware performance acceptance is claimed.
