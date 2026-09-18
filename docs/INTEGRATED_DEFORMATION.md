# Integrated v3.1 models, authored combat and joint deformation

## Branch reconciliation

This revision combines `8fc5dedd` (v3 model/recovery branch) and `0abb1ffe`
(authored primary strikes/full-mesh clearance branch) without merging any draft PR
or changing main. Publication stays on `astra/model-quality-v3`, draft PR #3.
The merge commit records both ancestors. Earlier PRs remain untouched.

The preceding v3 package did not include the newer authored strike schedules or
mesh-clearance pass. The combined package does. Tophiachu retains the one-hit
78-damage clothesline; Cyraxx has three left/right/left hits sharing one 54-damage
and Hype budget. These are retained mechanics, not newly invented finishers.

## Actual skin changes

Four appended skin-only joints follow the shortest half-angle of each elbow/knee.
The original 42 indices, parents, translations and contact landmarks stay unchanged;
there are now 46 joints total and 25 clips with 92 complete channels. The helpers
are siblings of their lower-limb drivers, not inserted into gameplay IK chains.
They update after authored animation/contact/polish and before mesh clearance.
Their tracks are also baked for previews and the referee updates them after count IK.

The crease ring follows a single rigid half-angle helper. Nearby rings blend back
to their respective limbs, avoiding the older averaging that flattened the crease.
Arm/leg ring spacing is refined around bends. Knee pads and inserts follow the knee
helper rather than swinging away with the shin. Neither bone lengths nor gameplay
roots are stretched/moved to fit the skin. Neighboring flesh and clothing can still
intersect; this is not full anatomical joint modeling or volume conservation.

`tools/roster_base.py` preserves the exact previous v3 exporter and palette. The new
`tools/build_roster.py` specializes rig, weights, bend surfaces and pad attachment.
`tools/character_geometry.py` is unchanged. Faces, fitted eyes/lips, hair, outfits,
medial thumbs and bounded finger curls are retained. This is not another face rebuild.

## Pose ownership and clearance

Tophiachu/Cyraxx use their authored recovery; the other six retain latched support.
Only one recovery layer owns a limb at a time. The shared action clock, zero-weight
IK no-op, safe disabled-contact cleanup and final referee slap retention are kept.

The integrated final clearance pass measures the imported skinned geometry rather
than bone centers. It uses bounded visual translations and a conservative square
ring envelope, not collisions against actual rope cylinders, opponents or referee.
Those corrections preserve paired relative contact but can create visible hovering
or differences between rendered and gameplay origins. Original caps are unchanged.

## Executed local verification

Godot 4.7.2 Linux; fixed 60-Hz test stepping is not a hardware FPS measurement.

| Suite | Passed | Failed |
|---|---:|---:|
| Mechanics/unit | 408 | 0 |
| Scene physics | 126 | 0 |
| Presentation | 35 | 0 |
| Overhaul integration | 305 | 0 |
| Paired-contact matrix | 1941 | 0 |
| Isolated secondary-animation/support contract | 56 | 0 |
| Isolated latched recovery and live referee events | 142 | 0 |
| Authored primary attacks/recovery | 1630 | 0 |
| Full-mesh clearance | 3750 | 0 |
| New joint deformation | 552 | 0 |
| Whole-match smoke | 32 | 0 |
| Python asset/compiler tests | 8 | 0 |

Counts overlap and repeat invariants. Two legacy support suites deliberately disable
final clearance/authored motion to isolate their existing contract; they are not
final-composed-pose proof. Authored motion, clearance and deformation suites test the
combined behavior separately. No previous gameplay assertions were removed.

The new deformation suite evaluates the actual CPU-skinned crease ring (33 vertices,
including UV seam) on all eight wrestlers, four joints and 0/45/90/135-degree bends.
In the controlled 135-degree bend, the preceding blend rule retains about 38.3% of
that ring's projected bind cross-sectional area; the new helper retains about 100%.
This is a defined crease-ring measurement, NOT 100% whole-limb volume retention,
collision freedom or aesthetic certification. The old rule is applied to the same
ring for this controlled metric; rendered A/B uses the actual preceding v3 models.

The latest mesh-clearance suite audited 14,706,000 deformed vertex positions at 608
sampled poses. No sampled corrected vertex penetrated the canvas or exceeded the
configured square envelope. Sampling and conservative bounds do not prove continuous
collision safety or naturally grounded motion in every possible match.

Two seeded CPU-versus-CPU matches (Tophiachu/Cyraxx and reversed) reached natural
pinfall through the real controllers, with no forced HP, hit calls or escape values.
They lasted about 11.02 and 16.35 simulation seconds and emitted one result each.
These are smoke tests only; short matches and the small sample do not establish balance.

## Rendered verification and reproduction

The actual Godot capture tools produce 51 roster frames, 24 elbow/knee/upper-body
studies, contact/referee views and a 173-frame silent match demonstration. The match
fixture drives actions with commands but forces one kick-out to show recovery; it
is not the natural CPU smoke test and not a human-played match.

Same-camera bend comparisons use the preceding v3 GLBs against the new assets.
Software OpenGL/Xvfb/Mesa llvmpipe is used. VSync support warnings and the pre-existing
invalid-Unicode import diagnostics are not claimed fixed. Forward+ hardware performance,
Windows executable export, gamepads and comprehensive human playtesting are NOT RUN.
CI rebuilds all assets and repeats every suite plus actual rendering. Use its exact
job result and artifact manifest to establish published-revision verification.

```sh
python tools/build_roster.py
python tests/test_roster_assets.py
godot --headless --editor --path . --import
godot --headless --fixed-fps 60 --path . -s tests/test_joint_deformation.gd
godot --headless --fixed-fps 60 --path . -s tools/soak_match.gd
godot --path . --audio-driver Dummy --rendering-method gl_compatibility --disable-render-loop --fixed-fps 60 -s tools/capture_deformation.gd
godot --path . --audio-driver Dummy --rendering-method gl_compatibility --disable-render-loop --fixed-fps 60 -s tools/capture_integrated_match.gd
```

Downloaded complete-game packages and CI artifacts include the compiled v3.1 GLBs.
A raw GitHub checkout retains baseline binaries and must run the compiler before
import. No Blender or external Python package is needed for that build. CI is
read-only and does not push generated binaries or merge draft PRs.

## Remaining work

Shoulder/armpit seams, extreme flesh/clothing overlap, fingers gripping actual skin,
precise swept strike volumes, physical rope/opponent collision, stronger face/hair
likeness, distinct finishers/traits and human-facing balance remain unfinished. The
art remains original stylized ring interpretations, not likeness-approved scans.
Further improvements should target authored poses and topology, not hide issues
with larger correction caps or more post-processing.
