# Current source-guided model branch

Active work: `astra/model-quality-v3`, draft PR #3; main and predecessor review
branches are not merged or force-updated. Base gameplay/deformation is integrated
v3.1 (`c5e0ca33`).

The v3.2 art pass uses source-labelled public portrait studies for seven slots.
Original head/hair/glasses/beard geometry, fitted eyes/lips, original procedural
head albedo and more restrained clothing palettes are implemented. Jupiter the
Hybrid and AnacondaSin have insufficient unambiguous references and remain
provisional; there is no guessed likeness attribution.

The 46-joint rig, contact landmarks, 25 clips, authored first-pair attacks,
recovery, whole-mesh visual clearance and referee rules are preserved. No new
finisher mechanics or photorealism claim is made.

Tests and render fixtures are part of the same CI job. New import checks verify
that the loaded skin actually uses tint and embedded head texture. There are 36
neutral portrait views in addition to the established model/deformation/match
captures. Consult exact artifact results rather than assuming implementation means
visual approval. See `docs/REFERENCE_LIKENESS.md` and its public-source manifest.

Downloaded packages contain compiled models. Raw source checkouts must first run
`python tools/build_roster.py`. Keep PR #3 a draft. Human likeness approval,
comprehensive playtesting, Windows/gamepads and hardware Forward+ remain pending.
