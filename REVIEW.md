# Overhaul implementation and verification

Base: `2307d013405ed3388b404b1b9ff29a7fd2c99cfb`. Work is isolated on
`astra/character-animation-overhaul`; this change does not merge or modify main.

## Implemented

**Input:** Hardware sampling is a full current snapshot. Releasing a key clears
movement/block/hold; focus loss and CPU ownership switches clear inputs. Tests
which inject commands explicitly opt into an external provider. Existing race
and result assertions were retained rather than weakening them to accommodate
stale input.

**Characters:** Nine deterministic original GLBs replace the previous primitive
roster. Each has 42 bones, finger articulation, 25 complete-pose animation clips,
UVs, embedded woven material textures, facial components, differentiated hair,
gear, and proportions. Torso weighting is explicitly separate from arms. The
bone count is a compatibility contract, not a claim of finished character art.
The generic animation vocabulary is shared; body scaling and appearance vary.

**Animation:** Presentation runs after fighters and match resolution. Paired
actors sample the attacker's authoritative clock, with shared impact/release
phase mapping. No skeletal defender receives a legacy `VisualRoot` tilt. A
finished throw transitions into a settled downed pose. Complete bone channels
prevent one clip from inheriting an unkeyed limb/hip pose from another. Mirror
instances own separate mutable AnimationLibraries. Gait playback measures actual
travel rather than dividing two copies of the requested speed. Cross-blends and
cosmetic chest hit recoil do not affect damage or victory.

**Venue:** New ring materials, canvas branding, seams, apron folds, steps, barriers,
seating, entrance wall, trusses/practicals and varied instanced crowd. Crowd bobs
are staggered and respond to count/result signals. Existing ring physics remain.
The stage is deliberately compact; geometry is inexpensive repeated scenery.

**Referee/UI:** Single skinned halo, smooth repositioning, authored count/wave
poses, selection previews from real GLBs, roomier roster buttons, less obtrusive
match messages and contextual resistance UI. The referee communicates outcomes;
it never determines their legality or delays the authoritative count.

## Local checks actually executed

Environment: Linux x86_64, Godot 4.7.2 stable official, software OpenGL Compatibility
rendering through Mesa llvmpipe and Xvfb. Python asset generation requires no
third-party packages. Blender was not installed and was not used.

| Check | Local result |
|---|---:|
| Existing unit/mechanics suite | 408 passed, 0 failed |
| Existing scene integration suite | 126 passed, 0 failed |
| Updated presentation suite | 35 passed, 0 failed |
| New engine-scheduled overhaul suite | 305 passed, 0 failed |
| Python asset compiler tests | 3 tests passed (includes all nine profiles) |

Counts are suite assertions, not claims of independent exhaustive coverage.
Presentation checks overlap parts of the unit suite. New tests include press AND
release, neutral external snapshots, focus/provider resets, all roster imports,
mirror-instance isolation, complete 64-pair grapple lifecycles, single impact,
shared clip clocks, downed transitions, and recovery. Python checks include region
weights, finite normalized exports, deterministic byte equality, complete bone
channels, and checksums of all committed/generated GLBs.

Actual baseline and overhaul images were rendered, inspected, and included in the
conversation evidence package. The capture tool itself is included in source.
The virtual graphics driver reports an unsupported VSync-setting warning; this
is not presented as a zero-warning GPU performance run. Diagnostic fixed-FPS
captures do not measure achieved FPS.

## Remaining limitations (do not mark closed)

1. The models are **stylized development art**, not approved likenesses or final
   production characters. Facial expression/blend shapes, texture painting,
   material finesse, and continuous skin/clothing topology need an art pass.
2. Paired animations now share clocks/pose ownership but **hands are not yet
   constrained to physically accurate grips** across every physique. Pins,
   submissions, and recovery have approximate contact and can intersect.
   Rigging and a passing lifecycle test do not establish anatomical contact.
3. Most canonical move names and traits are still metadata around common
   mechanics. Unique multi-hit moves, stance systems, entrances, and individual
   finishers are not claimed complete. Existing balance/stat data is preserved.
4. Full-body ring clearance is not established by the retained origin-bound
   clamp. Thick limbs may cross ropes. No player ring-exit or rope-spring physics
   was added.
5. Referee arrival and hand-to-mat choreography need visual refinement. The
   authoritative count remains fair even when travel makes a gesture late.
6. Manual animation-camera captures and automated scene tests were run, not a
   comprehensive human playtest. Windows export and gamepads were not tested.
7. Hardware performance/VRAM targets were not measured; software rendering is
   unsuitable for representing the user's PC. Forward+ needs hardware validation.
8. Audio uses the existing synthesized effects. No voice cloning, unlicensed
   media, online play, tournament mode, or additional remote services were added.

## Next bounded work

Author and validate one two-character paired move with explicit grip targets,
foot-support targets, and bounded two-bone IK. Inspect frame-by-frame contact in
Tophiachu/Cyraxx and the reverse/mirror pairs before generalizing. Then refine
likeness-approved topology, materials, and character-specific mechanics. Do not
replace these open art/contact tasks with more assertion-count claims.
