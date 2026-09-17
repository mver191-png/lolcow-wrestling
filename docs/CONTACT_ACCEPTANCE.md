# Contact and recovery acceptance

Continues the contact work on `06260e8de03896c86988c0bd63177ff0e860b121`; main is untouched. All original character assets and gameplay rules are preserved.

## Implemented in this follow-up

- `RecoveryContact` layers a latched left-palm support and phased ankle targets over the existing 0.60-second recovery. The loaded hand opens; pelvis loading is cosmetic. World-space support anchors do not follow an already-sliding hand or foot.
- Limb corrections change rotations only. No segment scaling, extra gameplay-root movement, damage changes or recovery-duration changes.
- Zero-weight IK is a genuine no-op. Invalid indices, non-hierarchical chains and nonfinite targets/poles/weights reject safely.
- Disabling contact during a cover clears the visual offset instead of repeatedly restarting exit easing.
- The referee retains the third-count mat-contact pose for 0.08 seconds after the result is decided, then blends into the winner gesture. This never delays the official result. Other pose changes blend over 0.16 seconds. Diagnostics measure the final visible hand pose.
- The existing 1,941-check contact suite and new recovery/event suite run in read-only CI.

## Local checks actually executed

Godot 4.7.2 Linux, fixed 60 Hz diagnostic stepping. No hardware frame-rate claim.

| Suite | Passed | Failed |
|---|---:|---:|
| Existing mechanics/unit | 408 | 0 |
| Existing scene physics | 126 | 0 |
| Existing presentation | 35 | 0 |
| Existing overhaul integration | 305 | 0 |
| Paired contact matrix | 1941 | 0 |
| New contact/recovery acceptance | 142 | 0 |
| Python asset compiler | 3 | 0 |

Counts overlap and do not represent independent playtests. The new suite covers eight bodies at two orientations, support acquisition/release, fixed anchors, unchanged limb lengths, root neutrality, disabled-contact cleanup, invalid IK requests, and all three official count events including terminal resolution. Samples are written to `evidence/recovery-acceptance.json`.

## Render reproduction

```sh
godot --path . --audio-driver Dummy --rendering-method gl_compatibility --disable-render-loop --fixed-fps 60 -s tools/capture_contact_acceptance.gd -- --video
godot --path . --audio-driver Dummy --rendering-method gl_compatibility --disable-render-loop --fixed-fps 60 -s tools/capture_contact_acceptance.gd -- --baseline
```

Run these with a real or virtual display, not `--headless`. `--baseline` disables only the new recovery support layer; the existing paired contact solver remains enabled. PNGs are actual game frames; the optional frame sequence is scripted and silent, not a human match. The clean third-count image hides only the CanvasLayer for inspection. Capture uses explicit RenderingServer draws. Xvfb/Mesa llvmpipe emits an unsupported VSync warning.

## Still open

Palm/ankle markers and anatomical envelopes are not whole-mesh collision. Some body and clothing intersections remain, especially through fast transitions. The recovery is still the deliberately short 0.60-second arcade action, not a motion-captured get-up. Reach correction only covers defined contact windows; grip acquisition and release need additional authored polish. No target-GPU performance, Windows export, controller coverage, or comprehensive human-match acceptance is claimed.
