# Current review-branch state

All implemented work remains on `astra/character-animation-overhaul`; PR #1 is a
draft and main is not merged. The roster, venue, paired-contact, animation-polish
and full-mesh clearance work is retained.

The latest continuation adds real per-hit primary-strike schedules: one
Comment-Section Clothesline for Tophiachu and a three-hit Feedback Flurry for Cyraxx.
The flurry divides the existing damage/Hype budget instead of multiplying it.
Stamina is charged once. Missed windows, mid-sequence reversals and invalid targets
are handled. Authored skeletal strike poses follow the gameplay identifier/clock.

Tophiachu and Cyraxx now use authored seated-to-crouch-to-stand recovery with foot
supports and a reachable thigh brace. In the tested 38-frame center-ring sequence,
mean cosmetic lift fell from 3.89 cm to 0.54 cm for Tophiachu and from 2.87 cm to
zero for Cyraxx. Existing correction caps, root transforms and recovery timing
were not changed. The new pose layer can be disabled for honest comparisons.

Local Godot 4.7.2 results: 408 unit, 126 scene integration, 35 presentation,
305 overhaul, 1,941 contact, 76 animation-polish, 3,750 clearance and 1,630 new
authored-motion assertions passed. Three Python asset tests passed. Counts overlap;
consult CI artifacts for the independently executed branch result.

Actual before/after front/side recovery and strike poses were rendered in Godot
using software OpenGL and inspected. These are staged diagnostic views, not a full
human match or a performance benchmark. See `docs/AUTHORED_MOTION_PASS.md` for
commands, metrics and limitations. Precise strike hit volumes, joint/skin quality,
individual finishers, Windows export, gamepads and target-GPU performance remain
unverified or unfinished.
