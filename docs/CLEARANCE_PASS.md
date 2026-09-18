# Mesh-clearance continuation

Baseline: `bd81a79906353991079dfc6c50f6e4a0bf5addb0` (code matches the last validated animation-polish artifact; the final baseline commit only updated STATE.md).

## Problems reproduced and repairs

The existing palm/ankle-marker tests passed while parts of the mesh still entered the canvas. Actual CPU-skinned vertex measurements reproduced roughly 19.2 cm of penetration during a Cyraxx leverage throw and 7.9 cm during a Tophiachu get-up. A staged corner landing extended about 75.2 cm beyond the square rope envelope.

- Corrected the leverage stance's knee pole. It no longer selects a knee bend below the floor while apparently satisfying the ankle target.
- Recovery targets now account for the boot sole rather than placing the ankle at floor level. The supported foot blends to a level orientation.
- ContactIK now bounds excessive flexion (165 degrees by default, configurable), rejects invalid bone indices and malformed chains, and reports when a joint limit prevents reaching a target. Bone lengths and scales remain unchanged. This is not a full shoulder/twist/anatomical joint model.
- Added SkinnedSurface: a CPU-side linear-skinning validator using the imported inverse binds, bone mapping and actual mesh vertices. It does not read back GPU data.
- Added PresentationClearance at physics priority 40, after pose sampling, paired contact and animation polish. It computes geometry-derived conservative bounds and applies a bounded cosmetic translation. Held actors receive the same translation, preserving their relative grip geometry. Neither gameplay roots, collision shapes, damage nor result rules are changed.
- Added a Compatibility-renderer material fallback. Optional material overrides reproduced invalid material diagnostics during model replacement under OpenGL. Compatibility and Mobile now use the imported PBR materials; Forward+ keeps the optional overrides. The Forward+ path is not hardware-verified in this continuation.

## Why the bounds enclose the current mesh

Vertices sharing an identical skin-joint/weight tuple undergo the same affine transform. The runtime groups those tuples without weight quantization, caches a bind-space AABB per group, transforms each group box by its blended skin transform and unions the results. The result encloses each group's vertices while requiring fewer evaluations than full CPU skinning every tick.

The tests independently skin every vertex at sampled poses and check enclosure. Bounds are not inferred from bone centers. The implementation covers the current normalized linear-blend-skinned GLBs. Blend shapes, shader displacement, simulated cloth and unskinned accessories are outside this implementation's contract.

## Limits and authority

The current arena has its canvas at world Y=0 and ropes at X/Z +/-3.8 m. The guard uses a 5 cm horizontal envelope margin and an 8 mm floor margin. It caps vertical correction at 0.30 m and each horizontal axis at 1.20 m. If an action cannot fit inside those caps, residual error and a limited flag are reported. The solver never shrinks a character to pass.

Corrections release toward zero at a bounded rate. Safety takes precedence over smooth interpolation when a newly sampled pose penetrates the envelope. There can consequently be a visible adjustment on a badly fitting entry pose; this is not a substitute for authoring that pose correctly.

The envelope is a conservative square boundary, NOT collision against rope cylinders, turnbuckle pads, the other wrestler, or the referee. Shared cosmetic offsets may separate visible bodies from their gameplay origins. Normal near-rope holds still follow the existing rope-break rules. Floor protection does not guarantee zero hovering, anatomically convincing recovery, or correct weight-bearing contact.

## Checks run locally

Godot 4.7.2, Linux:

| Suite | Passed | Failed |
| --- | ---: | ---: |
| Mechanics/unit | 408 | 0 |
| Scene-physics integration | 126 | 0 |
| Presentation | 35 | 0 |
| Existing overhaul integration | 305 | 0 |
| Animation polish | 72 | 0 |
| Paired contact | 1,941 | 0 |
| New mesh clearance | 3,750 | 0 |

Counts overlap and include repeated assertions; they are not independent human playtests. The clearance suite stages 32 sequences: eight roster characters, two slot/insertion orders and two edge/corner layouts. It checks 4,999,432 deformed vertex positions across standing, throw, cover, wrist-control and recovery snapshots. No sampled vertex penetrated the canvas or exceeded the +/-3.8 m envelope, and none of those fixtures exceeded correction caps. This is sampled validation, not exhaustive proof for every possible animation, position or interpolated render frame.

The existing contact suite still exercises all 64 ordered pairings in both orders. A new 90-tick corner-throw gameplay trace is identical with clearance enabled versus disabled.

Reproduce after import:

```sh
godot --headless --editor --path . --import
godot --headless --fixed-fps 60 --path . -s tests/test_clearance.gd
```

The new suite writes evidence/clearance-samples.json. CI also runs it and publishes the results with the project artifact.

## Rendered inspection

Actual Godot before/after images were captured at fixed poses for leverage, recovery and corner landing. Both comparison runs used the same supported Compatibility material configuration, scene, camera and assets. The baseline has the prior pose/contact code; the updated run has the corrections above.

The sampled before/after values were 19.2 cm -> 0 canvas penetration for the leverage stance, 7.9 cm -> 0 for the recovery pose, and 75.2 cm -> 0 outside the rope envelope for the staged corner landing. These are measurements of those fixtures, not general performance claims.

```sh
godot --path . --audio-driver Dummy --rendering-method gl_compatibility --fixed-fps 60 -s tools/capture_clearance.gd
```

The tool intentionally freezes gameplay clocks to produce repeatable review poses. It is not a human match. Rendering used Xvfb/Mesa llvmpipe, with an unsupported VSync warning. The corrected captures emitted no material errors. A separate short create/free smoke fixture reported two ObjectDB instances at shutdown, also present with the optional material layer disabled; its origin has not been isolated. No target-GPU frame-rate claim is made.

## Still pending

Authored transitions that need fewer safety offsets, complete anatomical joint limits, finger-to-skin and opponent collision, detailed face/hair/clothing assets, referee first-count approach polish, unique move mechanics, Windows export, gamepads, Forward+ target-hardware performance and a comprehensive human match playtest. Main remains unchanged and the PR remains a draft.
