# Self-review: controller stalls, randomness, hold cleanup and camera readability

Baseline: `e3df96e3bbd297750ea91689dcca16169076d78e`. This revision already
contained the input, portrait-seam, selection, camera-shake and model-lifecycle
repairs described in `SELF_REVIEW.md`. Those fixes and all v3.3 likeness assets are
preserved. This follow-up does not re-claim them as new work or rebuild faces.

## What the earlier green tests missed

Two completed seeded CPU matches were not enough to establish reliable pacing.
A broader study reproduced a persistent guard/recovery loop: below strike cost,
the CPU chose guard, which spent regenerated stamina before an attack became
available. Several fights remained idle/guarding until the 120-second audit limit.
The new regression suite fails 14 of 35 assertions on the unchanged baseline and
passes all 35 after repair. These are overlapping assertions, not 14 separate bugs.

The AI also consumed the global random stream used by procedural sound synthesis
and pitch variation. Seven unrelated random draws each tick changed the same
seeded match. One baseline mirror match went from 11.23 seconds to a timeout.
This is not acceptable for cosmetic systems: a different sound should not change
a tactical choice. Finally, aborting a hold cleared the manager but could leave
its surviving participant pinned or holding nobody indefinitely.

## Implemented repairs

- CPU decisions have per-controller random streams and an explicit match seed.
  Match selection creates independent entropy; restart retains its seed. Replays
  can supply a fixed fourth argument to `MatchConfig.set_match`. Reproducibility
  is scoped to the pinned engine, not promised across Godot releases.
- Audio synthesis/pitch have a separate random stream. Synthesizing all audio no
  longer advances the global stream. No new audio content or voice is introduced.
- CPU snapshots run before Fighter physics (priority -10 vs 0). Only continuous
  movement/guard persist between thoughts. Commands become neutral during holds,
  knockdowns, recovery and terminal states. CPU-mode toggling resets cached input.
- Low stamina triggers a real recovery decision at 25%, ending at 55%. Retreat is
  bounded and biases toward center near the ropes. Recovery uses ordinary movement
  and the existing 12-units/second regeneration; no free stamina, altered HP,
  damage, pin resistance or forced result is used. The hysteresis avoids switching
  back to guard every time a fraction of an attack cost is regenerated.
- Invalid-participant hold aborts clear references/timers first, then release the
  surviving attacker to idle or defender to recovery before emitting one notice.
- The match camera now fits the final, corrected actor bounds. It uses a fixed
  broadcast side, a closer minimum framing distance, screen margins, smoothed
  focus, immediate outward safety fitting and gradual inward zoom. The legacy
  room-wide view remains available through `action_framing=false`. Shake-off is
  preserved. This is framing, not new character geometry or collision behavior.

## Matched sample, not a balance score

`audit_match_pacing.gd` exercised all 64 ordered roster pairs, including mirrors,
with two seeds (1931/4019): 128 normal-controller matches per version. Fighter
scenes, colliders and MatchManager run normally; the bulk pass disables cosmetic
updates only. No direct damage, HP or escape values are injected. The same startup
positions and 120-second time limit are used. Two representative matches were also
repeated with normal cosmetic updates and retained identical event/outcome traces.

| Observation | Baseline | Repaired |
|---|---:|---:|
| Completed / 128 | 89 | 128 |
| Reached 120-second timeout | 39 | 0 |
| Median completed duration | 12.17 s | 17.05 s |
| 10th–90th percentile, completed only | 9.83–16.18 s | 10.67–32.18 s |
| Completed duration range | 7.27–80.88 s | 9.87–50.35 s |
| Near-zero-stamina losses | 77 / 89 | 24 / 128 |
| Losses above 70% vitality | 32 / 89 | 22 / 128 |

Durations exclude timeouts; read those figures together. Percentiles use nearest
rank. The independent streams and decision timing changed too: this is a whole-
patch comparison, not an isolated estimate of the rest threshold's effect.
Zero timeouts in this sample is NOT a proof that every possible match terminates.
The remaining fast finishes and high-vitality losses require human-facing balance
review; no health/escape tuning was done to make these cases pass.

All 16 sampled noise-perturbed matches retained their new event digests and exact
termination ticks. A separate 600-tick test checks positions, states, health,
stamina, Hype and match state, with 4,200 irrelevant random draws and reversed
controller sibling order. All recorded values remain equal after the patch.

## Verification

Local Godot 4.7.2/Linux tests passed: mechanics, scene integration, presentation,
overhaul, contacts, secondary animation, recovery/referee, authored moves, mesh
clearance, joint deformation, portrait/material import and previous UI/lifecycle
regressions, plus 35 controller/cleanup and 14 action-camera checks. The existing
12 Python asset tests passed. CI reruns those contracts and records the 128-case
current-controller audit; the baseline comparison is a separate local study.

The camera test uses real engine projection of final actor AABBs at 16:9, 4:3 and
21:9, through a complete throw/landing and opposite-corner placement. Actors must
be materially larger than the legacy overview while preserving head/foot margins.
This is not a test of occlusion by every rope/referee/venue object.

`capture_cpu_review.gd` records an unforced, fresh-resource normal-controller
match with the actual venue, camera and HUD. It does not stage moves or force a
kick-out. It is a silent software-OpenGL render at 15 captured frames per simulation
second, NOT human playtest or measured hardware FPS. `--overview` repeats the same
seed with the old framing. Unshadowed portrait studies are not used as proof of
match lighting; current models and materials are left unchanged in this pass.

## Reproduce

```sh
godot --headless --editor --path . --import
godot --headless --fixed-fps 60 --path . -s tests/test_cpu_review.gd
godot --headless --fixed-fps 60 --path . -s tests/test_action_camera.gd
godot --headless --disable-render-loop --fixed-fps 60 --path . -s tools/audit_match_pacing.gd -- --limit=128
godot --headless --disable-render-loop --fixed-fps 60 --path . -s tools/audit_match_pacing.gd -- --limit=16 --noise=7 --output=res://evidence/pacing-noise.json
godot --path . --audio-driver Dummy --rendering-method gl_compatibility --disable-render-loop --fixed-fps 60 -s tools/capture_cpu_review.gd
```

To compare the old controller, run the same audit tool in a separate baseline
worktree at the SHA above with its rebuilt/imported assets, then summarize both
JSON files using `tools/summarize_match_pacing.py before.json after.json`.
The downloaded project already contains built models; raw GitHub still requires
`python tools/build_roster.py` before first Godot import. Main remains untouched.

## Still open

Models are stylized and not likeness-approved. Faces remain static; hair, collar,
skin/clothing contact and shoulder transitions need art work. The camera makes
these details easier to see rather than hiding them in a distant overview.
Reference photos are not redistributed. No additional model realism is claimed.
AI still shares generic tactical rules and does not implement every named trait
or finisher; the surviving fast/high-health pinfalls remain a balance concern.
Physical rope/opponent collision, swept limb hit volumes, Windows/gamepads,
Forward+ target-GPU performance and full human playtesting remain unverified.
Keep the pull request a draft; no statistical result constitutes release approval.
