# Current review-branch state

The roster/venue overhaul, paired-contact, animation-polish and mesh-clearance work are on `astra/character-animation-overhaul`. Main remains unchanged; PR #1 remains a draft.

This continuation preserves the skinned roster, finger articulation, fictional ring-motion signatures, shared action clocks and MatchManager outcome authority. It corrects the leverage-throw knee pole, raises recovery ankle targets to account for boot soles, levels the supported foot, bounds excessive IK flexion, and adds geometry-derived canvas/rope-envelope protection after all pose processing. Paired actors receive a shared cosmetic offset; gameplay roots and rules are unchanged.

Local Godot 4.7.2 checks passed: 408 mechanics, 126 scene integration, 35 presentation, 305 overhaul, 72 animation-polish, 1,941 contact and 3,750 mesh-clearance assertions. Counts overlap. The new suite audits 4,999,432 deformed vertex positions across 32 edge/corner sequences with both slot/insertion orders. No sampled mesh crossed the canvas or square rope envelope; enabled/disabled clearance produced an identical tested gameplay trace. Consult the latest CI run for independent reproduction.

Actual staged Godot renders were inspected for leverage, recovery and corner landing. The recorded before/after fixtures improved from 19.2 cm, 7.9 cm and 75.2 cm penetration/overhang respectively to zero. Both comparisons used the same supported OpenGL material configuration. Unsupported Compatibility material overrides now fall back to imported PBR materials.

See `docs/CLEARANCE_PASS.md` for methods, capture commands, tolerances and limitations. The new guard is not opponent/rope-cylinder collision, and it can move the visible pose relative to gameplay origins. Authored recovery and fine contact still need work. Detailed character art, Windows export, gamepads, Forward+ performance and a comprehensive human playtest remain unverified.
