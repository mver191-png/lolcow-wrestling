# LOLCOW WRESTLING: OFFLINE MAYHEM

A stylized 3D arcade wrestling prototype for Godot. This overhaul replaces the
placeholder roster with nine original skinned actors, adds an indoor venue and
live character previews, and fixes presentation/input ownership regressions.

**Status:** playable development build, not a finished commercial game. The
character designs are fictional ring interpretations, not likeness-accurate
scans. Named moves and traits remain partly design metadata; they are not all
unique implemented mechanics. See [REVIEW.md](REVIEW.md) for tested changes and
remaining limits.

## Run the downloaded package

Open `project.godot` in **Godot 4.7.2** and press F5, or run:

```sh
godot --path .
```

On Windows, place the Godot executable beside `START_GAME.bat`, put `godot` on
PATH, or set `GODOT_BIN` to its path. Double-click the batch launcher. This is a
source project launcher, not a standalone exported Windows executable. On
systems without Forward+ support, use `--rendering-method gl_compatibility`.

The downloadable CI/package build includes the current compiled GLBs. Python and
Blender are **not** required to play that package.

**A raw GitHub clone is different:** its checked-in binary models are older
baseline assets. Before opening a clone in Godot, rebuild them with:

```sh
python tools/build_roster.py
```

Then let Godot finish asset import. CI rebuilds the same models from source and
ships the rebuilt files in its artifact; it does not push generated binaries.

## Controls

| Action | Player 1 | Player 2 |
|---|---|---|
| Move | W/A/S/D | Arrow keys |
| Strike | J | Numpad 1 or top-row 1 |
| Grapple; submission on grounded opponent | K | Numpad 2 or top-row 2 |
| Block | L | Numpad 3 or top-row 3 |
| Reversal | U | Numpad 4 or top-row 4 |
| Pin; tap or hold to resist | Space | Numpad 0 or top-row 0 |
| Finisher | I | Numpad 5 or top-row 5 |

Character selection supports the same movement keys. C changes Player 2 between
human and CPU. Space/Enter starts the match. Mouse click selects Player 1;
Right-click or Shift-click selects Player 2. Navigation also works while a roster
button has keyboard focus. Escape returns from a match to selection; R
restarts the match. The reviewed tests dispatch raw key and mouse events through Godot. They are not
physical gamepad or Windows-hardware validation.

## Roster

Tophiachu, NovaOnline, Cyraxx, Candy Rooks, Andy Ditch, Jupiter the Hybrid,
AnacondaSin, and Daniel Larson retain their canonical seven-stat allocations.
KingCobraJFS is the non-colliding, untargetable official with one head-attached
gold halo. The halo remains visible without bloom.

## What changed

- All eight wrestlers and the referee have a **46-joint** skinned rig (42 original joints plus four skin-deformation helpers),
  articulated fingers, differentiated proportions and gear, facial details,
  original embedded cloth textures, and a **25-clip animation library**.
- `tools/build_roster.py` is a deterministic, standard-library-only glTF asset
  compiler. Explicit anatomical regions own skin weights; wide torso vertices
  cannot be misclassified as arms. Every clip keys every bone.
- Presentation samples an authoritative action clock. Mirror matches isolate
  mutable animation resources. Skeletal throws no longer receive the legacy
  whole-model tilt. Landed wrestlers use a downed pose rather than replaying a
  standing collapse. Locomotion reads actual post-simulation travel.
- Human input release clears movement, guard, and held resistance. External
  providers opt in with `use_external_input` and complete command snapshots.
- The venue adds apron/signage, steps, barrier seating, instanced reacting crowd,
  overhead trusses, entrance area, and subdued materials/lighting.
- Character selection previews the actual in-game assets. HUD announcements and
  escape UI are less obstructive. Referee movement and signals use the new rig.

## Rebuild assets

```sh
python tools/build_roster.py
python tools/build_roster.py --character tophiachu
python tests/test_roster_assets.py
```

The `.glb` files include geometry, skin, animations, and original textures and can
be imported into Blender for further editing. The compiler is the editable
source of truth; manual Blender edits must be exported deliberately rather than
subsequently overwritten by the compiler. Old Blender entry points delegate to
the new compiler. The manifest records reproducible SHA-256 checksums.

## Verify

```sh
godot --headless --editor --path . --import
python tests/test_roster_assets.py
godot --headless --path . -s tests/test_suite.gd
godot --headless --fixed-fps 60 --path . -s tests/test_pin_balance_scene.gd
godot --headless --path . -s tests/test_visual_presentation.gd
godot --headless --fixed-fps 60 --path . -s tests/test_overhaul.gd
```

`test_overhaul.gd` uses engine-scheduled physics, including all 64 ordered
attacker/defender combinations through complete grapple/throw/release sequences.
It tests logic and pose ownership, **not** anatomically perfect grip contact.
The presentation suite is structural; bone/clip counts are not quality scores.

For actual rendered evidence (a graphics driver or virtual display is required):

```sh
godot --path . --fixed-fps 60 --rendering-method gl_compatibility --audio-driver Dummy -s tools/capture_review.gd
```

The capture tool saves actual engine images under `evidence/`. They are
repeatable diagnostic scenes, not proof of real-time performance. Target hardware
performance, native Windows export, gamepads, full-skin collision and
final likeness/art approval remain unverified. Existing grip IK uses markers,
not exact finger-to-skin collision.


## Self-review repairs after v3.3

The review found that action-only tests had missed incorrect keypad codes. The
real Player 2 digit keys now work; arithmetic keys no longer trigger unintended
actions. The invalid-key-code import diagnostics are gone. Selection uses larger,
better-lit model previews; right-click/focused navigation work; repeated updates
do not duplicate stat rows. Match entry builds each selected actor only once.

Every portrait's UV seam is closed with matching normals/weights. Beard roots are
fitted to the chin rather than a floating flat shelf. These are bounded repairs,
not a claim of photorealism or finished likenesses. Camera shake can be disabled
immediately, and camera easing does not overshoot after a long frame.

See `docs/SELF_REVIEW.md` for reproduced defects, checks and remaining limitations.
Run the new input/scene/camera suite with:

```sh
godot --headless --fixed-fps 60 --path . -s tests/test_review_regressions.gd
```
