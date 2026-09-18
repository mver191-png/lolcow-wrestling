# LOLCOW WRESTLING: OFFLINE MAYHEM

A stylized 3D arcade wrestling prototype for Godot. This overhaul replaces the
placeholder roster with nine original skinned actors, adds an indoor venue and
live character previews, and fixes presentation/input ownership regressions.

**Status:** playable development build, not a finished commercial game. The
character designs are fictional ring interpretations, not likeness-accurate
scans. Named moves and traits remain partly design metadata; they are not all
unique implemented mechanics. See [REVIEW.md](REVIEW.md) for tested changes and
remaining limits.

## Run

Open `project.godot` in **Godot 4.7.2** and press F6/F5, or run:

```sh
godot --path .
```

On Windows, place the Godot executable beside `START_GAME.bat`, put `godot` on
PATH, or set `GODOT_BIN` to its path. Double-click the batch launcher. This is a
source project launcher, not a standalone exported Windows executable. On
systems without Forward+ support, use `--rendering-method gl_compatibility`.

Compiled GLBs are included; Blender and Python are **not** required to play.
After cloning, let Godot finish its initial asset import.

## Controls

| Action | Player 1 | Player 2 |
|---|---|---|
| Move | W/A/S/D | Arrow keys |
| Strike | J | Numpad 1 |
| Grapple; submission on grounded opponent | K | Numpad 2 |
| Block | L | Numpad 3 |
| Reversal | U | Numpad 4 |
| Pin; tap or hold to resist | Space | Numpad 0 |
| Finisher | I | Numpad 5 |

Character selection supports the same movement keys. C changes Player 2 between
human and CPU. Space/Enter starts the match. Mouse click selects Player 1;
Shift-click selects Player 2. Escape returns from a match to selection; R
restarts the match. Keyboard-only controls are the currently verified input path.

## Roster

Tophiachu, NovaOnline, Cyraxx, Candy Rooks, Andy Ditch, Jupiter the Hybrid,
AnacondaSin, and Daniel Larson retain their canonical seven-stat allocations.
KingCobraJFS is the non-colliding, untargetable official with one head-attached
gold halo. The halo remains visible without bloom.

## What changed

- All eight wrestlers and the referee have a consistent **42-bone** skinned rig,
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
performance, native Windows export, controller support, precise grip IK, and
final likeness/art approval remain unverified.
