# Current integrated v3.1 review build

`astra/model-quality-v3` now reconciles model revision `8fc5dedd` with authored
combat/clearance revision `0abb1ffe`. No draft PR or main merge is performed.

The v3 faces/hair/outfits/hands are retained. Four appended elbow/knee skin helpers
and refined bend rings preserve crease shape without changing the original 42
joint chains; knee pads follow the knee bend. Runtime helpers run after contact
and before full-mesh clearance. Total rig: 46 joints, 25 complete-channel clips.

The combined build includes Tophiachu's one-hit clothesline, Cyraxx's three-hit
flurry sharing one damage/Hype budget, authored recovery for that pair, latched
support for the remaining six, bounded mesh clearance, and the referee final slap.

Local validation passes all 10 Godot suites, two normal CPU matches and 8 Python
tests. Detailed counts, metric definitions and limitations are recorded in
`docs/INTEGRATED_DEFORMATION.md`. CI rebuilds and repeats these with actual renders;
consult the exact job result rather than assuming a published revision passed.

Source checkout: run `python tools/build_roster.py` before Godot import. Downloaded
packages include the compiled models. Main, PR #1 and PR #2 remain untouched.
Not production likeness/art acceptance, whole-body collision certification or a
hardware-performance/human-playtest sign-off.
