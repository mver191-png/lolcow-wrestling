# Current recovery follow-up state

Work is isolated on `astra/recovery-contact-followup` in draft PR #2, targeting the original overhaul review branch (PR #1), not main. Incoming animation-polish changes through `61562cc9` are reconciled without force-updating that moving branch.

## Implemented

- Preserved the full skinned roster, venue, paired grips, lateral covers, wrist control, character-specific secondary stance/tempo accents, finger curls and gameplay authority.
- Added latched left-palm and phased ankle supports during the existing 0.60-second recovery. The secondary polish layer does not re-solve these limbs or close the loaded palm afterward.
- Added solver input/chain validation, true zero-weight no-op and contact-disable cleanup.
- Referee transitions blend; the final slap remains visible for 0.08 seconds after the result, without delaying or changing it.
- Added real-scene recovery/event checks and capture tooling. Compatibility retains authored embedded materials after runtime overrides exposed renderer errors. CI now also renders real software-OpenGL frames.

## Executed verification

Local Godot 4.7.2 checks: 408 mechanics, 126 scene physics, 35 presentation, 305 overhaul, 1,941 paired-contact, 142 recovery/event, and 56 secondary-animation/ownership assertions passed. Three Python asset-compiler tests passed. Counts overlap. CI runs the same suites; consult the workflow artifact for its exact commit and result.

All eight bodies at two orientations passed loaded recovery-marker checks within 2.5 cm. This is not skin collision or anatomical correctness. Actual scripted Godot frames were captured with Xvfb/Mesa llvmpipe. Final Compatibility captures have no engine errors; an unsupported VSync warning remains. These are not performance benchmarks or comprehensive human playtests.

See `docs/CONTACT_ACCEPTANCE.md` and `KNOWN_ISSUES.md`. Full-body clearance, natural authored transitions, distinct move mechanics, Windows export, gamepads and target-GPU Forward+ behavior remain open. Do not auto-merge either draft PR.
