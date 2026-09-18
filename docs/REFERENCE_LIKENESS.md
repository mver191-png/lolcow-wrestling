> Historical v3.2 record. Current v3.3 coverage, sources and remaining limits are
> in `PORTRAIT_REFINEMENT_V33.md`; the two formerly provisional slots now have
> source-attributed first studies. This does not constitute likeness approval.

# Source-guided likeness pass (v3.2)

This is an original-model art update on the integrated v3.1 gameplay/deformation
base. It does not claim photoreal scans, approved likenesses, or reference accuracy
that the available pictures cannot establish.

## Reference coverage

Public pages and source-labelled stills were searched and inspected. The selected
portrait cues guide manually authored geometry, not face recognition or biometric
matching. Values in `tools/likeness_profiles.py` are artistic controls, not measured
physical attributes. Source URLs and unresolved slots are in
`docs/visual_reference_sources.json`.

- Tophiachu: broader lower face, smaller hooded eyes, voluminous dark curls,
  maroon headband and muted T-shirt palette.
- NovaOnline: fuller lower face, rectangular glasses, longer parted brown hair
  and purple casual-top treatment.
- Cyraxx: narrower face, higher hairline, brown beard and dark top; the invented
  beanie is removed. No wounds or medical traits are modeled.
- Candy Rooks: revised complexion, full lower-face/lip forms and short tight coils,
  replacing the previous generic pale face and bun.
- Andy Ditch: fuller face, uncovered scalp, rectangular glasses, restrained stubble
  and an orange-shirt palette.
- Daniel Larson: narrower jaw, longer nasal profile, smaller blue-toned irises,
  short uneven brown crop and blue/tan clothing cues.
- KingCobraJFS: higher hairline, longer side/back hair, thin oval frames, moustache
  and pointed goatee. His fictional referee shirt and one permanent halo remain.

These are source-guided model choices, not new biographical assertions. Web search
also returned unrelated photos, reconstruction/meme images, generic logos and
ambiguous multi-person thumbnails; those were rejected. In particular, the
Jupiter interview thumbnail did not unambiguously attribute its two faces, and
AnacondaSin candidates were logos or missing-photo placeholders. Both slots retain
provisional likeness designs. Clear individual front/side references are needed.

The reference photographs are NOT game textures and are NOT included in source,
release packages or runtime downloads. Temporary research workflows are removed
from the branch after study. Existing third-party rights are not claimed by us.

## Actual changes

`portrait_geometry.py` produces seven distinct head profiles with fitted eye
apertures/lids, nasal bridge/tip/wings, jaw/cheek/temple contours, thin fitted lips,
ears, glasses, source-selected hairlines and curved locks/coils. A monotone cubic
profile avoids the horizontal ridges caused by independently easing every ring.

Each studied head has an ORIGINAL 384 x 384 procedural albedo texture: subdued
color variation and facial-hair roots are authored in head UV coordinates. It is
not sampled from a photo. Neck surfaces and short-sleeve shoulder coverage are
refined, and costume palettes become less uniformly toy-like. Existing wrestling
boots, pads and abstract ring emblems are retained as fictional costume details.

All nine imported meshes have explicit color channels: non-tinted surfaces use
neutral white. In this engine import, adding colors only to one surface left its
material's vertex-color flag disabled; neutral channels on the remaining surfaces
restore the intended flag. The new import test checks the actual loaded material,
not just the presence of COLOR_0 in the exported JSON. No runtime Compatibility
material override is used.

No original gameplay joint, limb length, collider, roster stat, strike budget,
throw/recovery duration or terminal rule is changed. The 46-joint rig, complete
25-clip library, elbow/knee helpers, authored clothesline/flurry, contact fitting,
referee authority and square-envelope clearance remain.

## Verification and evidence

The existing integrated mechanics, scene-physics, contact, authored-motion,
deformation, mesh-clearance and CPU-match suites are rerun on the new models.
The Python suite has nine tests (including reference coverage, embedded texture
provenance, preserved landmarks and deterministic compilation). A new Godot suite
checks imported portrait materials, effective tint, rig/clip availability and halo
counts. A passing test is NOT a likeness score.

`tools/capture_likeness.gd` records 36 actual Godot views: front portrait, body,
three-quarter portrait and profile for all nine characters. Its neutral portrait
studio uses unshadowed fill to separate facial surfaces from coarse self-shadow
artifacts. Before and after use the identical studio/camera. The ordinary
shadow-enabled model gallery, bend studies and integrated match fixture remain
separate checks; they are not replaced by flattering portrait-only captures.

The rendered comparison uses old compiled v3.1 assets (`c5e0ca33`) versus the new
assets, not generated concept art. Software OpenGL is a rendering test, not a
hardware performance result. The demonstration stages moves and a kick-out; the
separate CPU-match smoke tests do not force outcomes.

See the exact CI artifact/logs for the published commit's results. Counts overlap
and repeat invariants; no human playtest, Windows executable, gamepad test, target
GPU benchmark or photorealistic/approved-character acceptance is implied.

## Reproduce

Downloaded project packages include the new GLBs. A raw source checkout must
rebuild the baseline binary files before importing into Godot:

```sh
python tools/build_roster.py
python tests/test_roster_assets.py
godot --headless --editor --path . --import
godot --headless --fixed-fps 60 --path . -s tests/test_likeness_assets.gd
godot --path . --rendering-method gl_compatibility --audio-driver Dummy --disable-render-loop --fixed-fps 60 -s tools/capture_likeness.gd
```

The generator needs Python's standard library only. Reference photos, Blender and
network access are not needed to build or run the models.

## Still open

Likeness approval remains subjective and incomplete. Faces are more differentiated
but still stylized, with static facial expressions. Hair locks, beard roots,
shoulder/sleeve seams, skin/clothing overlap and weight-bearing need further art
work. Portrait fill does not fix every game-lighting self-shadow artifact.
Physical rope/opponent collision, swept strike volumes, unique finishers/traits,
match balance, Windows/gamepads and target-hardware performance remain open.
