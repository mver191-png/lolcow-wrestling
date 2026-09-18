# Paired-contact continuation

Baseline: review branch commit `951f7944ae869a8c17f3d2343943197d73a39be6`.
This pass changes runtime presentation, not roster stats, damage, hold rules, actor
positions, collision shapes, animation assets, or match outcome resolution.

## Implemented

- `ContactIK` solves two-bone chains using rotations only. Impossible targets are
  clamped to the existing reach and reported, never hidden by lengthening limbs.
- `PairedContact` runs at physics priority 30, after all character pose sampling at
  20. It uses the partner's current skeleton-space pose transformed into world space.
- Throw cradles acquire their grip from 0.02 to 0.12 seconds of the normalized
  pre-impact phase, hold fully to 0.40, and release by 0.53 before the 0.60 impact.
  Bounded torso/stance adjustments fit the partner; palms orient to the target.
- Pins use a side-on lateral cover with supported ankles instead of the old
  parallel floating-body pose. Cover hands target torso markers, not empty space.
- Submissions use kneeling wrist control. This is one shared presentation, not a
  claim that every canonical finisher has a unique authored hold.
- Downed body support uses bounded anatomical envelopes. It is NOT a full skinned
  mesh collision test. Cosmetic model offsets clear smoothly after release.
- Referee count poses plant the supporting hand and sample the striking hand from
  the official count clock. The referee approaches from the free side of the cover.
  Arrival never delays the match count; the permanent halo and neutrality remain.

## Checks executed in Godot 4.7.2 on Linux

| Suite | Result |
| --- | --- |
| Existing mechanics/unit suite | 408 passed, 0 failed |
| Scene-physics integration | 126 passed, 0 failed |
| Presentation suite | 35 passed, 0 failed |
| Previous overhaul suite | 305 passed, 0 failed |
| New contact suite | 1,941 passed, 0 failed |
| Python asset compiler | 3 passed |

Counts include repeated assertions and overlap; they are not independent human
playtests. The contact suite exercises all 64 ordered pairings twice with player
slots and insertion order reversed: 128 throw/cover/wrist-control sequences.
It checks segment-length preservation, release cleanup, and a 90-tick gameplay
trace with contact enabled versus disabled. The trace is identical.

The suite's tolerances apply to named target markers, NOT skin/clothing contact:
full-weight throw palms < 3 cm; sampled settled cover palms < 1.5 cm;
wrist-control palms and cover ankles < 6.5 cm. Measured worst full-grip throw
error was about 2.3 cm. Some wrists remain reach-limited rather than stretched.
Acquisition and release intentionally do not maintain full grip.

Reproduce from the project root after importing assets:

```sh
godot --headless --editor --path . --import
mkdir -p evidence
godot --headless --fixed-fps 60 --path . -s tests/test_contacts.gd
```

This writes `evidence/contact-test-samples.json`. The CI workflow runs the new
suite and includes its results in the regular review artifact.

## Rendered evidence

`tools/capture_contacts.gd` produces actual Godot images of throw, cover,
wrist-control, recovery and referee phases. Run with a rendering driver:

```sh
godot --path . --rendering-method gl_compatibility --fixed-fps 60 -s tools/capture_contacts.gd
godot --path . --rendering-method gl_compatibility --fixed-fps 60 -s tools/capture_contacts.gd -- --baseline
```

The baseline mode disables the added fighter contact pass. It is a controlled
comparison within this checkout, not a render of the original project commit.
The capture stages poses and forces escape thresholds for review; it is not a
human playtest. The referee is frozen out of the way during the fighter-comparison
shots, then enabled for the final count shots.

Rendering was performed with Xvfb/Mesa llvmpipe. A VSync-driver warning is expected
in that environment. Fixed-FPS captures are not performance benchmarks.

## Remaining limitations

- Named targets and bone lengths do not prove collision-free clothing or correct
  anatomical joint limits. Shoulder seams, hand penetration, and extreme joint
  bends still require art refinement and more viewpoints.
- Body offsets are visual only: up to 0.40 scale-adjusted metres during loading,
  0.80 m for a cover and 1.05 m for wrist-control placement. Whole-body rope clearance
  for those poses is not yet proven; gameplay roots and rope rules are unchanged.
- Ground correction uses torso envelopes, not per-vertex floor collision. Full
  recovery hand/knee support, finger curling, and foot roll need authored polish.
- The referee hand target is evaluated once in a settled counting pose. Late arrival
  can still make the first gesture incomplete, without delaying or biasing the count.
- No new likeness approval, unique character mechanics, Windows export, controller
  validation, target-GPU benchmark, or complete human match playtest is claimed.
