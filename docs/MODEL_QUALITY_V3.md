# Model quality v3 — implementation and verification

Base: `f9f8353` on `astra/model-quality-v3` (draft PR #3). The base failed before
building any assets: literal escaped newlines corrupted two Python source files.
Some advertised torso/head replacements had not applied. Both defects are repaired.

## Implemented art

`tools/character_geometry.py` now builds the actual meshes rather than changing a
polycount label. It includes dense, region-weighted torso/elbow/knee surfaces,
separate blended shoulder bridges, integrated jaw/cheek/nasal/eye-socket surfaces,
fitted eyelids and lips, scalp-following hair caps and curved hair locks, garment
panels that follow torso curvature, original ring emblems, boot/pad details,
modeled palms, medial thumbs, knuckles, tapered fingers and nails.

Four fingers now span palm width instead of being stacked through its depth.
The main humanoid bones and hand/foot gameplay-contact landmarks stay unchanged.
The rig remains 42 bones with 25 complete-channel clips. The 0.60-second recovery,
1.10-second throw, damage, input, match rules and roster stats are unchanged.

Author palette constants are sRGB and now get converted to linear glTF color
factors. Embedded texture pixels remain sRGB. This fixes the overly pale skin and
hair response caused by treating the authored palette as linear values.

Ready poses bring the hands toward the chest with inward-facing palms. Runtime
finger curls use bounded target rotations, not an additional full curl multiplied
onto already-curled animation. Dedicated recovery keeps ownership of the loaded
palm. All existing contact/referee work is preserved.

These are original stylized ring interpretations, NOT likeness-approved scans.
There is no claim of final production art or eight newly implemented finishers.

## Local verification actually executed

Godot 4.7.2 Linux, fixed-60-Hz test stepping; Python standard library. Existing
mechanics (408), scene physics (126), presentation (35), overhaul (305), paired
contact (1,941), animation polish (56) and recovery/event (142) assertions passed
with zero failures. The seven Python tests cover normalized region-safe weights,
actual geometry signatures, detailed regions, finger layout, stable landmarks,
palette conversion, deterministic GLBs and output-manifest checksums. Counts
include overlap and repeated invariants; they are not human playtests.

The new capture tool uses real Fighter scenes and ordinary physics updates. It
captures six views/states per wrestler plus three referee views: 51 PNGs, including
neutral full-body, three-quarter, portrait, strike, supported recovery and ready
again. It rejects uniform/blank frames. The first implementation exposed a stale
viewport/camera frame; the tool now waits for scene updates before explicitly
rendering. Generated image files alone are not aesthetic approval.

Before/after views use the same tool/camera/light; the before models come from
validated revision `5c11c236`. The new actor palette and geometry both differ.
A separate contact fixture renders the actual match arena and paired actions.
Software OpenGL (Xvfb/Mesa llvmpipe) reports an unsupported VSync warning. Import
retains the pre-existing Unicode parsing diagnostic; its source is not isolated.
No target-GPU performance claim is made. CI repeats the build, all suites and both
render fixtures; consult its result for the exact published revision.

## Run and reproduce

Downloaded game packages include compiled GLBs. Open `project.godot` in Godot
4.7.2 and run F5. They are source projects, not standalone Windows executables.

A raw GitHub source checkout needs an asset rebuild: the committed older binary
models are retained as baseline data; the compiler/CI artifact is authoritative for
v3. Run from the repository root before importing the project:

```sh
python tools/build_roster.py
python tests/test_roster_assets.py
godot --headless --editor --path . --import
godot --headless --fixed-fps 60 --path . -s tests/test_contacts.gd
godot --path . --audio-driver Dummy --rendering-method gl_compatibility --disable-render-loop --fixed-fps 60 -s tools/capture_model_quality.gd
```

No Blender or external Python package is needed to compile these original assets.
GLBs contain their textures and can be imported into Blender for further editing.
CI remains read-only and does not silently commit generated assets or merge PRs.

## Open art and platform work

- Marker contact tests do not validate whole-skin, clothing or rope collisions.
- Shoulder transitions, collar/panel intersections, hair silhouette and facial
  likeness still need art review; material/normal changes are not a substitute.
- The short get-up is still an arcade transition, not motion-captured recovery.
- Most named attacks still share underlying mechanics. This is an art and hand-
  presentation upgrade, not a moveset-completion claim.
- Hardware Forward+, gamepads, Windows export and a full human match are not tested.
- Finer authored grips, weight transfer and full-body clearance remain next steps.
