# Self-review and repair pass after v3.3

Reviewed baseline: `69b810fc41f68d6967b0d404c8d9925937ba9f2e`.
Work remains on the draft model-quality branch. Main is not merged.

## What the earlier validation missed

The previous numerical and rendering work was useful, but it did not establish
practical local-two-player usability or closed portrait surfaces. Large assertion
counts are not substitutes for testing actual events and exported geometry.
The new interaction suite was run against the old source: **38 of its 94 checks
failed**. The repaired source passes all 94. These include optional new top-row
bindings, not 38 independent bugs.

### 1. Player 2's advertised keypad controls were incorrect

`project.godot` bound strike to keypad Multiply, grapple to Divide, guard to
Subtract, reversal to Period, and finisher to Add. Pin used an undefined code
`0x400080`. In the pinned engine KEY_KP_0 is 4194438, not 4194432.

The keypad digit bindings are corrected and top-row 0–5 alternatives added.
Verbose redundant event fields are removed; executable tests compare events with
Godot's named key constants. Raw `InputEventKey` presses/releases now drive actual
striking, guarding and pin resistance. P2 keys do not operate P1.

The undefined pin code also caused the recurring **invalid-Unicode import
messages** previously left unexplained. Clean import after the correction no
longer reports them. This was an input configuration defect, not text encoding.

### 2. Every generated head had an open texture seam

The front-surface function clamped its lateral coordinate to .999. The back half
ended at the true ellipse boundary. The two copies of the UV 0/1 vertex therefore
occupied different positions. Actual v3.3 GLBs measured roughly **5.97–6.93 mm**
gaps, with inconsistent normals, across all nine heads.

The features now fade to the exact elliptical boundary; the duplicate seam
position is explicitly shared. Both UV coordinates remain distinct. Tests check
positions, normals, skin joints and weights, not merely finite values. The new
exports have **zero position and normal-vector difference at all 873 seam pairs**.
`tools/audit_portrait_seams.py` reads actual exported GLBs and can compare an older
package without changing any assets.

### 3. Beard roots formed a detached flat shelf

The old fixed-width beard shell sat 5–15 mm ahead of its attachment region.
Its separate fibers also formed a straight curtain. The shell now tapers within
the chin cross-section, blends into the root within 1 mm, and rounds backward
under the chin. Fine fibers follow that surface rather than a disconnected plane.
This affects the existing beard/goatee geometry; it is not a new identity claim.

### 4. Selection controls and previews needed real UI testing

Arrow navigation in `_unhandled_input` was consumed by focused buttons. Right-click
was mentioned in the code but not implemented. Both now work through the real GUI
input path. Rapid display updates immediately detach old stat rows, preventing
same-frame duplication. Match launch has a repeat-entry guard.

The old full-body previews were small and dark at 1280×720. Upper-body framing,
front fill, panel padding and contrast-preserving selection borders make them
more readable without changing the actor meshes or game lighting. The real
render-loop test inspects both SubViewport images, not only the enclosing UI.

A separate capture-only issue was found: a manually disabled render loop could
save a UI frame before nested viewports updated. The self-review capture explicitly
schedules its viewports; the production preview still uses UPDATE_WHEN_VISIBLE.
The normal-loop capture separately verifies what the running menu displays.

### 5. Match entry initialized each model twice

Fighter._ready built the default model, then MainScene._ready rebuilt the chosen
model and its skin-bound caches, including when the selection had not changed.
Selections now apply before child readiness. Tests observe **one character-loaded
signal per selected actor instead of two**, with the correct identities and CPU
mode. This is not a measured hardware load-time benchmark.

### 6. Camera accessibility and frame-stall behavior

Disabling shake previously did not stop existing trauma offsets. It now clears
residual trauma immediately. Exponential camera smoothing replaces an unclamped
linear interpolation factor that could overshoot after a long frame.
The camera tests verify both conditions, including a one-second diagnostic step.

## Verification actually executed locally

Godot 4.7.2 on Linux, engine-driven physics, synthetic raw keyboard/mouse events,
Python standard-library asset tests and Mesa llvmpipe OpenGL captures. No physical
keyboard/gamepad or Windows-hardware playtest is implied by synthetic input.

All existing configured suites passed, including mechanics, scene physics,
presentation, overhaul, contact matrix, secondary animation, recovery/referee,
authored attacks, mesh clearance, joint deformation, portrait import and the two
unforced CPU matches. The **94 new interaction checks and 12 Python test cases**
also passed. Existing CPU matches still end at 11.02 and 16.35 simulation seconds;
that demonstrates limited termination, not balanced pacing.

New tests must pass again in the commit's CI before an artifact is described as
CI-validated. The workflow additionally performs a real selection-screen render
and rejects missing/unreadable previews. Current local import has no invalid-
Unicode diagnostics. Software rendering retains the driver's VSync warning.

## Reproduction

```sh
python tools/build_roster.py
python tests/test_roster_assets.py
python tools/audit_portrait_seams.py
# Optional quantitative comparison with the previous downloaded package:
python tools/audit_portrait_seams.py --baseline-zip previous-project.zip
godot --headless --editor --path . --import
godot --headless --fixed-fps 60 --path . -s tests/test_review_regressions.gd
godot --path . --rendering-method gl_compatibility --audio-driver Dummy --fixed-fps 60 -s tools/capture_selection_review.gd
```

Full raw-clone rebuild instructions are now prominent in README. Downloaded
packages include compiled GLBs; raw GitHub still retains historical binaries and
requires the deterministic Python build before import. No draft is auto-merged.

## What is still not finished

The faces remain stylized, static and not likeness-approved. Beard/hair detail,
shoulder/clothing overlap, natural weight-bearing and precise grips need further
art review. No new face animation, photorealism, unique finisher mechanics or
physical rope/opponent collision is claimed. The square-envelope clearance is
cosmetic and can introduce visible offsets. Strike contacts remain logical ranges.
Broader match balance, controllers, Windows export, Forward+ target-GPU behavior
and comprehensive human playtesting remain open. These repairs are not a release
or production-art sign-off.
