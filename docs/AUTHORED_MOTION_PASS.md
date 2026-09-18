# Authored primary strikes and supported recovery

Baseline: `ead8ef53bfd458e882230e37cfc3a97f14b25253` on the review branch.
This continuation changes two primary strikes and the recovery presentation of
Tophiachu and Cyraxx. It is not a new geometry rebuild or final art approval.

## Implemented

`StrikeMoves` owns canonical action identifiers and ordered, disjoint hit windows.
Tophiachu uses one Comment-Section Clothesline hit; Cyraxx uses three Feedback
Flurry hits (left, right, left). Each hit can resolve once. A missed earlier window
never catches up, and a reversal cancels the rest of the sequence. Standing strikes
reject grounded, held, terminal and excessively height-separated targets.

The flurry splits one existing strike budget into 25%, 30%, and 45% shares. At the
unchanged power stat this is 13.5 + 16.2 + 24.3 = 54 damage, not three 54-damage hits.
Hype is split by the same shares. Stamina is paid once through the normal input
path. Existing total duration (0.45 s), block multiplier, forward cone, and maximum
range are retained. Tophiachu still deals 78 damage with the one clothesline hit.
Partial connections therefore change outcomes deliberately, while the complete
connected strike keeps the old damage and Hype totals. Multi-hit interruption
opportunities change practical balance; this is not a claim of identical matchups.

`AuthoredMotion` reads the gameplay action identifier and clock. The flurry's
extension peaks derive from the hit-window metadata. The clothesline uses an
explicit wind-up, arm sweep and return to guard. These are runtime key poses, not
new baked GLB clips. Animation never applies damage or decides a match result.

The first two wrestlers also receive an authored recovery trajectory with a seated
transition, asymmetric foot placement, loaded crouch and return to stance. Bounded
rotation-only limb fitting positions the support feet and a reachable thigh brace.
The existing recovery gameplay duration remains 0.60 s. The old recovery-support
layer is disabled for these authored poses so two systems do not compete.
`authored_motion_enabled = false` restores the prior presentation for comparison;
it does not disable the new gameplay hit schedule.

No fighter root, rig, mesh, stat allocation, pin/submission rule, referee behavior,
throw clock or clearance cap was changed in this continuation. Six other wrestlers
retain their current shared primary-strike and recovery presentation.

## Measured recovery comparison

The real-engine test samples 38 consecutive physics frames, including return to
idle, after the same downed setup in center ring. Existing clearance stays enabled
in both cases. The figures measure the final upward cosmetic correction, not a
bone-center proxy or a performance statistic.

| Character | Prior mean lift | New mean lift | Prior peak | New peak |
| --- | ---: | ---: | ---: | ---: |
| Tophiachu | 0.038893 m | 0.005357 m | 0.076670 m | 0.050320 m |
| Cyraxx | 0.028704 m | 0.000000 m | 0.077723 m | 0.000000 m |

The peak Tophiachu residual occurs early in the transition; floor correction was
not removed or increased to obtain these results. Loaded-phase ankle marker errors
were at most approximately 1.53 cm for Tophiachu and below 0.01 mm for Cyraxx in
these fixtures. This does not prove zero slipping, accurate skin contact or true
weight bearing. The new suite audits 1,428,496 deformed vertex positions across
the four baseline/enabled recovery runs; no sampled corrected vertex was below
the canvas. Existing edge/corner mesh tests also remain required.

## Checks actually run locally in Godot 4.7.2, Linux

| Suite | Passed | Failed |
| --- | ---: | ---: |
| Existing mechanics/unit | 408 | 0 |
| Scene-physics integration | 126 | 0 |
| Presentation | 35 | 0 |
| Overhaul integration | 305 | 0 |
| Paired-contact integration | 1,941 | 0 |
| Animation polish | 76 | 0 |
| Mesh clearance | 3,750 | 0 |
| New authored moves/recovery | 1,630 | 0 |
| Python asset compiler | 3 | 0 |

Counts include repeated assertions and overlap; they are not independent human
playtests. New tests cover both player slots/insertion orders, clean and blocked
strikes, total damage/Hype/stamina budgets, late target entry, mid-flurry reversal,
backward/out-of-range/grounded targets, limb-length invariance, exact recovery
floor checks, unchanged gameplay roots and decreased corrective lift.

```sh
mkdir -p evidence
godot --headless --editor --path . --import
godot --headless --fixed-fps 60 --path . -s tests/test_authored_moves.gd
```

The suite writes `evidence/authored-moves.json` with actual event times, damage and
recovery measurements. The existing read-only CI workflow runs it after all prior
suites. Consult the CI job result, not this table alone, for remote verification.

## Rendered evidence

`tools/capture_choreography.gd` stages actual in-engine poses at identical clocks,
lighting and camera settings. The baseline flag disables only authored presentation.
Other actors are hidden for clarity. These are diagnostic captures, not a full
human match or frame-rate benchmark.

```sh
godot --path . --audio-driver Dummy --rendering-method gl_compatibility --fixed-fps 60 -s tools/capture_choreography.gd -- --out=/tmp/choreography-after
godot --path . --audio-driver Dummy --rendering-method gl_compatibility --fixed-fps 60 -s tools/capture_choreography.gd -- --baseline --out=/tmp/choreography-before
```

Actual front/side recovery and strike poses were rendered and inspected using
Xvfb/Mesa llvmpipe. The final render logs contain the unsupported-VSync-driver
warning; audio was intentionally disabled. No target-GPU performance claim is made.

## Remaining work

The new strikes still use the prior logical forward/range envelope, not accurate
swept limb-volume contact. Visible arm contact at the edges of reach, body-to-body
collision, joint limits, clothing/finger penetration, detached-looking shoulder
seams and high-detail character art remain unfinished. The 0.60 s recovery is an
arcade transition and still needs longer-form authored art review. The authored
recovery has been enabled only for the two tested characters.

No unique finisher, trait implementation, tournament mode, Windows executable,
gamepad validation, target-GPU test or comprehensive human match playtest is claimed.
Keep the PR as a draft. Do not equate clearance or hit-count assertions with final
visual acceptance.
