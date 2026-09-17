# LOLCOW WRESTLING: OFFLINE MAYHEM - COMPLETE CODEBASE DIGEST FOR GPT PRO

This document contains the complete codebase and graphics overhaul progress for source inspection.

## File: STATE.md

```markdown
# Project State: LOLCOW WRESTLING: OFFLINE MAYHEM

## Milestone Status: Graphics & Animation Overhaul (Phase 1: Humanoid Rig & Tophiachu Production Asset Complete)
- **Engine**: Godot 4.7.2 (stable official, Windows x64) - Installed & Verified.
- **3D DCC Pipeline**: Blender 5.0.1 (headless Python automation) - Verified & Operational.
- **Target**: 1080p @ 60 FPS, Windows standalone.
- **Authoritative Combat Loop & Integration**: Verified with 530 automated headless tests (404 unit/mechanics/presentation tests + 126 full scene physics integration tests, 0 failures, 0 warnings, 0 ObjectDB leaks).
- **Graphics & Animation Status**: Phase 1 implemented per `GEMINI_GRAPHICS_ANIMATION_MASTER_PROMPT.md`. Tophiachu rebuilt with 22-bone humanoid armature and 16 keyframed skeletal animation clips. `FighterPresentation` component active with locomotion stride scaling and backward-compatible fallbacks for unmigrated roster. Cyraxx and KingCobraJFS referee queued next. Headless automated checks 100% PASS; interactive screen rendering remains **NOT RUN** per headless protocol.

---

### Graphics & Animation Overhaul Progress (Specification: GEMINI_GRAPHICS_ANIMATION_MASTER_PROMPT.md)

1. **Tophiachu Production Asset (Implemented & Verified)**:
   - Built custom Blender 5.0 generator script (`blender/build_skinned_character.py`).
   - Humanoid armature with 22 canonical bones (`Root`, `Hips`, `Spine`, `Chest`, `Neck`, `Head`, `Clavicle.L/R`, `UpperArm.L/R`, `Forearm.L/R`, `Hand.L/R`, `Thigh.L/R`, `Shin.L/R`, `Foot.L/R`, `Toe.L/R`).
   - Stylized heavyweight anatomy with custom proportions: wide torso, voluminous curly hair cluster, defined facial features (brow, nose, jawline), layered purple wrestling singlet with magenta accents, wrist wraps, and black wrestling boots.
   - Smooth vertex weighting across head, torso, upper limbs, and lower limbs with zero rigid bone popping.
   - Authored 16 keyframed animations pushed to NLA tracks: `idle` (breathing loop), `walk` (weighted heavyweight stride), `strike` (heavy right straight), `knockdown` (dramatic back collapse), `getup` (staggered recovery), `block`, `reversal`, `grapple`, `throw_attacker`, `throw_defender`, `pinning`, `pinned`, `submission_attacker`, `submission_defender`, `victory`, `defeated`.
   - Exported to clean multi-action glTF binary (`assets/models/tophiachu.glb`).

2. **FighterPresentation Architecture (`scripts/fighter/fighter_presentation.gd`)**:
   - Dedicated presentation component decoupled from gameplay authority.
   - Automatically detects `Skeleton3D` and `AnimationPlayer` in loaded glTF scenes.
   - Sets `has_skeletal_rig = true` only when all core clips (`idle`, `walk`, `strike`, `knockdown`, `getup`) are present.
   - State-driven animation playback routing with appropriate transition blends (0.12s smooth blend for locomotion/idle, 0.05s responsive cuts for strikes and knockdowns).
   - Locomotion stride speed matching: dynamially scales `anim_player.speed_scale = clamp(actual_speed / nominal_speed, 0.4, 1.8)` preventing foot sliding.
   - Zero gameplay retiming: animation clips follow state machine timers, never deciding match mechanics or damage windows.

3. **Legacy Fallback & Backward Compatibility Guarding**:
   - `Fighter` guards legacy manual `visual_root` rotation/offset overrides (`KNOCKED_DOWN`, `GETTING_UP`, `PINNING`, `PINNED`, `SUBMISSION_ATTACKER`, `SUBMISSION_DEFENDER`, `DEFEATED`) with `not is_rigged()`.
   - Guarded limb-node procedural punch and grapple tweens with `not is_rigged()`.
   - Unmigrated characters (Cyraxx, Nova, Candy, Andy, Jupiter, Anaconda, Larson) safely retain their provisional geometries and procedural fallbacks without crashes or regressions.

4. **Automated Presentation Testing**:
   - Created dedicated `tests/test_visual_presentation.gd` (28 tests) and integrated into main `tests/test_suite.gd` (404 tests total).
   - Verifies 22 bones in `Skeleton3D`, all 16 clips in `AnimationPlayer`, linear looping on `idle`/`walk`, state routing, stride scaling, and fallback compatibility.

---

### Preserved Combat Repairs (Pass A)
1. **Exclusive Terminal Outcome Ownership & Priority Scheduling**: `MatchManager` has exclusive authority; deterministic priorities (`Fighter` = 0, `MatchManager` = 10); symmetrical hold pointer clearing; immutable terminal states (`VICTORY`, `DEFEATED`).
2. **Pin-Balance Acceptance**: 4-mode empirical validation (CPU, 10 Hz Mash, Hold-on-Entry, Pre-Held); ordinary heavy impacts (1.5s heavy timer) separate from genuine finishers (4.5s disorientation); Count 3 preempted by kickout/rope break at tick 198 (3.30s).
3. **Boundary-Safe Paired Throws**: Pre-throw spatial trajectory validation and inward pair adjustment ($d_{\text{slam}} \le 3.50\text{m}$) preventing clipping through ring ropes ($|x| > 3.65\text{m}$).
4. **Directional Contact & Grapple Startup**: Forward contact cone ($\cos(60^\circ) = 0.50$, $120^\circ$ cone); measurable `GRAPPLE_STARTUP` window ($0.18\text{s}$ duration, $0.25\text{s}$ whiff recovery); strike interruption, reversal counter, and tactical CPU reaction.
5. **Simultaneous Submission Outcome Ordering & Centralized Hold Cleanup**: Authoritative simultaneous priority policy (`ESCAPE_BREAKS` vs `TAPOUT_WINS`) in `MatchManager`, 1.0 HP clutch survival on buzzer-beater breakouts, and symmetrical pointer clearing.

---

## Verification Summary
- **Unit & Presentation Test Suite (`tests/test_suite.gd`)**: 404 Passed, 0 Failed, 0 Warnings.
- **Scene Physics Integration Suite (`tests/test_pin_balance_scene.gd`)**: 126 Passed, 0 Failed.
- **Visual Presentation Dedicated Suite (`tests/test_visual_presentation.gd`)**: 28 Passed, 0 Failed.
- **Visual Inspection Status**: Headless automated checks PASS 100%; visual rendering and manual gameplay inspection marked **NOT RUN**.

```

## File: KNOWN_ISSUES.md

```markdown
## Active Open Issues & Visual Overhaul Pipeline

1. **Roster Skeletal Animation Migration (In Progress)**:
   - **Migrated (Production)**:
     - `tophiachu`: Complete 22-bone humanoid armature, customized heavyweight mesh, defined facial features, textured materials, and 16 keyframed skeletal animation clips exported to `assets/models/tophiachu.glb`.
   - **Pending Migration (Provisional Assets Preserved)**:
     - `cyraxx`: Next character queued for 22-bone humanoid rig, frail cruiserweight proportions, black beanie silhouette, and rapid strike clips.
     - `referee_cobra` (KingCobraJFS): Neutral referee queued for customized vest, iconic glasses, bowler hat, and permanent golden halo attached to head bone.
     - Remaining 6 fighters (`novaonline`, `candy_rooks`, `andy_ditch`, `jupiter_the_hybrid`, `anacondasin`, `daniel_larson`): Preserving current provisional assets and procedural fallback tweens until their production turns.
2. **Visual Checks & Authored Animations Status**:
   - Automated structural checks (bone count, animation presence, looping modes, state routing, speed scale clamping, fallback safety) are verified passing 100% in headless Godot.
   - Interactive visual rendering and manual gameplay playtests remain **NOT RUN** per headless review protocol.

---

## Resolved in Current Overhaul & Prior Milestones

1. **Skinned Mesh & Presentation Architecture (Resolved in Graphics Phase 1)**:
   - Created `FighterPresentation` (`scripts/fighter/fighter_presentation.gd`) to decouple visual asset management, skeletal rig detection, and animation playback from authoritative combat physics.
   - Guarded legacy procedural limb tweens and whole-model tilt/offset overrides in `scripts/fighter/fighter.gd` with `not is_rigged()`.
   - Enabled locomotion stride synchronization (`anim_player.speed_scale` dynamic scaling).
   - Authored Blender 5.0.1 generator pipeline (`blender/build_skinned_character.py`) exporting 22-bone armature and 16 NLA-backed action clips.
2. **Exclusive Terminal Outcome Ownership & Deterministic Scheduling (Resolved in Pass A Terminal Ownership)**:
   - Fixed competing ownership between `Fighter` and `MatchManager`: `MatchManager` has exclusive authority over terminal match outcome declarations (`_process_submission_watch()`, `_process_pin_countdown()`, `_resolve_pin_kick_out()`, `_resolve_submission_escape()`, `_resolve_submission_tap_out()`).
   - Assigned deterministic engine priorities: `Fighter.process_physics_priority = 0` and `MatchManager.process_physics_priority = 10`, ensuring fighters fully update resistance inputs, damage, and progress before `MatchManager` evaluates rules.
   - Symmetrically cleared `synchronized_partner = null` on both participants when entering terminal outcomes.
   - Guarded terminal states `VICTORY` and `DEFEATED` in `_set_state()` against being overwritten by gameplay callbacks (`GETTING_UP`, `IDLE`).
   - Guarded fighter callbacks (`_execute_submission_escape()`, `on_tap_out()`, `_execute_kick_out()`, `on_kick_out_received()`) against overwriting manager decisions.
   - Fully tested across slot inversions and tree processing orders with real scene physics frames (126 scene tests, 404 unit tests, 0 failures).
3. **Simultaneous Submission Outcome Ordering & Centralized Hold Cleanup (Resolved in Pass A Priority 4)**:
   - Established explicit simultaneous priority policy in `MatchManager` (`MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.ESCAPE_BREAKS`).
   - Decoupled terminal submission resolution from individual fighter update frames into `MatchManager` resolvers: `_resolve_submission_escape()` and `_resolve_submission_tap_out()`.
   - Guaranteed identical, deterministic outcomes across all 4 permutations of slot orders (P1/P2 vs P2/P1) and tree processing orders (Attacker-first vs Defender-first).
   - Enforced centralized, symmetrical hold cleanup: `synchronized_partner = null` cleared on both sides during all breakout, rope break, and tap-out transitions with zero dangling references.
4. **Directional Attack Contact & Grapple Startup (Resolved in Pass A Priority 3)**:
   - Added forward directional dot-product gating (`STRIKE_CONE_MIN_DOT = 0.50`, 120-degree cone) to `_handle_strike_active_window()`, preventing strikes from connecting with targets on flanks or behind the attacker.
   - Enforced measurable `GRAPPLE_STARTUP` window (`GRAPPLE_STARTUP_DURATION = 0.18s`, whiff recovery 0.25s) in `_attempt_grapple()` and `_process_grapple_startup()`.
   - Verified that unblocked incoming strikes interrupt attacker out of `GRAPPLE_STARTUP` and clear target reference, preventing throw execution.
   - Verified that defender reversal stance during startup successfully counters the attacker.
   - Upgraded `CPUController` to retaliate against opponent `GRAPPLE_STARTUP` via strike interruption or reversal counter.
5. **Boundary Safety During Throws (Resolved in Pass A Priority 2)**:
   - Added `_validate_and_adjust_throw_boundaries()` before locking synchronized throws. Evaluates predicted slam target $\vec{P}_{\text{slam}} = \vec{P}_{\text{atk}} + \vec{F} \times d_{\text{slam}}$ and shifts both attacker and defender inward toward center ring so landing coordinates and hold coordinates remain $\le 3.50\text{m}$ (inside the $3.65\text{m}$ ring limit).
   - Added secondary clamping in `_process_synchronized_attacker()` for `hold_pos` and `slam_pos`.
   - Verified across 32 edge, corner, slot, and tree permutations (128 assertions) with zero out-of-bounds trajectory and zero ground release snap-back.
6. **Pin-Balance Acceptance & Empirical Sequence Validation (Resolved in Pass A Pinfall Balance)**:
   - Replaced flat-rate escape formula with an authoritative resource-aware model factoring in quadratic vitality, remaining stamina, reversal stats, and explicit move-metadata impact disorientation.
   - Eliminated the bug where ordinary heavy throws ($\ge 100$ damage) inflicted finisher disorientation; ordinary heavy throws (177 dmg) now trigger a mild 1.5s heavy impact timer (0.85 mult) allowing healthy defenders to kick out swiftly, while genuine finishers inflict a 4.5s disorientation (0.55 mult).
   - Balanced hold-to-resist as an accessibility alternative at 85.0 base/sec with proportional 8.0/s stamina drain (~85% of 10 Hz mashing speed).
   - Resolved tick 198 (3.30s) floating point boundary precision (`+ 0.0005`) and made kickout ($\ge 100.0$) and rope break strictly preempt the 3-count pinfall across all slot inversions and tree processing orders.
   - Empirically validated across 56 real engine physics tests (`tests/test_pin_balance_scene.gd`) that fresh Cyraxx kicks out at Count 1 (~1.5s–1.6s) across all 4 modes (CPU, 10 Hz mash, hold-on-entry, pre-held), and weakened Cyraxx loses by 3-count pinfall across all 4 modes.
7. **CPU Pin & Submission Escape Command Disconnection (Resolved in Pass A Baseline)**:
   - Unified all escape checks to consume the `Fighter` command interface (`input_pin`, `input_hold_pin`, `input_strike`, `input_grapple`, `input_block`) rather than polling global hardware keys during combat physics.
8. **Conflicting Throw Height Ownership (Resolved in Pass A Baseline)**:
   - Removed canvas grounding conflicts in central ring throws so overhead powerslams reach full 1.55m vertical peak before canvas impact.
9. **Forward-Axis Facing Vector Standardization (Resolved in Pass A Baseline)**:
   - Standardized all locomotion, stationary facing, and synchronized throw vectors to Godot's `-basis.z` forward convention (`atan2(-dx, -dz)`).
10. **Canonical Finisher Names Alignment (Resolved in Pass A Baseline)**:
    - Synchronized `README.md` to canonical names in `scripts/core/roster_data.gd`.
11. **Desktop Launcher Script Trailing Quote Bug (Resolved in M3 Polish)**:
    - Fixed `%~dp0` trailing backslash CRT escaping issue in `START_GAME.bat`.

```

## File: NEXT_TASK.md

```markdown
# Next Implementation Tasks: Visual & Animation Overhaul (Phase 2 & 3)

## Current Status: Phase 1 Complete (Tophiachu Production Asset & Presentation Architecture)
Tophiachu has been overhauled with a production-grade 22-bone humanoid armature, customized anatomical mesh, and 16 keyframed skeletal animation clips exported to `assets/models/tophiachu.glb`. `FighterPresentation` coordinates model loading, skeletal detection, locomotion stride synchronization, and backward-compatible fallbacks for unmigrated fighters. All 530 automated tests (404 unit/presentation tests + 126 scene physics tests) pass 100%.

---

## Next Immediate Milestones: Phase 2 & Phase 3

### Phase 2: Cyraxx Production Asset & Rapid Striker Animation Set
1. **Model & Skeleton Generation**:
   - Extend `blender/build_skinned_character.py` (or create `build_skinned_cyraxx.py`) to build Cyraxx with the identical 22-bone humanoid armature hierarchy.
   - Proportions: Frail, lightweight cruiserweight frame, sunken cheeks, defined nasal bridge, black beanie silhouette, olive tank top, dark joggers, and wrestling boots.
   - Distinct PBR material assignments for skin, clothing, beanie, and footwear.
2. **Author Unique Animation Set (16 clips)**:
   - Dynamic, twitchy cruiserweight idle loop.
   - Rapid-tempo walking cycle.
   - Rapid double-jab / flurry strike clip.
   - Unique synchronized throw attacker/defender clips.
   - Getting up, knockdown, submission struggle, victory/defeat.
3. **Integration & Automated Verification**:
   - Export to `assets/models/cyraxx.glb`.
   - Update `tests/test_visual_presentation.gd` and `tests/test_suite.gd` to verify Cyraxx has `has_skeletal_rig == true` and 16 valid clips.
   - Run Tophiachu vs Cyraxx full match in `test_pin_balance_scene.gd` with both fighters rigged.

### Phase 3: KingCobraJFS Neutral Referee Rig & Permanent Memorial Halo
1. **Armature & Visual Model**:
   - Humanoid armature for KingCobraJFS with custom referee polo/vest, iconic glasses, and bowler hat.
   - Permanent, glowing golden memorial halo (1991–2025) securely parented to the `Head` bone with pulsing emissive shader/material.
2. **Referee Animation Set**:
   - Upright officiating idle with observational head glances.
   - Fast, decisive floor drop for pin counts (dropping to chest, hitting the mat for counts 1, 2, 3).
   - Standing wave-off animation for kick-outs and rope breaks.
   - Authoritative pointing gesture to designate match winner.
3. **Integration & Verification**:
   - Export to `assets/models/referee_cobra.glb`.
   - Verify referee remains neutral, untargetable, with halo visible throughout all match phases.

### Phase 4: Remaining 6 Fighters in Roster Pipeline
- `novaonline`: Athletic heavyweight frame, fiery red/gold attire, powerful striking stance.
- `candy_rooks`: Broad kitchen-sink powerhouse brute, pink apron aesthetic, wrist wraps.
- `andy_ditch`: Sturdy territory anchor, padded denim blue wrestling singlet.
- `jupiter_the_hybrid`: Slender celestial martial artist, violet/silver attire.
- `anacondasin`: Flexible submission technician, serpentine emerald/gold tights.
- `daniel_larson`: Erratic, lanky scrapper, bright orange jacket silhouette.

```

## File: GEMINI_GRAPHICS_ANIMATION_MASTER_PROMPT.md

```markdown
﻿# GEMINI GRAPHICS & ANIMATION MASTER PROMPT
Visual-Production Specification for LOLCOW WRESTLING: OFFLINE MAYHEM

## PRIMARY GOAL
Make the improvement obvious in normal full-body gameplay with bloom, particles, and camera shake disabled. Replace primitive mannequins with recognizable, properly skinned, textured wrestlers; replace whole-model rotations and offsets with articulated motion.

Keep the visual style consistent: stylized-realistic arcade wrestling in a small, professionally presented indoor venue. No blocky toy anatomy, featureless heads, identical bodybuilder meshes, rubber limbs, or photographic faces pasted onto spheres.

## PRESERVE THE PROJECT
Keep all eight wrestlers, their canonical IDs, stats, move names, controls, selection flow, and working combat repairs. KingCobraJFS remains the neutral, untargetable referee with a permanent halo.

Inspect installed Godot/Blender versions and existing repository instructions. Protect user changes. Do not change engines, reset the repository, or rewrite the game from scratch.

Preserve authoritative damage, pin/submission outcomes, input processing, and movement ownership. Animation and VFX must not decide who wins. Do not introduce a second gameplay controller.

## FIRST PRODUCTION PRIORITY: CHARACTERS AND MOTION
Start with Tophiachu, then Cyraxx, then the referee. Finish that contrasting heavyweight/lightweight pair before spreading unfinished art across the full roster. Preserve the remaining six as explicitly provisional but playable characters during migration.

Create real character meshes with intentional anatomical surfaces, proper facial structure, articulated hands, clothing thickness and folds, hair, UVs, and material separation. Use approved references for likeness. Do not invent verified anatomy or medical caricatures.

Author a consistent humanoid rig with separate floor root and pelvis, spine, neck/head, clavicles, arms/hands, legs/feet/toes, and appropriate finger controls. Adapt proportions and weights per physique rather than merely scaling one mesh. Validate shoulders, elbows, hips, knees, and clothing in extreme poses.

Keep editable source assets and a reproducible per-character export. Export skinned assets and baked animation tracks, then verify them in Godot. A skeleton existing in a file is not proof of correct motion. Use appropriately licensed base assets when useful; do not rip models or animations from commercial games or purchase assets without approval.

## REPLACE THE OLD ANIMATION SHORTCUTS
Build a dedicated presentation component driven by gameplay state. For migrated characters, remove or explicitly disable the legacy visual_root rotation/height overrides, limb-node punch tweens, and whole-model get-up lerps. Do not let them compete with skeletal poses.

Use authored clips with AnimationPlayer and a tested AnimationTree or equivalent blend graph. Keep mutable playback state per fighter, including mirror matches. Preserve one world-movement owner. Begin with locomotion matched to actual velocity; never apply animation root motion and controller displacement twice.

Author a usable match library: idle, travel/turn/stop, guard, strike, hit reactions, reversal, grapple entry, paired throw, knockdown, supported get-up, pin/struggle/kick-out, submission/escape/tap-out, finisher, entrance, and victory/defeat presentation.

Give Tophiachu planted weight shifts, torso involvement, and committed follow-through. Give Cyraxx compact attacks, quicker direction changes, and distinct leverage-based wrestling. Neither should skate or snap between unrelated poses.

A get-up must show support through elbow/hand, knee/foot, and rising hips. Rotating a horizontal model upright is not a finished get-up. A pin must show an actual cover; a submission must show a connected hold.

## PAIRED ANIMATION IS THE MAIN QUALITY GATE
Author attacker and defender together in shared space. Drive both from one action ID and authoritative timeline. Define grip acquisition, loading, lift/leverage, impact, release, and recovery phases.

Maintain hands on intended grip targets with bounded correction; do not stretch arms or teleport bodies to force contact. Keep planted feet stable. Match the visible landing, sound, and cosmetic response to the authoritative impact. Do not duplicate damage or effects.

Test heavyweight-to-lightweight, lightweight-to-heavyweight, both mirror matches, and edge/corner setups. A lightweight takedown needs its own leverage poses, not an overhead slam with a lower height.

Keep current balance initially. If a readable clip requires different move timing, make one explicit metadata change and test it; do not silently retime the combat or arbitrarily speed up the animation.

## REFEREE
Replace model bounces and pin-position teleporting with articulated observing, repositioning, kneeling, hand-to-canvas counting, rope-break, submission-check, get-up, and winner-acknowledgment animations.

The official count remains authoritative. Prepare the gesture so the hand contacts the canvas at the official count; referee travel must never delay or bias the result.

Use one halo attached above the animated head, visible with bloom off. Keep its gold emission restrained and its count pulse subtle. Do not wash out the face or duplicate halos from old scene/model assets.

## ARENA AND CAMERA
Finish one ring and venue: canvas texture/seams, padded turnbuckles, connected ropes, apron folds, steps, platform, barriers, seating, entrance curtain/ramp, visible truss lights, speakers, and timekeeper area. Keep gameplay canvas coordinates consistent.

Add varied, modest-cost crowd characters with staggered reactions. Avoid identical synchronized loops and full-detail rigs for every seat.

Light faces and feet clearly. Use distinct skin, fabric, metal, hair, and canvas materials. Evaluate baked indirect light plus dynamic character lighting/shadows. Add restrained atmosphere only after the assets look good under neutral light. No fog wall or excessive bloom.

Improve the broadcast camera to frame complete interactions, including lifted and downed fighters. Do not hide feet, hands, or reversal windows. Reserve cinematic angles for safe moments. Retain reduced-shake and stable-camera options. Menu polish is secondary to the match itself.

## DELIVERY ORDER AND PROOF
First session: inspect briefly, capture a genuine baseline when tools permit, establish the presentation seam, then finish a skinned, textured Tophiachu with idle, locomotion/stop, characteristic strike, knockdown, and supported get-up IN THE REAL MATCH SCENE. Continue to Cyraxx only after that pipeline works. Advance from existing finished work rather than rebuilding it.

Next gate: a complete two-wrestler match with connected grapples, ground interactions, animated referee, finished arena, and result. Only then migrate the remaining roster and extend unique sequences.

Capture real before/after views, full-body locomotion, both throw directions, pin/kick-out, submission, referee counting, and an uninterrupted match. Inspect normal and slow playback. Generated art, Blender-only turntables, and headless test logs are not gameplay proof.

Keep IMPLEMENTED, AUTOMATED CHECK PASSED, and VISUALLY ACCEPTED separate. Mark checks NOT RUN when tools are unavailable. Never invent footage, asset licenses, test outcomes, or frame rates. Profile 1080p/60 FPS on identified hardware; do not assume the user's GPU or memory capacity.

Report changed assets/code, exact launch commands or a playable build, checks actually run, captures actually inspected, remaining provisional work, and one next implementation task. Update the existing project notes accurately. Do not mark the entire overhaul complete after changing lighting or adding an unused skeleton.

Begin implementation, not another roadmap. The first deliverable must visibly improve a real wrestler in the real game.

```

## File: project.godot

```ini
; Engine configuration file.
; It's best edited using the editor UI and not directly,
; but it is safe to edit directly if you know what you are doing.

config_version=5

[application]

config/name="LOLCOW WRESTLING: OFFLINE MAYHEM"
config/description="Arcade 3D wrestling game featuring distinct fighters, synchronized throws, and KingCobraJFS as neutral referee."
run/main_scene="res://scenes/ui/character_select.tscn"
config/features=PackedStringArray("4.7", "Forward Plus")

[display]

window/size/viewport_width=1920
window/size/viewport_height=1080
window/size/window_width_override=1280
window/size/window_height_override=720
window/size/mode=0
window/size/resizable=true
window/stretch/mode="canvas_items"
window/stretch/aspect="keep"

[input]

p1_up={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":87,"physical_keycode":0,"key_label":0,"unicode":119,"echo":false,"script":null)
]
}
p1_down={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":83,"physical_keycode":0,"key_label":0,"unicode":115,"echo":false,"script":null)
]
}
p1_left={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":65,"physical_keycode":0,"key_label":0,"unicode":97,"echo":false,"script":null)
]
}
p1_right={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":68,"physical_keycode":0,"key_label":0,"unicode":100,"echo":false,"script":null)
]
}
p1_strike={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":74,"physical_keycode":0,"key_label":0,"unicode":106,"echo":false,"script":null)
]
}
p1_grapple={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":75,"physical_keycode":0,"key_label":0,"unicode":107,"echo":false,"script":null)
]
}
p1_block={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":76,"physical_keycode":0,"key_label":0,"unicode":108,"echo":false,"script":null)
]
}
p1_reversal={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":85,"physical_keycode":0,"key_label":0,"unicode":117,"echo":false,"script":null)
]
}
p1_pin={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":32,"physical_keycode":0,"key_label":0,"unicode":32,"echo":false,"script":null)
]
}
p1_finisher={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":73,"physical_keycode":0,"key_label":0,"unicode":105,"echo":false,"script":null)
]
}

p2_up={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194320,"physical_keycode":0,"key_label":0,"unicode":0,"echo":false,"script":null)
]
}
p2_down={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194322,"physical_keycode":0,"key_label":0,"unicode":0,"echo":false,"script":null)
]
}
p2_left={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194319,"physical_keycode":0,"key_label":0,"unicode":0,"echo":false,"script":null)
]
}
p2_right={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194321,"physical_keycode":0,"key_label":0,"unicode":0,"echo":false,"script":null)
]
}
p2_strike={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194433,"physical_keycode":0,"key_label":0,"unicode":49,"echo":false,"script":null)
]
}
p2_grapple={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194434,"physical_keycode":0,"key_label":0,"unicode":50,"echo":false,"script":null)
]
}
p2_block={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194435,"physical_keycode":0,"key_label":0,"unicode":51,"echo":false,"script":null)
]
}
p2_reversal={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194436,"physical_keycode":0,"key_label":0,"unicode":52,"echo":false,"script":null)
]
}
p2_pin={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194432,"physical_keycode":0,"key_label":0,"unicode":48,"echo":false,"script":null)
]
}
p2_finisher={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":4194437,"physical_keycode":0,"key_label":0,"unicode":53,"echo":false,"script":null)
]
}

toggle_cpu={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":67,"physical_keycode":0,"key_label":0,"unicode":99,"echo":false,"script":null)
]
}
match_restart={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":82,"physical_keycode":0,"key_label":0,"unicode":114,"echo":false,"script":null)
]
}

[physics]

common/physics_ticks_per_second=60

[rendering]

renderer/rendering_method="forward_plus"
anti_aliasing/quality/msaa_3d=2

```

## File: scripts/fighter/fighter_presentation.gd

```gdscript
class_name FighterPresentation
extends Node

## Presentation component for wrestling fighters.
## Manages 3D character instantiation, skeletal armature detection,
## animation blending, and visual locomotion synchronization.

var fighter: CharacterBody3D = null
var visual_root: Node3D = null
var anim_player: AnimationPlayer = null
var skeleton: Skeleton3D = null
var has_skeletal_rig: bool = false
var current_anim: String = ""

func setup(p_fighter: Fighter, p_visual_root: Node3D) -> void:
	fighter = p_fighter
	visual_root = p_visual_root

func load_model(character_id: String) -> void:
	if not visual_root:
		return
		
	for child in visual_root.get_children():
		child.queue_free()
		
	anim_player = null
	skeleton = null
	has_skeletal_rig = false
	current_anim = ""
	
	var model_path: String = "res://assets/models/" + character_id + ".glb"
	if ResourceLoader.exists(model_path):
		var model_res = load(model_path)
		if model_res is PackedScene:
			var inst: Node = model_res.instantiate()
			visual_root.add_child(inst)
			
			anim_player = inst.find_child("AnimationPlayer", true, false) as AnimationPlayer
			skeleton = inst.find_child("Skeleton3D", true, false) as Skeleton3D
			
			if is_instance_valid(skeleton) and is_instance_valid(anim_player):
				# Validate core animation set
				var anims: PackedStringArray = anim_player.get_animation_list()
				if anims.has("idle") and anims.has("walk") and anims.has("strike") and anims.has("knockdown") and anims.has("getup"):
					has_skeletal_rig = true
					_configure_animation_loops()
					
			if has_skeletal_rig:
				visual_root.rotation = Vector3.ZERO
				visual_root.position = Vector3.ZERO
				
			play_state_animation(fighter.current_state if fighter else Fighter.State.IDLE)

func _configure_animation_loops() -> void:
	if not is_instance_valid(anim_player):
		return
	for loop_anim in ["idle", "walk"]:
		if anim_player.has_animation(loop_anim):
			var a: Animation = anim_player.get_animation(loop_anim)
			a.loop_mode = Animation.LOOP_LINEAR

func play_state_animation(st: Fighter.State) -> void:
	if not is_instance_valid(anim_player):
		return
		
	var anim_name: String = ""
	match st:
		Fighter.State.IDLE: anim_name = "idle"
		Fighter.State.MOVING: anim_name = "walk"
		Fighter.State.STRIKING: anim_name = "strike"
		Fighter.State.BLOCKING: anim_name = "block"
		Fighter.State.REVERSAL_STANCE: anim_name = "reversal"
		Fighter.State.GRAPPLE_STARTUP: anim_name = "grapple"
		Fighter.State.GRAPPLING_ATTACKER: anim_name = "throw_attacker"
		Fighter.State.GRAPPLING_DEFENDER: anim_name = "throw_defender"
		Fighter.State.KNOCKED_DOWN: anim_name = "knockdown"
		Fighter.State.GETTING_UP: anim_name = "getup"
		Fighter.State.PINNING: anim_name = "pinning"
		Fighter.State.PINNED: anim_name = "pinned"
		Fighter.State.SUBMISSION_ATTACKER: anim_name = "submission_attacker"
		Fighter.State.SUBMISSION_DEFENDER: anim_name = "submission_defender"
		Fighter.State.VICTORY: anim_name = "victory"
		Fighter.State.DEFEATED: anim_name = "defeated"
		
	if anim_name != "" and anim_player.has_animation(anim_name):
		current_anim = anim_name
		# Blend smoothly into looping / locomotion states, instant-cut into impacts
		var blend_time: float = 0.12
		if st in [Fighter.State.KNOCKED_DOWN, Fighter.State.STRIKING]:
			blend_time = 0.05
		anim_player.play(anim_name, blend_time)

func update_locomotion_stride() -> void:
	if not has_skeletal_rig or not is_instance_valid(anim_player) or not is_instance_valid(fighter):
		return
		
	if fighter.current_state == Fighter.State.MOVING:
		var nominal_speed: float = 3.0 + (fighter.stat_mobility * 0.4)
		var actual_speed: float = fighter.velocity.length()
		if nominal_speed > 0.1:
			var stride_ratio: float = actual_speed / nominal_speed
			anim_player.speed_scale = clamp(stride_ratio, 0.4, 1.8)
		else:
			anim_player.speed_scale = 1.0
	else:
		anim_player.speed_scale = 1.0

```

## File: scripts/fighter/fighter.gd

```gdscript
class_name Fighter
extends CharacterBody3D

## Core Fighter controller for LOLCOW WRESTLING: OFFLINE MAYHEM.
## Enforces rigid state machine, single movement ownership, single-hit damage,
## and synchronized grapple/throw locking.

signal vitality_changed(current: float, maximum: float)
signal stamina_changed(current: float, maximum: float)
signal hype_changed(current: float, maximum: float)
signal state_changed(old_state: int, new_state: int)
signal hit_landed(attacker: Fighter, target: Fighter, damage: float, was_blocked: bool)
signal throw_impact(attacker: Fighter, defender: Fighter)
signal pin_initiated(pinner: Fighter, pinned: Fighter)
signal kick_out_succeeded(fighter: Fighter)
signal submission_initiated(attacker: Fighter, defender: Fighter)
signal submission_escaped(fighter: Fighter)
signal tap_out_submitted(fighter: Fighter)
signal character_loaded(fighter: Fighter)

enum State {
	IDLE,
	MOVING,
	STRIKING,
	BLOCKING,
	REVERSAL_STANCE,
	GRAPPLE_STARTUP,
	GRAPPLING_ATTACKER,
	GRAPPLING_DEFENDER,
	KNOCKED_DOWN,
	GETTING_UP,
	PINNING,
	PINNED,
	SUBMISSION_ATTACKER,
	SUBMISSION_DEFENDER,
	VICTORY,
	DEFEATED
}

@export var character_id: String = "tophiachu"
@export var player_index: int = 1 # 1 = P1, 2 = P2
@export var is_cpu: bool = false

# Visual nodes
@export var visual_root: Node3D
@export var left_arm: Node3D
@export var right_arm: Node3D
const FighterPresentationScript = preload("res://scripts/fighter/fighter_presentation.gd")
var anim_player: AnimationPlayer = null
var presentation = null

func is_rigged() -> bool:
	return presentation != null and presentation.has_skeletal_rig

# Internal attributes scaled from RosterData
var char_name: String = "Fighter"
var char_title: String = "Wrestler"
var max_vitality: float = 1000.0
var vitality: float = 1000.0
var max_stamina: float = 100.0
var stamina: float = 100.0
var hype: float = 0.0

# Stats (1-10)
var stat_power: int = 5
var stat_mobility: int = 5
var stat_grappling: int = 5
var stat_stamina: int = 5
var stat_durability: int = 5
var stat_reversal: int = 5
var stat_showmanship: int = 5
var reach_distance: float = 1.2

# State machine
var current_state: State = State.IDLE
var opponent: Fighter = null

# Attack & Grapple tracking
var current_attack_id: int = 0
var attack_has_damaged: bool = false
var state_timer: float = 0.0
var active_frame_start: float = 0.0
var active_frame_end: float = 0.0
var attack_total_time: float = 0.0

# Synchronized grapple parameters
var throw_duration: float = 1.0
var throw_impact_time: float = 0.55
var throw_has_impacted: bool = false
var synchronized_partner: Fighter = null
var initial_defender_local_pos: Vector3 = Vector3.ZERO

# Pin escape tracking
var pin_escape_progress: float = 0.0
var knockdown_duration: float = 2.5
var recent_finisher_impact_timer: float = 0.0
var recent_heavy_impact_timer: float = 0.0

# Input buffer
var input_dir: Vector2 = Vector2.ZERO
var input_strike: bool = false
var input_grapple: bool = false
var input_block: bool = false
var input_reversal: bool = false
var input_pin: bool = false
var input_finisher: bool = false
var input_hold_pin: bool = false
var prev_pin_held: bool = false

func _init() -> void:
	# Priority 0 ensures fighters update movement, mechanics, and input processing
	# before MatchManager (priority 10) resolves match rules and terminal outcomes.
	process_physics_priority = 0

func _ready() -> void:
	load_character_data()

func load_character_data(p_character_id: String = "") -> void:
	if p_character_id != "":
		character_id = p_character_id
	var data: Dictionary = RosterData.get_character(character_id)
	if data.is_empty():
		return
	
	char_name = data.get("name", "Fighter")
	char_title = data.get("title", "")
	var stats: Dictionary = data.get("stats", {})
	stat_power = stats.get("power", 5)
	stat_mobility = stats.get("mobility", 5)
	stat_grappling = stats.get("grappling", 5)
	stat_stamina = stats.get("stamina", 5)
	stat_durability = stats.get("durability", 5)
	stat_reversal = stats.get("reversal", 5)
	stat_showmanship = stats.get("showmanship", 5)
	
	var visual: Dictionary = data.get("visual", {})
	reach_distance = visual.get("reach", 1.2)
	
	# Compute derived stats
	max_vitality = 700.0 + (stat_durability * 50.0)
	vitality = max_vitality
	max_stamina = 60.0 + (stat_stamina * 8.0)
	stamina = max_stamina
	hype = 0.0
	
	vitality_changed.emit(vitality, max_vitality)
	stamina_changed.emit(stamina, max_stamina)
	hype_changed.emit(hype, MatchRules.MAX_HYPE)

	if visual_root:
		if presentation == null:
			presentation = FighterPresentationScript.new()
			presentation.name = "FighterPresentation"
			add_child(presentation)
			presentation.setup(self, visual_root)
		presentation.load_model(character_id)
		anim_player = presentation.anim_player
	
	character_loaded.emit(self)

func _physics_process(delta: float) -> void:
	if recent_finisher_impact_timer > 0.0:
		recent_finisher_impact_timer = max(0.0, recent_finisher_impact_timer - delta)
	if recent_heavy_impact_timer > 0.0:
		recent_heavy_impact_timer = max(0.0, recent_heavy_impact_timer - delta)
		
	if not is_cpu:
		_gather_player_inputs()
	
	_tick_stamina(delta)
	_update_state_machine(delta)
	if presentation:
		presentation.update_locomotion_stride()
	_clamp_within_ring()
	_clear_consumed_pulse_inputs()

func _gather_player_inputs() -> void:
	var prefix: String = "p" + str(player_index) + "_"
	
	var dir: Vector2 = Vector2.ZERO
	if Input.is_action_pressed(prefix + "up"):
		dir.y -= 1.0
	if Input.is_action_pressed(prefix + "down"):
		dir.y += 1.0
	if Input.is_action_pressed(prefix + "left"):
		dir.x -= 1.0
	if Input.is_action_pressed(prefix + "right"):
		dir.x += 1.0
	if dir != Vector2.ZERO or input_dir == Vector2.ZERO:
		input_dir = dir.normalized()
	
	if not input_strike:
		input_strike = Input.is_action_just_pressed(prefix + "strike")
	if not input_grapple:
		input_grapple = Input.is_action_just_pressed(prefix + "grapple")
	if not input_block:
		input_block = Input.is_action_pressed(prefix + "block")
	if not input_reversal:
		input_reversal = Input.is_action_just_pressed(prefix + "reversal")
	var pin_down: bool = Input.is_action_pressed(prefix + "pin")
	input_pin = input_pin or (pin_down and not prev_pin_held)
	input_hold_pin = input_hold_pin or (pin_down and prev_pin_held)
	prev_pin_held = pin_down
	if not input_finisher:
		input_finisher = Input.is_action_just_pressed(prefix + "finisher")

func _clear_consumed_pulse_inputs() -> void:
	input_strike = false
	input_grapple = false
	input_reversal = false
	input_pin = false
	input_finisher = false

func _tick_stamina(delta: float) -> void:
	if current_state == State.BLOCKING:
		stamina = max(0.0, stamina - MatchRules.BLOCK_STAMINA_DRAIN * delta)
		if stamina <= 0.0:
			_set_state(State.IDLE) # Guard break
		stamina_changed.emit(stamina, max_stamina)
	elif current_state in [State.IDLE, State.MOVING]:
		if stamina < max_stamina:
			stamina = min(max_stamina, stamina + MatchRules.STAMINA_REGEN_RATE * delta)
			stamina_changed.emit(stamina, max_stamina)

func _update_state_machine(delta: float) -> void:
	state_timer += delta
	
	match current_state:
		State.IDLE, State.MOVING:
			_handle_locomotion(delta)
			_check_standing_actions()
			
		State.STRIKING:
			velocity = Vector3.ZERO
			_handle_strike_active_window()
			if state_timer >= attack_total_time:
				_set_state(State.IDLE)
				
		State.BLOCKING:
			velocity = Vector3.ZERO
			if not input_block:
				_set_state(State.IDLE)
				
		State.REVERSAL_STANCE:
			velocity = Vector3.ZERO
			if state_timer >= 0.35: # Reversal window ends
				_set_state(State.IDLE)
				
		State.GRAPPLE_STARTUP:
			velocity = Vector3.ZERO
			_process_grapple_startup(delta)
				
		State.GRAPPLING_ATTACKER:
			velocity = Vector3.ZERO
			_process_synchronized_attacker()
			
		State.GRAPPLING_DEFENDER:
			velocity = Vector3.ZERO
			# Movement owned authoritatively by attacker
			
		State.KNOCKED_DOWN:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				visual_root.rotation.x = deg_to_rad(-90.0)
				visual_root.position.y = 0.15
			if state_timer >= knockdown_duration:
				_set_state(State.GETTING_UP)
				
		State.GETTING_UP:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				var t: float = clamp(state_timer / 0.6, 0.0, 1.0)
				visual_root.rotation.x = lerp(deg_to_rad(-90.0), 0.0, t)
				visual_root.position.y = lerp(0.15, 0.0, t)
			if state_timer >= 0.6:
				if visual_root:
					visual_root.rotation = Vector3.ZERO
					visual_root.position = Vector3.ZERO
				_set_state(State.IDLE)
				
		State.PINNING:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				visual_root.position.y = -0.3
				
		State.PINNED:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				visual_root.rotation.x = deg_to_rad(-90.0)
				visual_root.position.y = 0.1
			_process_pin_escape(delta)
			
		State.SUBMISSION_ATTACKER:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				visual_root.position.y = -0.25
			_process_submission_attacker(delta)
			
		State.SUBMISSION_DEFENDER:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				visual_root.rotation.x = deg_to_rad(-90.0)
				visual_root.position.y = 0.1
			_process_submission_defender(delta)
			
		State.VICTORY:
			velocity = Vector3.ZERO
			if visual_root:
				visual_root.rotation = Vector3.ZERO
				visual_root.position = Vector3.ZERO
				
		State.DEFEATED:
			velocity = Vector3.ZERO
			if visual_root and not is_rigged():
				visual_root.rotation.x = deg_to_rad(-90.0)
				visual_root.position.y = 0.1

func _handle_locomotion(delta: float) -> void:
	if input_dir.length_squared() > 0.01:
		var speed: float = 3.0 + (stat_mobility * 0.4)
		var move_v3: Vector3 = Vector3(input_dir.x, 0.0, input_dir.y) * speed
		velocity = move_v3
		if is_inside_tree():
			move_and_slide()
		
		# Rotate towards movement direction using standard Godot -Z forward convention
		var target_angle: float = atan2(-input_dir.x, -input_dir.y)
		rotation.y = lerp_angle(rotation.y, target_angle, 10.0 * delta)
		
		if current_state != State.MOVING:
			_set_state(State.MOVING)
	else:
		velocity = Vector3.ZERO
		if is_inside_tree():
			move_and_slide()
		if current_state != State.IDLE:
			_set_state(State.IDLE)
		
		# Face opponent when standing still using standard Godot -Z forward convention
		if is_instance_valid(opponent):
			var my_pos: Vector3 = global_position if is_inside_tree() else position
			var opp_pos: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
			var look_dir: Vector3 = Vector3(opp_pos.x - my_pos.x, 0.0, opp_pos.z - my_pos.z)
			if look_dir.length_squared() > 0.001:
				var look_norm: Vector3 = look_dir.normalized()
				var target_rot: float = atan2(-look_norm.x, -look_norm.z)
				rotation.y = lerp_angle(rotation.y, target_rot, 6.0 * delta)

func _check_standing_actions() -> void:
	if input_reversal and stamina >= MatchRules.REVERSAL_STAMINA_COST:
		stamina -= MatchRules.REVERSAL_STAMINA_COST
		stamina_changed.emit(stamina, max_stamina)
		_set_state(State.REVERSAL_STANCE)
		return
		
	if input_block and stamina > 10.0:
		_set_state(State.BLOCKING)
		return
		
	if input_strike and stamina >= MatchRules.STRIKE_STAMINA_COST:
		stamina -= MatchRules.STRIKE_STAMINA_COST
		stamina_changed.emit(stamina, max_stamina)
		_start_strike()
		return
		
	if input_finisher and is_instance_valid(opponent):
		if opponent.current_state == State.KNOCKED_DOWN and hype >= MatchRules.FINISHER_HYPE_COST:
			_attempt_submission(true)
			return
		elif opponent.current_state in [State.IDLE, State.MOVING] and hype >= MatchRules.FINISHER_HYPE_COST:
			_attempt_grapple(true)
			return

	if input_grapple:
		if is_instance_valid(opponent) and opponent.current_state == State.KNOCKED_DOWN:
			_attempt_submission(false)
			return
		elif stamina >= MatchRules.GRAPPLE_STAMINA_COST:
			stamina -= MatchRules.GRAPPLE_STAMINA_COST
			stamina_changed.emit(stamina, max_stamina)
			_attempt_grapple(false)
			return
		
	if input_pin:
		_attempt_pin()
		return

func _start_strike() -> void:
	current_attack_id += 1
	attack_has_damaged = false
	active_frame_start = 0.12
	active_frame_end = 0.32
	attack_total_time = 0.45
	_set_state(State.STRIKING)
	
	# Arm punch animation
	if right_arm and not is_rigged():
		var tween: Tween = create_tween()
		tween.tween_property(right_arm, "position:z", -0.8, 0.15)
		tween.tween_property(right_arm, "position:z", 0.0, 0.25)

func _handle_strike_active_window() -> void:
	if state_timer >= active_frame_start and state_timer <= active_frame_end and not attack_has_damaged:
		if is_instance_valid(opponent):
			var my_p: Vector3 = global_position if is_inside_tree() else position
			var opp_p: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
			var to_opp: Vector3 = Vector3(opp_p.x - my_p.x, 0.0, opp_p.z - my_p.z)
			var dist: float = to_opp.length()
			if dist <= reach_distance:
				# Directional forward cone validation (cos(60 deg) = 0.50 threshold)
				if dist > 0.001:
					var forward_dir: Vector3 = -global_transform.basis.z.normalized() if is_inside_tree() else -transform.basis.z.normalized()
					forward_dir.y = 0.0
					if forward_dir.is_zero_approx():
						forward_dir = Vector3(0, 0, -1)
					else:
						forward_dir = forward_dir.normalized()
						
					var to_opp_dir: Vector3 = to_opp.normalized()
					var dot: float = forward_dir.dot(to_opp_dir)
					if dot < MatchRules.STRIKE_CONE_MIN_DOT:
						# Target outside forward contact cone (flank or behind)
						return
				
				# Check defender state
				if opponent.current_state == State.REVERSAL_STANCE:
					# Countered!
					attack_has_damaged = true
					_apply_countered_by(opponent)
					return
				
				var is_blocked: bool = (opponent.current_state == State.BLOCKING)
				var base_dmg: float = 30.0 + (stat_power * 6.0)
				var final_dmg: float = base_dmg * (0.25 if is_blocked else 1.0)
				
				attack_has_damaged = true
				opponent.receive_damage(final_dmg, self, is_blocked)
				
				if not is_blocked:
					gain_hype(MatchRules.HYPE_GAIN_ON_HIT)
					hit_landed.emit(self, opponent, final_dmg, false)
					if AudioManager.instance:
						AudioManager.instance.play_strike(false)
				else:
					hit_landed.emit(self, opponent, final_dmg, true)
					if AudioManager.instance:
						AudioManager.instance.play_strike(true)

var is_finisher_attack: bool = false
var submission_tick_timer: float = 0.0
var grapple_target: Fighter = null

func _attempt_grapple(is_finisher: bool = false) -> void:
	if not is_instance_valid(opponent):
		grapple_target = null
		_set_state(State.GRAPPLE_STARTUP)
		return
		
	if is_finisher:
		is_finisher_attack = true
		hype = max(0.0, hype - MatchRules.FINISHER_HYPE_COST)
		hype_changed.emit(hype, MatchRules.MAX_HYPE)
		if AudioManager.instance:
			AudioManager.instance.play_finisher_stinger()
	else:
		is_finisher_attack = false
	
	var my_p: Vector3 = global_position if is_inside_tree() else position
	var opp_p: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
	
	# Turn to face opponent when initiating grapple
	var to_opp: Vector3 = Vector3(opp_p.x - my_p.x, 0.0, opp_p.z - my_p.z)
	if not to_opp.is_zero_approx():
		rotation.y = atan2(-to_opp.x, -to_opp.z)
		
	var dist: float = to_opp.length()
	if dist <= (reach_distance + 0.35) and opponent.current_state in [State.IDLE, State.MOVING, State.BLOCKING, State.REVERSAL_STANCE, State.GRAPPLE_STARTUP]:
		grapple_target = opponent
	else:
		grapple_target = null
	
	_set_state(State.GRAPPLE_STARTUP)
	
	# Procedural reaching visual feedback
	if left_arm and right_arm and not is_rigged():
		var tween: Tween = create_tween().set_parallel(true)
		tween.tween_property(left_arm, "position:z", -0.5, 0.12)
		tween.tween_property(right_arm, "position:z", -0.5, 0.12)

func _process_grapple_startup(_delta: float) -> void:
	if state_timer >= MatchRules.GRAPPLE_STARTUP_DURATION:
		if is_instance_valid(grapple_target):
			var my_p: Vector3 = global_position if is_inside_tree() else position
			var opp_p: Vector3 = grapple_target.global_position if grapple_target.is_inside_tree() else grapple_target.position
			var dist: float = my_p.distance_to(opp_p)
			
			if dist <= (reach_distance + 0.35):
				var target: Fighter = grapple_target
				grapple_target = null
				
				if left_arm and right_arm and not is_rigged():
					left_arm.position.z = 0.0
					right_arm.position.z = 0.0
				
				if target.current_state == State.REVERSAL_STANCE:
					# Defender counters the grapple!
					_apply_countered_by(target)
					return
				elif target.current_state in [State.IDLE, State.MOVING, State.BLOCKING, State.GRAPPLE_STARTUP]:
					# Successful grapple! (Grapple breaks guard)
					_start_synchronized_throw(target)
					return
		
		# Target moved away, was knocked down, or missed: wait for whiff recovery
		grapple_target = null
		if state_timer >= MatchRules.GRAPPLE_WHIFF_DURATION:
			if left_arm and right_arm and not is_rigged():
				left_arm.position.z = 0.0
				right_arm.position.z = 0.0
			_set_state(State.IDLE)

func _start_synchronized_throw(target: Fighter) -> void:
	synchronized_partner = target
	throw_has_impacted = false
	state_timer = 0.0
	throw_duration = 1.1
	throw_impact_time = 0.6
	
	# Priority 2: Pre-throw spatial and trajectory validation to prevent rope penetration
	var is_leverage: bool = (stat_power < target.stat_power or reach_distance < target.reach_distance)
	var slam_dist: float = 0.9 if is_leverage else 1.1
	_validate_and_adjust_throw_boundaries(target, slam_dist)
	
	_set_state(State.GRAPPLING_ATTACKER)
	target.on_locked_by_throw(self)
	
	# Face each other using standard Godot -Z forward convention
	var p1: Vector3 = global_position if is_inside_tree() else position
	var p2: Vector3 = target.global_position if target.is_inside_tree() else target.position
	var forward_dir: Vector3 = Vector3(p2.x - p1.x, 0.0, p2.z - p1.z).normalized()
	if not forward_dir.is_zero_approx():
		rotation.y = atan2(-forward_dir.x, -forward_dir.z)
		target.rotation.y = atan2(forward_dir.x, forward_dir.z)

func _validate_and_adjust_throw_boundaries(target: Fighter, slam_dist: float) -> void:
	var p1: Vector3 = global_position if is_inside_tree() else position
	var p2: Vector3 = target.global_position if target.is_inside_tree() else target.position
	
	var forward_dir: Vector3 = Vector3(p2.x - p1.x, 0.0, p2.z - p1.z).normalized()
	if forward_dir.is_zero_approx():
		forward_dir = -global_transform.basis.z.normalized() if is_inside_tree() else -transform.basis.z.normalized()
		
	var slam_pos: Vector3 = p1 + forward_dir * slam_dist
	var safe_bound: float = MatchRules.THROW_SAFE_RING_BOUND
	
	var shift_x: float = 0.0
	var shift_z: float = 0.0
	
	# Evaluate predicted slam position against safe boundary
	if slam_pos.x > safe_bound:
		shift_x = slam_pos.x - safe_bound
	elif slam_pos.x < -safe_bound:
		shift_x = slam_pos.x - (-safe_bound)
		
	if slam_pos.z > safe_bound:
		shift_z = slam_pos.z - safe_bound
	elif slam_pos.z < -safe_bound:
		shift_z = slam_pos.z - (-safe_bound)
		
	# Also ensure defender's position after shift remains within safe boundary
	var post_shift_p2_x: float = p2.x - shift_x
	var post_shift_p2_z: float = p2.z - shift_z
	if post_shift_p2_x > safe_bound:
		shift_x += (post_shift_p2_x - safe_bound)
	elif post_shift_p2_x < -safe_bound:
		shift_x += (post_shift_p2_x - (-safe_bound))
		
	if post_shift_p2_z > safe_bound:
		shift_z += (post_shift_p2_z - safe_bound)
	elif post_shift_p2_z < -safe_bound:
		shift_z += (post_shift_p2_z - (-safe_bound))
		
	# Apply spatial boundary adjustment to both participants equally
	if abs(shift_x) > 0.001 or abs(shift_z) > 0.001:
		var adjustment: Vector3 = Vector3(shift_x, 0.0, shift_z)
		if is_inside_tree():
			global_position -= adjustment
		else:
			position -= adjustment
			
		if target.is_inside_tree():
			target.global_position -= adjustment
		else:
			target.position -= adjustment

func on_locked_by_throw(attacker: Fighter) -> void:
	synchronized_partner = attacker
	_set_state(State.GRAPPLING_DEFENDER)

func _process_synchronized_attacker() -> void:
	if not is_instance_valid(synchronized_partner):
		_set_state(State.IDLE)
		return
	
	# Check if attacker should use leverage/trip instead of overhead lift
	var is_leverage: bool = (stat_power < synchronized_partner.stat_power or reach_distance < synchronized_partner.reach_distance)
	
	var forward: Vector3 = -global_transform.basis.z.normalized() if is_inside_tree() else -transform.basis.z.normalized()
	var my_pos: Vector3 = global_position if is_inside_tree() else position
	
	if state_timer < throw_impact_time:
		# Lift phase (leverage throws stay close to canvas)
		var lift_t: float = state_timer / throw_impact_time
		var peak_height: float = 0.38 if is_leverage else 1.55
		var lift_height: float = sin(lift_t * PI) * peak_height
		var hold_pos: Vector3 = my_pos + forward * (0.65 if is_leverage else 0.75) + Vector3(0.0, lift_height, 0.0)
		hold_pos.x = clamp(hold_pos.x, -MatchRules.THROW_SAFE_RING_BOUND, MatchRules.THROW_SAFE_RING_BOUND)
		hold_pos.z = clamp(hold_pos.z, -MatchRules.THROW_SAFE_RING_BOUND, MatchRules.THROW_SAFE_RING_BOUND)
		if synchronized_partner.is_inside_tree():
			synchronized_partner.global_position = hold_pos
		else:
			synchronized_partner.position = hold_pos
		
		# Tilt defender
		if synchronized_partner.visual_root:
			var tilt_angle: float = -45.0 if is_leverage else -80.0
			synchronized_partner.visual_root.rotation.x = deg_to_rad(tilt_angle * lift_t)
	else:
		# Post-impact phase
		if not throw_has_impacted:
			throw_has_impacted = true
			# Apply damage exactly once
			var throw_damage: float = 0.0
			if is_leverage:
				throw_damage = 50.0 + (stat_grappling * 10.0) + (stat_mobility * 4.0)
			else:
				throw_damage = 65.0 + (stat_power * 10.0) + (stat_grappling * 6.0)
			if is_finisher_attack:
				throw_damage *= 1.6
				
			synchronized_partner.receive_damage(throw_damage, self, false, is_finisher_attack)
			gain_hype(MatchRules.HYPE_GAIN_ON_HIT * 1.8)
			throw_impact.emit(self, synchronized_partner)
			
			if AudioManager.instance:
				AudioManager.instance.play_mat_slam(not is_leverage)
				if is_finisher_attack:
					AudioManager.instance.play_crowd_cheer()
			if BroadcastCamera.instance:
				BroadcastCamera.instance.add_trauma(0.35 if is_leverage else 0.55)
			
			# Slam position on canvas
			var slam_pos: Vector3 = my_pos + forward * (0.9 if is_leverage else 1.1)
			slam_pos.y = 0.0
			slam_pos.x = clamp(slam_pos.x, -MatchRules.THROW_SAFE_RING_BOUND, MatchRules.THROW_SAFE_RING_BOUND)
			slam_pos.z = clamp(slam_pos.z, -MatchRules.THROW_SAFE_RING_BOUND, MatchRules.THROW_SAFE_RING_BOUND)
			if synchronized_partner.is_inside_tree():
				synchronized_partner.global_position = slam_pos
			else:
				synchronized_partner.position = slam_pos
		
	if state_timer >= throw_duration:
		# Release mutual lock
		var partner: Fighter = synchronized_partner
		synchronized_partner = null
		_set_state(State.IDLE)
		if is_instance_valid(partner):
			if partner.is_inside_tree():
				partner.global_position.y = 0.0
			else:
				partner.position.y = 0.0
			partner.on_throw_released()

func on_throw_released() -> void:
	synchronized_partner = null
	if is_inside_tree():
		global_position.y = 0.0
	else:
		position.y = 0.0
	knockdown_duration = 3.0 + clamp((1.0 - (vitality / max_vitality)) * 2.0, 0.0, 2.5)
	_set_state(State.KNOCKED_DOWN)

# ==============================================================================
# Submissions System
# ==============================================================================

func _attempt_submission(is_finisher: bool = false) -> void:
	if not is_instance_valid(opponent):
		return
	if opponent.current_state != State.KNOCKED_DOWN:
		return
		
	var my_p: Vector3 = global_position if is_inside_tree() else position
	var opp_p: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
	var dist: float = my_p.distance_to(opp_p)
	if dist > 1.8:
		return
		
	if is_finisher:
		is_finisher_attack = true
		hype = max(0.0, hype - MatchRules.FINISHER_HYPE_COST)
		hype_changed.emit(hype, MatchRules.MAX_HYPE)
		if AudioManager.instance:
			AudioManager.instance.play_finisher_stinger()
	else:
		is_finisher_attack = false
		
	synchronized_partner = opponent
	submission_tick_timer = 0.0
	_set_state(State.SUBMISSION_ATTACKER)
	opponent.on_locked_by_submission(self)
	
	# Snap attacker near defender
	var lock_pos: Vector3 = opp_p + Vector3(0.0, 0.1, 0.25)
	if is_inside_tree():
		global_position = lock_pos
	else:
		position = lock_pos
		
	submission_initiated.emit(self, opponent)

func on_locked_by_submission(attacker: Fighter) -> void:
	synchronized_partner = attacker
	pin_escape_progress = 0.0
	_set_state(State.SUBMISSION_DEFENDER)

func _process_submission_attacker(delta: float) -> void:
	if not is_instance_valid(synchronized_partner):
		_set_state(State.IDLE)
		return
		
	submission_tick_timer += delta
	if submission_tick_timer >= 0.5:
		submission_tick_timer = 0.0
		var tick_dmg: float = 12.0 + (stat_grappling * 2.5)
		if is_finisher_attack:
			tick_dmg *= 1.5
		synchronized_partner.receive_damage(tick_dmg, self, false)
		gain_hype(MatchRules.HYPE_GAIN_ON_HIT * 0.3)
		
		# Defender stamina drain
		synchronized_partner.stamina = max(0.0, synchronized_partner.stamina - 15.0)
		synchronized_partner.stamina_changed.emit(synchronized_partner.stamina, synchronized_partner.max_stamina)
		
		# In active match, MatchManager._process_submission_watch() has exclusive authority.
		# For isolated standalone node tests without a MatchManager:
		if MatchManager.instance == null or MatchManager.instance.current_state != MatchManager.MatchState.SUBMISSION_ATTEMPT:
			if synchronized_partner.vitality <= 0.0:
				var defender: Fighter = synchronized_partner
				synchronized_partner = null
				_set_state(State.VICTORY)
				defender.on_tap_out()

func _process_submission_defender(delta: float) -> void:
	var escape_gain: float = 0.0
	
	# Any mash press (pin, strike, grapple) yields immediate burst escape gain
	if input_pin or input_strike or input_grapple:
		escape_gain += 15.0
	elif input_hold_pin or input_block:
		escape_gain += MatchRules.PIN_ESCAPE_BASE_RATE * delta
		
	var stamina_factor: float = 0.4 + 0.6 * (stamina / max_stamina)
	pin_escape_progress += escape_gain * stamina_factor
	
	# In active match, MatchManager._process_submission_watch() has exclusive authority.
	# For isolated standalone node tests without a MatchManager:
	if MatchManager.instance == null or MatchManager.instance.current_state != MatchManager.MatchState.SUBMISSION_ATTEMPT:
		if pin_escape_progress >= 100.0:
			_execute_submission_escape()

func _execute_submission_escape() -> void:
	if current_state in [State.DEFEATED, State.VICTORY]:
		return
	submission_escaped.emit(self)
	# Guard: If manager intervened during signal handling and finalized outcome, do NOT overwrite!
	if current_state in [State.DEFEATED, State.VICTORY, State.GETTING_UP, State.IDLE]:
		return
	if visual_root:
		visual_root.rotation = Vector3.ZERO
		visual_root.position = Vector3.ZERO
	_set_state(State.GETTING_UP)
	
	var partner: Fighter = synchronized_partner
	synchronized_partner = null
	
	if is_instance_valid(partner) and partner.current_state == State.SUBMISSION_ATTACKER:
		partner.on_submission_broken_by_escape()
	elif is_instance_valid(opponent) and opponent.current_state == State.SUBMISSION_ATTACKER:
		opponent.on_submission_broken_by_escape()

func on_submission_broken_by_escape() -> void:
	if current_state in [State.DEFEATED, State.VICTORY]:
		return
	if visual_root:
		visual_root.position = Vector3.ZERO
	# Push backward away from opponent
	var push_back: Vector3 = global_transform.basis.z.normalized() if is_inside_tree() else transform.basis.z.normalized()
	if is_inside_tree():
		global_position += push_back * 1.2
	else:
		position += push_back * 1.2
	_set_state(State.IDLE)
	synchronized_partner = null
	if AudioManager.instance:
		AudioManager.instance.play_crowd_gasp()

func on_tap_out() -> void:
	if current_state in [State.DEFEATED, State.VICTORY]:
		return
	tap_out_submitted.emit(self)
	# Guard: If manager intervened during signal handling (e.g. clutch escape), do NOT overwrite!
	if current_state in [State.GETTING_UP, State.IDLE, State.DEFEATED, State.VICTORY]:
		return
	if visual_root:
		visual_root.rotation.x = deg_to_rad(-90.0)
		visual_root.position.y = 0.1
	_set_state(State.DEFEATED)
	synchronized_partner = null
	if AudioManager.instance:
		AudioManager.instance.play_crowd_cheer()

func break_submission_rope_break() -> void:
	if current_state in [State.SUBMISSION_ATTACKER, State.SUBMISSION_DEFENDER]:
		if visual_root:
			visual_root.rotation = Vector3.ZERO
			visual_root.position = Vector3.ZERO
		_set_state(State.IDLE)
		synchronized_partner = null

func _apply_countered_by(counterer: Fighter) -> void:
	# Counterer gains hype
	counterer.gain_hype(MatchRules.HYPE_GAIN_ON_COUNTER)
	# Attacker stumbles and takes moderate counter damage
	receive_damage(35.0, counterer, false)
	_set_state(State.KNOCKED_DOWN)

func _attempt_pin() -> void:
	if not is_instance_valid(opponent):
		return
	if opponent.current_state == State.KNOCKED_DOWN:
		var my_p: Vector3 = global_position if is_inside_tree() else position
		var opp_p: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
		var dist: float = my_p.distance_to(opp_p)
		if dist <= 1.8:
			_start_pin(opponent)

func _start_pin(target: Fighter) -> void:
	_set_state(State.PINNING)
	target.on_pinned(self)
	# Snap attacker on top of defender
	var target_pos: Vector3 = target.global_position if target.is_inside_tree() else target.position
	if is_inside_tree():
		global_position = target_pos + Vector3(0.0, 0.2, 0.0)
	else:
		position = target_pos + Vector3(0.0, 0.2, 0.0)
	pin_initiated.emit(self, target)

func on_pinned(attacker: Fighter) -> void:
	pin_escape_progress = 0.0
	_set_state(State.PINNED)

func _process_pin_escape(delta: float) -> void:
	var has_mash_input: bool = (input_pin or input_strike or input_grapple)
	var has_hold_input: bool = input_hold_pin
	
	var vit_ratio: float = clamp(vitality / max_vitality, 0.0, 1.0)
	var stam_ratio: float = clamp(stamina / max_stamina, 0.0, 1.0)
	var rev_ratio: float = clamp(stat_reversal / 10.0, 0.1, 1.0)
	
	# Quadratic vitality weighting ensures high HP defenders kick out swiftly (<1.2s),
	# while exhausted/damaged defenders (<15% HP) suffer realistic 3-count pinfall defeats.
	var health_factor: float = 0.06 + 0.64 * (vit_ratio * vit_ratio) + 0.30 * stam_ratio
	var rev_mult: float = 0.85 + 0.30 * rev_ratio
	var finisher_mult: float = MatchRules.PIN_ESCAPE_FINISHER_PENALTY if recent_finisher_impact_timer > 0.0 else 1.0
	var heavy_mult: float = MatchRules.PIN_ESCAPE_HEAVY_IMPACT_PENALTY if recent_heavy_impact_timer > 0.0 else 1.0
	var total_mult: float = health_factor * rev_mult * finisher_mult * heavy_mult
	
	if has_mash_input:
		var mash_gain: float = MatchRules.PIN_ESCAPE_MASH_BASE * total_mult
		pin_escape_progress += mash_gain
		stamina = max(0.0, stamina - MatchRules.PIN_ESCAPE_MASH_STAMINA_COST)
		stamina_changed.emit(stamina, max_stamina)
	elif has_hold_input:
		var hold_gain: float = MatchRules.PIN_ESCAPE_BASE_RATE * total_mult * delta
		pin_escape_progress += hold_gain
		stamina = max(0.0, stamina - MatchRules.PIN_ESCAPE_HOLD_STAMINA_DRAIN * delta)
		stamina_changed.emit(stamina, max_stamina)
	else:
		# Passive decay when unresisted (simulates pin weight & pinning arm pressure)
		pin_escape_progress = max(0.0, pin_escape_progress - MatchRules.PIN_ESCAPE_DECAY_RATE * delta)
	
	# In active match, MatchManager._process_pin_countdown() has exclusive authority.
	# For isolated standalone node tests without a MatchManager:
	if MatchManager.instance == null or MatchManager.instance.current_state != MatchManager.MatchState.PIN_ATTEMPT:
		if pin_escape_progress >= 100.0:
			_execute_kick_out()

func _execute_kick_out() -> void:
	if current_state != State.PINNED:
		return
	kick_out_succeeded.emit(self)
	# Guard: If manager already finalized outcome, do NOT overwrite!
	if current_state in [State.DEFEATED, State.VICTORY, State.GETTING_UP, State.IDLE]:
		return
	if visual_root:
		visual_root.rotation = Vector3.ZERO
		visual_root.position = Vector3.ZERO
	_set_state(State.GETTING_UP)
	
	# Push pinning opponent away
	if is_instance_valid(opponent) and opponent.current_state == State.PINNING:
		opponent.on_kick_out_received()

func on_kick_out_received() -> void:
	if current_state in [State.DEFEATED, State.VICTORY]:
		return
	if visual_root:
		visual_root.position = Vector3.ZERO
	# Stumble backward away from opponent
	var push_back: Vector3 = global_transform.basis.z.normalized() if is_inside_tree() else transform.basis.z.normalized()
	if is_inside_tree():
		global_position += push_back * 1.2
	else:
		position += push_back * 1.2
	_set_state(State.IDLE)

func break_pin_rope_break() -> void:
	if current_state in [State.PINNING, State.PINNED]:
		if visual_root:
			visual_root.rotation = Vector3.ZERO
			visual_root.position = Vector3.ZERO
		_set_state(State.IDLE)

func receive_damage(amount: float, from_fighter: Fighter, was_blocked: bool, is_finisher: bool = false) -> void:
	vitality = max(0.0, vitality - amount)
	vitality_changed.emit(vitality, max_vitality)
	
	# Explicit impact classification: Finisher pressure is strictly gated by move metadata
	if is_finisher:
		recent_finisher_impact_timer = MatchRules.FINISHER_DISORIENTATION_DURATION
		recent_heavy_impact_timer = 0.0 # Finisher overrides heavy impact
	elif amount >= MatchRules.HEAVY_IMPACT_DAMAGE_THRESHOLD and not was_blocked:
		recent_heavy_impact_timer = MatchRules.HEAVY_IMPACT_DISORIENTATION_DURATION
	
	# Interrupt grapple startup if hit by unblocked damage
	if current_state == State.GRAPPLE_STARTUP and not was_blocked:
		grapple_target = null
		if left_arm and right_arm:
			left_arm.position.z = 0.0
			right_arm.position.z = 0.0
		_set_state(State.IDLE)
	
	# Knockdown on heavy damage or low health (NOT during active submissions or pins)
	if not was_blocked and vitality <= 0.0 and current_state not in [State.KNOCKED_DOWN, State.PINNED, State.SUBMISSION_DEFENDER, State.SUBMISSION_ATTACKER]:
		_set_state(State.KNOCKED_DOWN)

func gain_hype(amount: float) -> void:
	var bonus: float = 1.0 + (stat_showmanship * 0.08)
	hype = min(MatchRules.MAX_HYPE, hype + (amount * bonus))
	hype_changed.emit(hype, MatchRules.MAX_HYPE)

func _set_state(new_state: State) -> void:
	if current_state == new_state:
		return
	# Terminal match state guard: VICTORY and DEFEATED cannot be overwritten by active gameplay states
	if current_state in [State.VICTORY, State.DEFEATED] and new_state not in [State.VICTORY, State.DEFEATED]:
		return
	var old_state: State = current_state
	if old_state == State.GRAPPLE_STARTUP:
		grapple_target = null
		if left_arm and right_arm:
			left_arm.position.z = 0.0
			right_arm.position.z = 0.0
	current_state = new_state
	state_timer = 0.0
	_play_state_animation(new_state)
	state_changed.emit(old_state, new_state)

func _play_state_animation(st: State) -> void:
	if presentation:
		presentation.play_state_animation(st)
	elif is_instance_valid(anim_player):
		var anim_name: String = ""
		match st:
			State.IDLE: anim_name = "idle"
			State.MOVING: anim_name = "walk"
			State.STRIKING: anim_name = "strike"
			State.BLOCKING: anim_name = "block"
			State.REVERSAL_STANCE: anim_name = "reversal"
			State.GRAPPLE_STARTUP: anim_name = "grapple"
			State.GRAPPLING_ATTACKER: anim_name = "throw_attacker"
			State.GRAPPLING_DEFENDER: anim_name = "throw_defender"
			State.KNOCKED_DOWN: anim_name = "knockdown"
			State.GETTING_UP: anim_name = "getup"
			State.PINNING: anim_name = "pinning"
			State.PINNED: anim_name = "pinned"
			State.SUBMISSION_ATTACKER: anim_name = "submission_attacker"
			State.SUBMISSION_DEFENDER: anim_name = "submission_defender"
			State.VICTORY: anim_name = "victory"
			State.DEFEATED: anim_name = "defeated"
		if anim_name != "" and anim_player.has_animation(anim_name):
			anim_player.play(anim_name)

func _clamp_within_ring() -> void:
	# Single authoritative ownership: attacker solely controls defender's position during throws
	if current_state == State.GRAPPLING_DEFENDER:
		return
		
	var bound: float = MatchRules.RING_MAT_RADIUS - 0.35
	if is_inside_tree():
		global_position.x = clamp(global_position.x, -bound, bound)
		global_position.z = clamp(global_position.z, -bound, bound)
		global_position.y = 0.0
	else:
		position.x = clamp(position.x, -bound, bound)
		position.z = clamp(position.z, -bound, bound)
		position.y = 0.0

func set_victory() -> void:
	synchronized_partner = null
	_set_state(State.VICTORY)

func set_defeated() -> void:
	synchronized_partner = null
	_set_state(State.DEFEATED)

```

## File: scripts/ai/cpu_controller.gd

```gdscript
class_name CPUController
extends Node

## Tactical CPU wrestler controller.
## Drives standard Fighter input interface with realistic reaction intervals
## and profile-tailored tactical choices.

@export var fighter: Fighter
@export var reaction_interval: float = 0.22 # Reaction delay in seconds
@export var escape_mash_interval: float = 0.10 # Cadence for CPU escape mashing

var timer: float = 0.0
var escape_timer: float = 0.0
var think_state: String = "approach"

func _ready() -> void:
	if fighter:
		fighter.is_cpu = true

func _physics_process(delta: float) -> void:
	if not is_instance_valid(fighter):
		return
		
	# Active escape mashing during PINNED or SUBMISSION_DEFENDER
	if fighter.current_state in [Fighter.State.PINNED, Fighter.State.SUBMISSION_DEFENDER]:
		escape_timer += delta
		var vit_ratio: float = clamp(fighter.vitality / fighter.max_vitality, 0.0, 1.0)
		var stam_ratio: float = clamp(fighter.stamina / fighter.max_stamina, 0.0, 1.0)
		var fatigue: float = 1.0 - (0.6 * vit_ratio + 0.4 * stam_ratio)
		# Mashing cadence scales with reversal stat and physical fatigue (exhausted CPU struggles at ~6-7 Hz, fresh at 10 Hz)
		var effective_interval: float = (escape_mash_interval + 0.04 * fatigue) * (1.2 - (fighter.stat_reversal * 0.04))
		if escape_timer >= effective_interval:
			escape_timer = 0.0
			fighter.input_pin = true
			fighter.input_strike = true
		return
	else:
		escape_timer = 0.0
	
	if not is_instance_valid(fighter.opponent):
		return
	
	timer += delta
	if timer >= reaction_interval:
		timer = 0.0
		_think()

func _think() -> void:
	var opp: Fighter = fighter.opponent
	var opp_pos: Vector3 = opp.global_position if opp.is_inside_tree() else opp.position
	var my_pos: Vector3 = fighter.global_position if fighter.is_inside_tree() else fighter.position
	var dist: float = my_pos.distance_to(opp_pos)
	
	# Clear pulse inputs
	fighter.input_strike = false
	fighter.input_grapple = false
	fighter.input_block = false
	fighter.input_reversal = false
	fighter.input_pin = false
	
	# Check if opponent is downed -> attempt pin!
	if opp.current_state == Fighter.State.KNOCKED_DOWN:
		if dist <= 1.6:
			fighter.input_dir = Vector2.ZERO
			fighter.input_pin = true
		else:
			# Approach downed opponent
			var to_opp: Vector3 = (opp_pos - my_pos).normalized()
			fighter.input_dir = Vector2(to_opp.x, to_opp.z)
		return
		
	# Check if I am pinned or in submission -> escape mash!
	if fighter.current_state in [Fighter.State.PINNED, Fighter.State.SUBMISSION_DEFENDER]:
		fighter.input_pin = true
		fighter.input_strike = true
		return
		
	# Tactical in-ring spacing
	var to_opp_2d: Vector2 = Vector2(opp_pos.x - my_pos.x, opp_pos.z - my_pos.z)
	var dir_norm: Vector2 = to_opp_2d.normalized()
	
	# If opponent is striking and within range, test reversal or block
	if opp.current_state == Fighter.State.STRIKING and dist <= fighter.reach_distance + 0.2:
		var rev_chance: float = fighter.stat_reversal * 0.08
		if randf() < rev_chance and fighter.stamina >= MatchRules.REVERSAL_STAMINA_COST:
			fighter.input_reversal = true
			return
		elif randf() < 0.6:
			fighter.input_block = true
			return
			
	# If opponent is in grapple startup and within range, test reversal or strike interrupt
	if opp.current_state == Fighter.State.GRAPPLE_STARTUP and dist <= fighter.reach_distance + 0.2:
		var rev_chance: float = fighter.stat_reversal * 0.10
		if randf() < rev_chance and fighter.stamina >= MatchRules.REVERSAL_STAMINA_COST:
			fighter.input_reversal = true
			return
		elif randf() < 0.7 and fighter.stamina >= MatchRules.STRIKE_STAMINA_COST:
			fighter.input_strike = true
			return

	# Character specific behavior
	if dist <= fighter.reach_distance:
		fighter.input_dir = Vector2.ZERO
		
		# Rock-paper-scissors choices
		if opp.current_state == Fighter.State.BLOCKING:
			# Grapple breaks guard!
			fighter.input_grapple = true
		else:
			var grapple_pref: float = float(fighter.stat_grappling) / float(fighter.stat_grappling + fighter.stat_power)
			if randf() < grapple_pref and fighter.stamina >= MatchRules.GRAPPLE_STAMINA_COST:
				fighter.input_grapple = true
			elif fighter.stamina >= MatchRules.STRIKE_STAMINA_COST:
				fighter.input_strike = true
			else:
				fighter.input_block = true
	else:
		# Approach opponent
		fighter.input_dir = dir_norm

```

## File: scripts/core/match_rules.gd

```gdscript
class_name MatchRules
extends RefCounted

## Authoritative match configuration constants and geometric thresholds

const RING_MAT_RADIUS: float = 4.0 # Distance from center (0,0) to ropes in meters
const ROPE_BREAK_DISTANCE: float = 0.85 # Distance from rope threshold to trigger rope break
const THROW_SAFE_RING_BOUND: float = 3.50 # Safe inner ring boundary for synchronized throw arcs
const PIN_COUNT_INTERVAL: float = 1.1 # Seconds per referee count
const PIN_ESCAPE_BASE_RATE: float = 85.0 # Percent escape per second base (hold-to-resist accessibility)
const PIN_ESCAPE_MASH_BASE: float = 10.0 # Base progress gained per active mash pulse (at 10 Hz = 100.0/s)
const PIN_ESCAPE_DECAY_RATE: float = 8.0 # Passive escape progress decay per second when unresisted
const PIN_ESCAPE_HOLD_STAMINA_DRAIN: float = 8.0 # Stamina units drained per second while holding to resist
const PIN_ESCAPE_MASH_STAMINA_COST: float = 0.8 # Stamina units drained per active mash pulse (at 10 Hz = 8.0/s)
const PIN_ESCAPE_FINISHER_PENALTY: float = 0.55 # Multiplier on escape rate following a genuine finisher impact
const PIN_ESCAPE_HEAVY_IMPACT_PENALTY: float = 0.85 # Multiplier on escape rate following an ordinary heavy throw/slam
const FINISHER_DISORIENTATION_DURATION: float = 4.5 # Seconds of finisher impact disorientation
const HEAVY_IMPACT_DISORIENTATION_DURATION: float = 1.5 # Seconds of ordinary heavy impact disorientation
const HEAVY_IMPACT_DAMAGE_THRESHOLD: float = 80.0 # Damage threshold for ordinary heavy impact
const MAX_HYPE: float = 100.0
const HYPE_GAIN_ON_HIT: float = 12.0
const HYPE_GAIN_ON_COUNTER: float = 20.0
const STAMINA_REGEN_RATE: float = 12.0 # Units per second when not attacking or sprinting
const STRIKE_STAMINA_COST: float = 14.0
const GRAPPLE_STAMINA_COST: float = 22.0
const BLOCK_STAMINA_DRAIN: float = 15.0 # Per second held
const REVERSAL_STAMINA_COST: float = 18.0
const FINISHER_HYPE_COST: float = 100.0
const STRIKE_CONE_MIN_DOT: float = 0.50 # 120-degree forward contact cone (cos(60 deg))
const GRAPPLE_STARTUP_DURATION: float = 0.18 # Seconds of vulnerability before grapple lock executes
const GRAPPLE_WHIFF_DURATION: float = 0.25 # Seconds of recovery on missed/whiffed grapple

enum SubmissionPriority {
	ESCAPE_BREAKS, # Buzzer-beater breakout waives off tap-out
	TAPOUT_WINS     # Incapacitation takes precedence
}
static var SUBMISSION_SIMULTANEOUS_PRIORITY: int = SubmissionPriority.ESCAPE_BREAKS

static func is_near_ropes(position_3d: Vector3) -> bool:
	var x: float = abs(position_3d.x)
	var z: float = abs(position_3d.z)
	var max_coord: float = max(x, z)
	return max_coord >= (RING_MAT_RADIUS - ROPE_BREAK_DISTANCE)

```

## File: scripts/core/match_manager.gd

```gdscript
class_name MatchManager
extends Node

## Authoritative match state coordinator.
## Manages match progression, pin counting, submissions, rope breaks, and victory conditions.

signal match_started()
signal pin_started(pinner: Fighter, pinned: Fighter)
signal pin_count_ticked(count: int)
signal pin_broken(reason: String)
signal submission_started(attacker: Fighter, defender: Fighter)
signal submission_escaped()
signal rope_break_called()
signal match_ended(winner: Fighter, method: String)

enum MatchState {
	INTRO,
	IN_PROGRESS,
	PIN_ATTEMPT,
	SUBMISSION_ATTEMPT,
	MATCH_OVER
}

@export var fighter_1: Fighter
@export var fighter_2: Fighter
@export var referee: Referee
@export var hud: Node

var current_state: MatchState = MatchState.IN_PROGRESS
var current_pinner: Fighter = null
var current_pinned: Fighter = null
var pin_timer: float = 0.0
var current_count: int = 0

static var instance: MatchManager = null

func _init() -> void:
	instance = self
	# Priority 10 ensures MatchManager evaluates rules and terminal outcomes
	# AFTER all fighters (priority 0) have completed mechanics and input processing for the tick.
	process_physics_priority = 10

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if instance == self:
			instance = null

func _ready() -> void:
	_setup_match()

func _setup_match() -> void:
	if not is_instance_valid(fighter_1) or not is_instance_valid(fighter_2):
		return
	
	fighter_1.opponent = fighter_2
	fighter_2.opponent = fighter_1
	
	if referee:
		referee.setup_targets(fighter_1, fighter_2)
		
	# Connect fighter pin signals
	if not fighter_1.pin_initiated.is_connected(_on_fighter_pin_initiated):
		fighter_1.pin_initiated.connect(_on_fighter_pin_initiated)
	if not fighter_2.pin_initiated.is_connected(_on_fighter_pin_initiated):
		fighter_2.pin_initiated.connect(_on_fighter_pin_initiated)
		
	if not fighter_1.kick_out_succeeded.is_connected(_on_kick_out_succeeded):
		fighter_1.kick_out_succeeded.connect(_on_kick_out_succeeded)
	if not fighter_2.kick_out_succeeded.is_connected(_on_kick_out_succeeded):
		fighter_2.kick_out_succeeded.connect(_on_kick_out_succeeded)

	# Connect fighter submission signals
	if not fighter_1.submission_initiated.is_connected(_on_fighter_submission_initiated):
		fighter_1.submission_initiated.connect(_on_fighter_submission_initiated)
	if not fighter_2.submission_initiated.is_connected(_on_fighter_submission_initiated):
		fighter_2.submission_initiated.connect(_on_fighter_submission_initiated)
		
	if not fighter_1.submission_escaped.is_connected(_on_submission_escaped):
		fighter_1.submission_escaped.connect(_on_submission_escaped)
	if not fighter_2.submission_escaped.is_connected(_on_submission_escaped):
		fighter_2.submission_escaped.connect(_on_submission_escaped)
		
	if not fighter_1.tap_out_submitted.is_connected(_on_tap_out_submitted):
		fighter_1.tap_out_submitted.connect(_on_tap_out_submitted)
	if not fighter_2.tap_out_submitted.is_connected(_on_tap_out_submitted):
		fighter_2.tap_out_submitted.connect(_on_tap_out_submitted)

	if AudioManager.instance:
		AudioManager.instance.play_ring_bell()

	match_started.emit()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("match_restart"):
		restart_match()
		return
		
	if current_state == MatchState.PIN_ATTEMPT:
		_process_pin_countdown(delta)
	elif current_state == MatchState.SUBMISSION_ATTEMPT:
		_process_submission_watch(delta)

static func get_fighter_pos(f: Fighter) -> Vector3:
	if not is_instance_valid(f):
		return Vector3.ZERO
	if f.is_inside_tree() and f.get_parent() is Node3D:
		return f.global_position
	return f.position

# ==============================================================================
# Pin Management
# ==============================================================================

func _on_fighter_pin_initiated(pinner: Fighter, pinned: Fighter) -> void:
	if current_state != MatchState.IN_PROGRESS:
		return
		
	current_pinner = pinner
	current_pinned = pinned
	
	# Priority 1: Check Rope Break immediately on pin start
	var pin_pos: Vector3 = get_fighter_pos(pinned)
	var pnr_pos: Vector3 = get_fighter_pos(pinner)
	if MatchRules.is_near_ropes(pin_pos) or MatchRules.is_near_ropes(pnr_pos):
		_call_rope_break()
		return
		
	current_state = MatchState.PIN_ATTEMPT
	pin_timer = 0.0
	current_count = 0
	
	if referee:
		referee.on_pin_started(get_fighter_pos(pinned))
	
	pin_started.emit(pinner, pinned)

func _process_pin_countdown(delta: float) -> void:
	if not is_instance_valid(current_pinned) or not is_instance_valid(current_pinner):
		_abort_pin("INVALID_PARTICIPANTS")
		return
		
	# 1. Authoritative Rope Break (Highest Priority)
	if MatchRules.is_near_ropes(get_fighter_pos(current_pinned)) or MatchRules.is_near_ropes(get_fighter_pos(current_pinner)):
		_call_rope_break()
		return
		
	# 2. Authoritative Kick-Out Check (Checks updated defender resistance)
	if current_pinned.pin_escape_progress >= 100.0:
		_resolve_pin_kick_out(current_pinner, current_pinned)
		return
		
	pin_timer += delta
	
	var next_threshold: float = (current_count + 1) * MatchRules.PIN_COUNT_INTERVAL
	if (pin_timer + 0.0005) >= next_threshold:
		current_count += 1
		pin_count_ticked.emit(current_count)
		if referee:
			referee.on_pin_count(current_count)
		if AudioManager.instance:
			AudioManager.instance.play_referee_slap()
			AudioManager.instance.play_count_tone(current_count)
			
		if current_count >= 3:
			# Final-tick priority check: rope break or kickout strictly preempts 3-count pinfall
			if MatchRules.is_near_ropes(get_fighter_pos(current_pinned)) or MatchRules.is_near_ropes(get_fighter_pos(current_pinner)):
				_call_rope_break()
				return
			if is_instance_valid(current_pinned) and current_pinned.pin_escape_progress >= 100.0:
				_resolve_pin_kick_out(current_pinner, current_pinned)
				return
			_end_match(current_pinner, "PINFALL (3-COUNT)")

func _resolve_pin_kick_out(pinner: Fighter, pinned: Fighter) -> void:
	if current_state != MatchState.PIN_ATTEMPT:
		return
	current_state = MatchState.IN_PROGRESS
	
	pinned.synchronized_partner = null
	pinner.synchronized_partner = null
	
	if pinned.visual_root:
		pinned.visual_root.rotation = Vector3.ZERO
		pinned.visual_root.position = Vector3.ZERO
	if pinner.visual_root:
		pinner.visual_root.position = Vector3.ZERO
		
	pinner._set_state(Fighter.State.IDLE)
	pinned._set_state(Fighter.State.GETTING_UP)
	
	# Push pinning opponent away
	var push_back: Vector3 = pinner.global_transform.basis.z.normalized() if pinner.is_inside_tree() else pinner.transform.basis.z.normalized()
	if pinner.is_inside_tree():
		pinner.global_position += push_back * 1.2
	else:
		pinner.position += push_back * 1.2
		
	current_pinner = null
	current_pinned = null
	
	if referee:
		referee.on_pin_broken()
	if AudioManager.instance:
		AudioManager.instance.play_crowd_gasp()
		
	pin_broken.emit("KICKOUT")
	pinned.kick_out_succeeded.emit(pinned)

func _on_kick_out_succeeded(fighter: Fighter) -> void:
	if current_state == MatchState.PIN_ATTEMPT and fighter == current_pinned:
		_resolve_pin_kick_out(current_pinner, current_pinned)

func _abort_pin(reason: String) -> void:
	pin_broken.emit(reason)
	if referee:
		referee.on_pin_broken()
	current_pinner = null
	current_pinned = null
	current_state = MatchState.IN_PROGRESS

# ==============================================================================
# Submission Management
# ==============================================================================

func _on_fighter_submission_initiated(attacker: Fighter, defender: Fighter) -> void:
	if current_state != MatchState.IN_PROGRESS:
		return
		
	current_pinner = attacker
	current_pinned = defender
	
	# Check rope break
	if MatchRules.is_near_ropes(get_fighter_pos(defender)) or MatchRules.is_near_ropes(get_fighter_pos(attacker)):
		_call_rope_break()
		return
		
	current_state = MatchState.SUBMISSION_ATTEMPT
	if referee:
		referee.on_pin_started(get_fighter_pos(defender))
		
	submission_started.emit(attacker, defender)

func _process_submission_watch(_delta: float) -> void:
	if not is_instance_valid(current_pinned) or not is_instance_valid(current_pinner):
		_abort_pin("INVALID_PARTICIPANTS")
		return
		
	# 1. Authoritative Rope Break (Highest Priority)
	if MatchRules.is_near_ropes(get_fighter_pos(current_pinned)) or MatchRules.is_near_ropes(get_fighter_pos(current_pinner)):
		_call_rope_break()
		return
		
	var attacker: Fighter = current_pinner
	var defender: Fighter = current_pinned
	
	var has_escaped: bool = (defender.pin_escape_progress >= 100.0)
	var has_tapped: bool = (defender.vitality <= 0.0)
	
	if has_escaped and has_tapped:
		# Simultaneous Frame: Evaluate authoritative priority policy
		if MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY == MatchRules.SubmissionPriority.ESCAPE_BREAKS:
			_resolve_submission_escape(attacker, defender)
		else:
			_resolve_submission_tap_out(attacker, defender)
	elif has_escaped:
		_resolve_submission_escape(attacker, defender)
	elif has_tapped:
		_resolve_submission_tap_out(attacker, defender)

func _on_submission_escaped(fighter: Fighter = null) -> void:
	if current_state != MatchState.SUBMISSION_ATTEMPT:
		return
	var defender: Fighter = current_pinned if is_instance_valid(current_pinned) else fighter
	var attacker: Fighter = current_pinner if is_instance_valid(current_pinner) else (defender.opponent if is_instance_valid(defender) else null)
	
	if not is_instance_valid(defender) or not is_instance_valid(attacker):
		return
		
	# Check for simultaneous tap-out on same frame
	if defender.vitality <= 0.0 and MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY == MatchRules.SubmissionPriority.TAPOUT_WINS:
		_resolve_submission_tap_out(attacker, defender)
		return
		
	_resolve_submission_escape(attacker, defender)

func _on_tap_out_submitted(loser: Fighter) -> void:
	if current_state != MatchState.SUBMISSION_ATTEMPT:
		return
	var defender: Fighter = loser
	var attacker: Fighter = current_pinner if is_instance_valid(current_pinner) else (defender.opponent if is_instance_valid(defender) else null)
	
	if not is_instance_valid(defender) or not is_instance_valid(attacker):
		return
		
	# Check for simultaneous escape on same frame
	if defender.pin_escape_progress >= 100.0 and MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY == MatchRules.SubmissionPriority.ESCAPE_BREAKS:
		_resolve_submission_escape(attacker, defender)
		return
		
	_resolve_submission_tap_out(attacker, defender)

func _resolve_submission_escape(attacker: Fighter, defender: Fighter) -> void:
	if current_state != MatchState.SUBMISSION_ATTEMPT:
		return
	current_state = MatchState.IN_PROGRESS
	
	# Symmetrical cleanup of hold pointers
	attacker.synchronized_partner = null
	defender.synchronized_partner = null
	
	# If defender reached 0 HP but broke free via buzzer-beater escape, grant 1.0 HP clutch survival
	if defender.vitality <= 0.0:
		defender.vitality = 1.0
		defender.vitality_changed.emit(defender.vitality, defender.max_vitality)
		
	attacker._set_state(Fighter.State.IDLE)
	defender._set_state(Fighter.State.GETTING_UP)
	
	if defender.visual_root:
		defender.visual_root.rotation = Vector3.ZERO
		defender.visual_root.position = Vector3.ZERO
	if attacker.visual_root:
		attacker.visual_root.position = Vector3.ZERO
		
	# Symmetrical pushback
	var push_back: Vector3 = attacker.global_transform.basis.z.normalized() if attacker.is_inside_tree() else attacker.transform.basis.z.normalized()
	if attacker.is_inside_tree():
		attacker.global_position += push_back * 1.2
	else:
		attacker.position += push_back * 1.2
		
	current_pinner = null
	current_pinned = null
	
	if referee:
		referee.on_pin_broken()
	if AudioManager.instance:
		AudioManager.instance.play_crowd_gasp()
		
	submission_escaped.emit()

func _resolve_submission_tap_out(attacker: Fighter, defender: Fighter) -> void:
	if current_state != MatchState.SUBMISSION_ATTEMPT:
		return
		
	# Symmetrical cleanup of hold pointers
	attacker.synchronized_partner = null
	defender.synchronized_partner = null
	
	current_pinner = null
	current_pinned = null
	
	_end_match(attacker, "SUBMISSION (TAP OUT)")

# ==============================================================================
# General Match Control
# ==============================================================================

func _call_rope_break() -> void:
	rope_break_called.emit()
	if referee:
		referee.on_rope_break()
	if AudioManager.instance:
		AudioManager.instance.play_rope_break_alert()
		
	if is_instance_valid(current_pinner):
		current_pinner.synchronized_partner = null
		current_pinner.break_pin_rope_break()
		current_pinner.break_submission_rope_break()
	if is_instance_valid(current_pinned):
		current_pinned.synchronized_partner = null
		current_pinned.break_pin_rope_break()
		current_pinned.break_submission_rope_break()
		
	current_pinner = null
	current_pinned = null
	current_state = MatchState.IN_PROGRESS

func _end_match(winner: Fighter, method: String) -> void:
	if current_state == MatchState.MATCH_OVER:
		return
	current_state = MatchState.MATCH_OVER
	var loser: Fighter = fighter_2 if winner == fighter_1 else fighter_1
	
	winner.set_victory()
	loser.set_defeated()
	
	if referee:
		referee.on_match_won(winner.global_position)
	if AudioManager.instance:
		AudioManager.instance.play_ring_bell()
		AudioManager.instance.play_crowd_cheer()
		AudioManager.instance.play_victory_fanfare()
		
	match_ended.emit(winner, method)

func restart_match() -> void:
	get_tree().reload_current_scene()

```

## File: scripts/core/match_config.gd

```gdscript
class_name MatchConfig
extends RefCounted

## Global match configuration tracking selected fighters and CPU state.
## Persists match selections between Character Select and the Ring Arena.

static var p1_character_id: String = "tophiachu"
static var p2_character_id: String = "cyraxx"
static var p2_is_cpu: bool = true

static func set_match(p1_id: String, p2_id: String, cpu_p2: bool = true) -> void:
	p1_character_id = p1_id
	p2_character_id = p2_id
	p2_is_cpu = cpu_p2

static func reset_defaults() -> void:
	p1_character_id = "tophiachu"
	p2_character_id = "cyraxx"
	p2_is_cpu = true

```

## File: scripts/core/main_scene.gd

```gdscript
class_name MainScene
extends Node3D

## Main scene controller for match initialization and mode toggles.

@export var fighter_1: Fighter
@export var fighter_2: Fighter
@export var cpu_controller_p2: CPUController
@export var match_manager: MatchManager

func _ready() -> void:
	if fighter_1:
		fighter_1.character_id = MatchConfig.p1_character_id
		fighter_1.load_character_data()
	if fighter_2:
		fighter_2.character_id = MatchConfig.p2_character_id
		fighter_2.is_cpu = MatchConfig.p2_is_cpu
		fighter_2.load_character_data()
		
	if cpu_controller_p2 and fighter_2:
		cpu_controller_p2.set_physics_process(fighter_2.is_cpu)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_cpu"):
		if cpu_controller_p2 and fighter_2:
			fighter_2.is_cpu = not fighter_2.is_cpu
			MatchConfig.p2_is_cpu = fighter_2.is_cpu
			cpu_controller_p2.set_physics_process(fighter_2.is_cpu)
			print("CPU P2 Toggled: ", fighter_2.is_cpu)
			
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_ESCAPE:
			get_tree().change_scene_to_file("res://scenes/ui/character_select.tscn")

```

## File: scripts/core/roster_data.gd

```gdscript
class_name RosterData
extends RefCounted

## Fictional stats and profiles for LOLCOW WRESTLING: OFFLINE MAYHEM.
## All attributes and abilities are fictional game-design choices.

const CHARACTERS: Dictionary = {
	"tophiachu": {
		"id": "tophiachu",
		"name": "Tophiachu",
		"title": "Live & Unfiltered",
		"archetype": "Heavyweight Counter-Brawler",
		"stats": {
			"power": 8,
			"mobility": 3,
			"grappling": 7,
			"stamina": 5,
			"durability": 9,
			"reversal": 4,
			"showmanship": 6
		},
		"moves": {
			"strike": "Comment-Section Clothesline",
			"grapple": "Block-Button Backbreaker",
			"corner": "Going-Live Corner Splash",
			"finisher": "Live-Stream Shutdown",
			"trait": "Last Word"
		},
		"visual": {
			"primary_color": Color(0.45, 0.22, 0.58), # Purple
			"secondary_color": Color(0.12, 0.12, 0.14), # Dark Charcoal
			"height": 1.70,
			"body_scale": Vector3(1.35, 0.95, 1.30),
			"reach": 1.25
		}
	},
	"novaonline": {
		"id": "novaonline",
		"name": "NovaOnline",
		"title": "Main-Event Energy",
		"archetype": "Momentum Heavyweight",
		"stats": {
			"power": 9,
			"mobility": 4,
			"grappling": 6,
			"stamina": 4,
			"durability": 9,
			"reversal": 3,
			"showmanship": 7
		},
		"moves": {
			"strike": "Buffering Bodycheck",
			"ground": "Main-Character Elbow",
			"corner": "Offline Avalanche",
			"finisher": "Going Offline",
			"trait": "Momentum Feed"
		},
		"visual": {
			"primary_color": Color(0.85, 0.15, 0.15), # Red
			"secondary_color": Color(0.9, 0.8, 0.2), # Gold
			"height": 1.85,
			"body_scale": Vector3(1.25, 1.05, 1.15),
			"reach": 1.35
		}
	},
	"cyraxx": {
		"id": "cyraxx",
		"name": "Cyraxx",
		"title": "Feedback Frenzy",
		"archetype": "Lightweight Burst Striker",
		"stats": {
			"power": 4,
			"mobility": 9,
			"grappling": 5,
			"stamina": 6,
			"durability": 3,
			"reversal": 8,
			"showmanship": 7
		},
		"moves": {
			"strike": "Feedback Flurry",
			"grapple": "Mic-Drop DDT",
			"counter": "Encore Reversal",
			"finisher": "Raxx and Ruin",
			"trait": "Overdrive"
		},
		"visual": {
			"primary_color": Color(0.15, 0.55, 0.35), # Dark Olive Green
			"secondary_color": Color(0.2, 0.2, 0.2), # Black
			"height": 1.55,
			"body_scale": Vector3(0.78, 0.88, 0.78),
			"reach": 0.95
		}
	},
	"candy_rooks": {
		"id": "candy_rooks",
		"name": "Candy Rooks",
		"title": "Kitchen-Sink Brawler",
		"archetype": "Combination Grappler",
		"stats": {
			"power": 7,
			"mobility": 4,
			"grappling": 8,
			"stamina": 6,
			"durability": 8,
			"reversal": 5,
			"showmanship": 4
		},
		"moves": {
			"strike": "Kitchen-Sink Combo",
			"rush": "Ragoon Rush",
			"grapple": "Second-Helping Side Slam",
			"finisher": "Ribs & Kidney Beans",
			"trait": "Recipe Combo"
		},
		"visual": {
			"primary_color": Color(0.85, 0.45, 0.65), # Pink/Apron
			"secondary_color": Color(0.95, 0.95, 0.95), # White
			"height": 1.68,
			"body_scale": Vector3(1.22, 0.96, 1.20),
			"reach": 1.18
		}
	},
	"andy_ditch": {
		"id": "andy_ditch",
		"name": "Andy Ditch",
		"title": "Immovable Object",
		"archetype": "Territory Anchor Grappler",
		"stats": {
			"power": 8,
			"mobility": 2,
			"grappling": 9,
			"stamina": 5,
			"durability": 10,
			"reversal": 4,
			"showmanship": 4
		},
		"moves": {
			"counter": "Sit-Down Counter",
			"grapple": "Deadweight Takedown",
			"taunt": "Complaint Department",
			"finisher": "Case Closed",
			"trait": "Hold My Ground"
		},
		"visual": {
			"primary_color": Color(0.25, 0.35, 0.65), # Denim Blue
			"secondary_color": Color(0.6, 0.6, 0.6), # Grey
			"height": 1.72,
			"body_scale": Vector3(1.30, 0.92, 1.25),
			"reach": 1.15
		}
	},
	"jupiter_the_hybrid": {
		"id": "jupiter_the_hybrid",
		"name": "Jupiter the Hybrid",
		"title": "Double Feature",
		"archetype": "Stance-Shift Grappler",
		"stats": {
			"power": 6,
			"mobility": 7,
			"grappling": 7,
			"stamina": 5,
			"durability": 5,
			"reversal": 6,
			"showmanship": 6
		},
		"moves": {
			"stance": "Hybrid Shift",
			"strike": "Moonrise Lariat",
			"counter": "Midnight Counter",
			"finisher": "Eclipse Driver",
			"trait": "Best of Both"
		},
		"visual": {
			"primary_color": Color(0.2, 0.1, 0.35), # Deep Violet
			"secondary_color": Color(0.8, 0.8, 0.9), # Silver
			"height": 1.80,
			"body_scale": Vector3(1.05, 1.02, 1.02),
			"reach": 1.28
		}
	},
	"anacondasin": {
		"id": "anacondasin",
		"name": "AnacondaSin",
		"title": "The Counter-Coil",
		"archetype": "Positional Submission Specialist",
		"stats": {
			"power": 5,
			"mobility": 6,
			"grappling": 9,
			"stamina": 6,
			"durability": 5,
			"reversal": 7,
			"showmanship": 4
		},
		"moves": {
			"feint": "Question-Time Feint",
			"counter": "Coil Counter",
			"sweep": "Wraparound Sweep",
			"finisher": "Anaconda Lock",
			"trait": "Tightening Grip"
		},
		"visual": {
			"primary_color": Color(0.15, 0.45, 0.25), # Emerald Green
			"secondary_color": Color(0.85, 0.75, 0.3), # Gold
			"height": 1.65,
			"body_scale": Vector3(1.10, 0.98, 1.10),
			"reach": 1.20
		}
	},
	"daniel_larson": {
		"id": "daniel_larson",
		"name": "Daniel Larson",
		"title": "Roaring Thunder",
		"archetype": "Mobile Opportunist",
		"stats": {
			"power": 4,
			"mobility": 9,
			"grappling": 4,
			"stamina": 8,
			"durability": 3,
			"reversal": 7,
			"showmanship": 7
		},
		"moves": {
			"strike": "Roaring Thunder Knee",
			"aerial": "Stage-Dive Elbow",
			"escape": "Tour-Bus Escape",
			"finisher": "Final Encore",
			"trait": "Touring Legs"
		},
		"visual": {
			"primary_color": Color(0.85, 0.45, 0.1), # Bright Orange
			"secondary_color": Color(0.2, 0.2, 0.25), # Slate
			"height": 1.78,
			"body_scale": Vector3(0.82, 1.02, 0.80),
			"reach": 1.30
		}
	}
}

static func get_character(id: String) -> Dictionary:
	return CHARACTERS.get(id, {})

static func get_all_ids() -> Array:
	return CHARACTERS.keys()

```

## File: scripts/core/audio_manager.gd

```gdscript
class_name AudioManager
extends Node

## Audio synthesizer and manager for LOLCOW WRESTLING: OFFLINE MAYHEM.
## Generates and plays procedural 16-bit PCM audio streams for mat impacts,
## ring bell, referee slaps, strikes, ropes, crowd reactions, and announcer stingers.

static var instance: AudioManager

var sfx_players: Array[AudioStreamPlayer] = []
var crowd_player: AudioStreamPlayer
var fanfare_player: AudioStreamPlayer

# Pre-synthesized streams
var snd_bell: AudioStreamWAV
var snd_mat_slam: AudioStreamWAV
var snd_strike_clean: AudioStreamWAV
var snd_strike_blocked: AudioStreamWAV
var snd_ref_slap: AudioStreamWAV
var snd_rope: AudioStreamWAV
var snd_crowd_cheer: AudioStreamWAV
var snd_crowd_gasp: AudioStreamWAV
var snd_finisher_stinger: AudioStreamWAV
var snd_victory_fanfare: AudioStreamWAV
var snd_rope_break: AudioStreamWAV
var snd_counts: Array[AudioStreamWAV] = []

func _ready() -> void:
	if instance == null:
		instance = self
	_create_audio_streams()
	_setup_players()

func _setup_players() -> void:
	for i in range(10):
		var p: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(p)
		sfx_players.append(p)
		
	crowd_player = AudioStreamPlayer.new()
	add_child(crowd_player)

	fanfare_player = AudioStreamPlayer.new()
	add_child(fanfare_player)

func _play_sfx(stream: AudioStreamWAV, volume_db: float = 0.0, pitch_scale: float = 1.0) -> void:
	if not stream:
		return
	for p in sfx_players:
		if not p.playing:
			p.stream = stream
			p.volume_db = volume_db
			p.pitch_scale = pitch_scale
			p.play()
			return
	# Fallback to first player
	if not sfx_players.is_empty():
		sfx_players[0].stream = stream
		sfx_players[0].volume_db = volume_db
		sfx_players[0].pitch_scale = pitch_scale
		sfx_players[0].play()

func play_ring_bell() -> void:
	_play_sfx(snd_bell, 2.0, 1.0)

func play_mat_slam(is_heavy: bool = true) -> void:
	var pitch: float = randf_range(0.85, 1.05) if not is_heavy else randf_range(0.75, 0.9)
	var vol: float = 4.0 if is_heavy else 1.0
	_play_sfx(snd_mat_slam, vol, pitch)

func play_strike(is_blocked: bool = false) -> void:
	if is_blocked:
		_play_sfx(snd_strike_blocked, -2.0, randf_range(0.9, 1.1))
	else:
		_play_sfx(snd_strike_clean, 2.0, randf_range(0.95, 1.05))

func play_referee_slap() -> void:
	_play_sfx(snd_ref_slap, 3.0, randf_range(0.98, 1.02))

func play_rope_twang() -> void:
	_play_sfx(snd_rope, 0.0, randf_range(0.9, 1.1))

func play_crowd_cheer() -> void:
	if crowd_player:
		crowd_player.stream = snd_crowd_cheer
		crowd_player.volume_db = -4.0
		crowd_player.play()

func play_crowd_gasp() -> void:
	_play_sfx(snd_crowd_gasp, -1.0, 1.0)

func play_finisher_stinger() -> void:
	_play_sfx(snd_finisher_stinger, 4.0, 1.0)

func play_victory_fanfare() -> void:
	if fanfare_player:
		fanfare_player.stream = snd_victory_fanfare
		fanfare_player.volume_db = 2.0
		fanfare_player.play()

func play_rope_break_alert() -> void:
	_play_sfx(snd_rope_break, 1.0, 1.0)

func play_count_tone(count: int) -> void:
	if count >= 1 and count <= snd_counts.size():
		_play_sfx(snd_counts[count - 1], 3.0, 1.0)

# ==============================================================================
# Procedural Audio Synthesis (16-bit PCM Mono, 22050 Hz)
# ==============================================================================

func _create_audio_streams() -> void:
	snd_bell = _synthesize_bell()
	snd_mat_slam = _synthesize_mat_slam()
	snd_strike_clean = _synthesize_strike_clean()
	snd_strike_blocked = _synthesize_strike_blocked()
	snd_ref_slap = _synthesize_ref_slap()
	snd_rope = _synthesize_rope()
	snd_crowd_cheer = _synthesize_crowd(true)
	snd_crowd_gasp = _synthesize_crowd(false)
	snd_finisher_stinger = _synthesize_finisher_stinger()
	snd_victory_fanfare = _synthesize_victory_fanfare()
	snd_rope_break = _synthesize_rope_break()
	
	snd_counts.clear()
	for c in [1, 2, 3]:
		snd_counts.append(_synthesize_count_tone(c))

func _create_wav(samples: PackedByteArray, sample_rate: int = 22050) -> AudioStreamWAV:
	var wav: AudioStreamWAV = AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = sample_rate
	wav.stereo = false
	wav.data = samples
	return wav

func _synthesize_bell() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 1.4
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	var freqs: Array[float] = [880.0, 1760.0, 2640.0, 3520.0, 420.0]
	var weights: Array[float] = [0.45, 0.25, 0.15, 0.1, 0.2]
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = exp(-3.8 * t)
		var sample_val: float = 0.0
		for k in range(freqs.size()):
			sample_val += sin(TAU * freqs[k] * t) * weights[k]
		sample_val *= env * 0.95
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_mat_slam() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.75
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = exp(-6.5 * t)
		var freq: float = lerp(90.0, 35.0, clamp(t / 0.35, 0.0, 1.0))
		var sub: float = sin(TAU * freq * t) * 0.75
		var noise_env: float = exp(-35.0 * t)
		var noise: float = (randf() * 2.0 - 1.0) * noise_env * 0.45
		var sample_val: float = (sub + noise) * env * 0.98
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_strike_clean() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.28
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = exp(-18.0 * t)
		var snap_env: float = exp(-45.0 * t)
		var punch: float = sin(TAU * 160.0 * t) * 0.55
		var snap: float = (randf() * 2.0 - 1.0) * snap_env * 0.65
		var sample_val: float = (punch + snap) * env * 0.95
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_strike_blocked() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.22
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = exp(-16.0 * t)
		var punch: float = sin(TAU * 110.0 * t) * 0.7
		var int16: int = clampi(int(punch * env * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_ref_slap() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.35
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = exp(-14.0 * t)
		var slap_noise: float = (randf() * 2.0 - 1.0) * exp(-40.0 * t) * 0.7
		var low_thump: float = sin(TAU * 120.0 * t) * 0.45
		var sample_val: float = (slap_noise + low_thump) * env * 0.95
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_rope() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.45
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = exp(-8.0 * t)
		var twang: float = sin(TAU * 65.0 * t) * 0.6 + sin(TAU * 130.0 * t) * 0.3
		var int16: int = clampi(int(twang * env * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_crowd(is_cheer: bool) -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 2.0 if is_cheer else 1.0
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	var last_noise: float = 0.0
	for i in range(num_samples):
		var t: float = float(i) / rate
		var raw_noise: float = randf() * 2.0 - 1.0
		last_noise = lerp(last_noise, raw_noise, 0.12)
		var env: float = 1.0
		if is_cheer:
			if t < 0.4:
				env = t / 0.4
			else:
				env = exp(-1.2 * (t - 0.4))
		else:
			env = exp(-2.5 * t)
			
		var sample_val: float = last_noise * env * 0.8
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_finisher_stinger() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 1.1
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	# Power chord with rising pitch sweep and distortion
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = min(t / 0.15, 1.0) * exp(-2.2 * t)
		var f_base: float = lerp(110.0, 220.0, clamp(t / 0.5, 0.0, 1.0))
		var chord: float = sin(TAU * f_base * t) * 0.4 + sin(TAU * (f_base * 1.5) * t) * 0.35 + sin(TAU * (f_base * 2.0) * t) * 0.25
		# Soft overdrive clipping
		var driven: float = clamp(chord * 1.8, -1.0, 1.0)
		var sample_val: float = driven * env * 0.95
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_victory_fanfare() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 2.4
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	# Fanfare notes: C4 (261.6), E4 (329.6), G4 (392.0), C5 (523.2)
	var notes: Array[float] = [261.63, 329.63, 392.00, 523.25]
	var note_starts: Array[float] = [0.0, 0.35, 0.70, 1.05]
	var note_durs: Array[float] = [0.35, 0.35, 0.35, 1.35]
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var sample_val: float = 0.0
		for n in range(notes.size()):
			var n_start: float = note_starts[n]
			var n_dur: float = note_durs[n]
			if t >= n_start and t < (n_start + n_dur):
				var local_t: float = t - n_start
				var env: float = min(local_t / 0.04, 1.0) * exp(-2.0 * local_t)
				var tone: float = sin(TAU * notes[n] * local_t) * 0.5 + sin(TAU * (notes[n] * 2.0) * local_t) * 0.25 + sin(TAU * (notes[n] * 3.0) * local_t) * 0.12
				sample_val += tone * env
		sample_val = clamp(sample_val * 0.85, -1.0, 1.0)
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_rope_break() -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.5
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	# Dual-tone buzzer alert (220 Hz + 277 Hz)
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = min(t / 0.02, 1.0) * exp(-5.0 * t)
		var buzzer: float = (sin(TAU * 220.0 * t) + sin(TAU * 277.0 * t)) * 0.5
		# Square-ish grit
		var clipped: float = 0.7 if buzzer > 0.0 else -0.7
		var sample_val: float = clipped * env * 0.8
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

func _synthesize_count_tone(count: int) -> AudioStreamWAV:
	var rate: int = 22050
	var duration: float = 0.45
	var num_samples: int = int(rate * duration)
	var bytes: PackedByteArray = PackedByteArray()
	bytes.resize(num_samples * 2)
	
	# Distinct pitch per count (count 1: 300 Hz, count 2: 400 Hz, count 3: 520 Hz)
	var base_freq: float = 260.0 + (count * 90.0)
	
	for i in range(num_samples):
		var t: float = float(i) / rate
		var env: float = min(t / 0.015, 1.0) * exp(-7.5 * t)
		var tone: float = sin(TAU * base_freq * t) * 0.6 + sin(TAU * (base_freq * 2.0) * t) * 0.3
		var transient_noise: float = (randf() * 2.0 - 1.0) * exp(-40.0 * t) * 0.3
		var sample_val: float = (tone + transient_noise) * env * 0.95
		var int16: int = clampi(int(sample_val * 32767.0), -32768, 32767)
		bytes.encode_s16(i * 2, int16)
		
	return _create_wav(bytes, rate)

```

## File: scripts/ring/broadcast_camera.gd

```gdscript
class_name BroadcastCamera
extends Camera3D

## Elevated broadcast camera that tracks both wrestlers smoothly
## with accessibility options and dynamic impact trauma shake.

@export var target_1: Node3D
@export var target_2: Node3D
@export var base_elevation: float = 4.8
@export var base_distance: float = 9.0
@export var smooth_speed: float = 5.0
@export var enable_shake: bool = true # Accessibility toggle

static var instance: BroadcastCamera

var trauma: float = 0.0
var trauma_decay: float = 2.8
var shake_time: float = 0.0

func _ready() -> void:
	instance = self

func add_trauma(amount: float) -> void:
	if enable_shake:
		trauma = clamp(trauma + amount, 0.0, 1.0)

func _physics_process(delta: float) -> void:
	if not is_inside_tree():
		if trauma > 0.0:
			trauma = max(0.0, trauma - trauma_decay * delta)
		return
		
	if not is_instance_valid(target_1) or not is_instance_valid(target_2):
		return
		
	var pos1: Vector3 = target_1.global_position
	var pos2: Vector3 = target_2.global_position
	var midpoint: Vector3 = (pos1 + pos2) * 0.5
	var fighters_dist: float = pos1.distance_to(pos2)
	
	var desired_dist: float = clamp(base_distance + fighters_dist * 0.45, 8.5, 14.0)
	var desired_pos: Vector3 = Vector3(
		midpoint.x * 0.35,
		base_elevation + fighters_dist * 0.15,
		midpoint.z * 0.2 + desired_dist
	)
	
	# Trauma shake calculation
	if trauma > 0.0:
		trauma = max(0.0, trauma - trauma_decay * delta)
		shake_time += delta * 30.0
		var shake_intensity: float = trauma * trauma # Quadratic curve
		var offset_x: float = sin(shake_time * 1.3) * 0.28 * shake_intensity
		var offset_y: float = cos(shake_time * 1.7) * 0.22 * shake_intensity
		desired_pos += Vector3(offset_x, offset_y, 0.0)
		
	global_position = global_position.lerp(desired_pos, smooth_speed * delta)
	
	var look_target: Vector3 = Vector3(midpoint.x, 0.9, midpoint.z)
	look_at(look_target, Vector3.UP)

```

## File: scripts/ring/ring.gd

```gdscript
class_name WrestlingRing
extends Node3D

## 3D Wrestling Ring with canvas, 4 turnbuckle posts, and 3-tiered ropes.

@export var mat_size: float = 8.0
@export var rope_radius: float = 3.8

func _ready() -> void:
	pass

```

## File: scripts/referee/referee.gd

```gdscript
class_name Referee
extends Node3D

## Neutral referee KingCobraJFS (1991-2025).
## Untargetable, non-colliding official featuring a permanent visible glowing halo.
## The match rules govern the authoritative count; the referee communicates it.

signal count_pulse(count_number: int)

enum RefereeState {
	IDLE,
	OBSERVING,
	RUNNING_TO_PIN,
	COUNTING_PIN,
	SIGNAL_ROPE_BREAK,
	VICTORY
}

@export var halo_node: Node3D
@export var mesh_instance: Node3D
@export var count_label_3d: Label3D

var current_state: RefereeState = RefereeState.OBSERVING
var target_fighter_1: Node3D
var target_fighter_2: Node3D
var current_count: int = 0
var halo_base_scale: Vector3 = Vector3.ONE
var halo_pulse_timer: float = 0.0
var halo_material: StandardMaterial3D

func _ready() -> void:
	if halo_node:
		halo_base_scale = halo_node.scale
		# Find halo mesh material if present
		var halo_mesh: MeshInstance3D = halo_node.get_node_or_null("HaloMesh") as MeshInstance3D
		if halo_mesh and halo_mesh.material_override:
			halo_material = halo_mesh.material_override as StandardMaterial3D
	
	if count_label_3d:
		count_label_3d.visible = false

func _process(delta: float) -> void:
	_update_halo_visuals(delta)
	
	match current_state:
		RefereeState.OBSERVING:
			_observe_match(delta)
		RefereeState.RUNNING_TO_PIN:
			pass
		RefereeState.COUNTING_PIN:
			pass
		RefereeState.SIGNAL_ROPE_BREAK:
			pass
		RefereeState.VICTORY:
			pass

func setup_targets(f1: Node3D, f2: Node3D) -> void:
	target_fighter_1 = f1
	target_fighter_2 = f2

func _observe_match(delta: float) -> void:
	if not is_instance_valid(target_fighter_1) or not is_instance_valid(target_fighter_2):
		return
	
	# Position referee on side of the action, keeping ~2.5m distance
	var midpoint: Vector3 = (target_fighter_1.global_position + target_fighter_2.global_position) * 0.5
	var perp_dir: Vector3 = (target_fighter_2.global_position - target_fighter_1.global_position).cross(Vector3.UP).normalized()
	if perp_dir.is_zero_approx():
		perp_dir = Vector3.FORWARD
	
	var desired_pos: Vector3 = midpoint + perp_dir * 2.2
	# Clamp inside ring bounds
	desired_pos.x = clamp(desired_pos.x, -2.8, 2.8)
	desired_pos.z = clamp(desired_pos.z, -2.8, 2.8)
	desired_pos.y = 0.0 # Canvas height
	
	global_position = global_position.lerp(desired_pos, 3.0 * delta)
	
	# Look towards midpoint
	var look_target: Vector3 = Vector3(midpoint.x, global_position.y, midpoint.z)
	if not global_position.is_equal_approx(look_target):
		look_at(look_target, Vector3.UP)

func on_pin_started(pin_position: Vector3) -> void:
	current_state = RefereeState.COUNTING_PIN
	current_count = 0
	
	# Move near the pinned fighters
	var offset: Vector3 = Vector3(1.2, 0.0, 0.0)
	global_position = pin_position + offset
	global_position.x = clamp(global_position.x, -3.2, 3.2)
	global_position.z = clamp(global_position.z, -3.2, 3.2)
	global_position.y = 0.0
	
	look_at(Vector3(pin_position.x, global_position.y, pin_position.z), Vector3.UP)
	
	# Drop to mat pose
	if mesh_instance:
		mesh_instance.position.y = -0.35 # Kneeling down to canvas
	
	if count_label_3d:
		count_label_3d.text = ""
		count_label_3d.visible = true

func on_pin_count(count_num: int) -> void:
	current_count = count_num
	halo_pulse_timer = 0.4
	
	if count_label_3d:
		count_label_3d.text = str(count_num) + "!"
		count_label_3d.modulate = Color(1.0, 0.85, 0.2)
	
	# Canvas slap bounce animation
	if mesh_instance:
		var tween: Tween = create_tween()
		tween.tween_property(mesh_instance, "position:y", -0.45, 0.08)
		tween.tween_property(mesh_instance, "position:y", -0.35, 0.12)
	
	count_pulse.emit(count_num)

func on_rope_break() -> void:
	current_state = RefereeState.SIGNAL_ROPE_BREAK
	if count_label_3d:
		count_label_3d.text = "ROPE BREAK!"
		count_label_3d.modulate = Color(1.0, 0.2, 0.2)
	
	# Stand up and signal
	if mesh_instance:
		mesh_instance.position.y = 0.0
	
	var tween: Tween = create_tween()
	tween.tween_interval(1.2)
	tween.tween_callback(func():
		if count_label_3d:
			count_label_3d.visible = false
		current_state = RefereeState.OBSERVING
	)

func on_pin_broken() -> void:
	if current_state == RefereeState.COUNTING_PIN:
		current_state = RefereeState.OBSERVING
		if count_label_3d:
			count_label_3d.visible = false
		if mesh_instance:
			mesh_instance.position.y = 0.0

func on_match_won(winner_position: Vector3) -> void:
	current_state = RefereeState.VICTORY
	if count_label_3d:
		count_label_3d.text = "WINNER!"
		count_label_3d.modulate = Color(0.2, 1.0, 0.4)
		count_label_3d.visible = true
	if mesh_instance:
		mesh_instance.position.y = 0.0
	look_at(Vector3(winner_position.x, global_position.y, winner_position.z), Vector3.UP)

func _update_halo_visuals(delta: float) -> void:
	if not halo_node:
		return
	
	# Constant gentle rotation
	halo_node.rotate_y(1.5 * delta)
	
	if halo_pulse_timer > 0.0:
		halo_pulse_timer -= delta
		var pulse_strength: float = clamp(halo_pulse_timer / 0.4, 0.0, 1.0)
		halo_node.scale = halo_base_scale * (1.0 + 0.45 * pulse_strength)
		if halo_material:
			halo_material.emission_energy_multiplier = 3.0 + 4.0 * pulse_strength
	else:
		halo_node.scale = halo_base_scale
		if halo_material:
			halo_material.emission_energy_multiplier = 2.5

```

## File: scripts/ui/character_select.gd

```gdscript
class_name CharacterSelect
extends Control

## Character Select screen for LOLCOW WRESTLING: OFFLINE MAYHEM.
## Allows selecting any of the 8 roster characters for P1 and P2 (Human or CPU),
## displaying stats, archetypes, and movesets, before launching the match.

signal character_selected(p1_id: String, p2_id: String, p2_cpu: bool)

@export var grid_container: GridContainer
@export var p1_name_label: Label
@export var p1_title_label: Label
@export var p1_archetype_label: Label
@export var p1_stats_container: VBoxContainer
@export var p1_finisher_label: Label
@export var p1_trait_label: Label

@export var p2_name_label: Label
@export var p2_title_label: Label
@export var p2_archetype_label: Label
@export var p2_stats_container: VBoxContainer
@export var p2_finisher_label: Label
@export var p2_trait_label: Label

@export var cpu_toggle_button: Button
@export var start_match_button: Button

var character_ids: Array = []
var p1_index: int = 0
var p2_index: int = 2 # Default to Cyraxx
var p2_is_cpu: bool = true

var roster_buttons: Array[Button] = []

func _ready() -> void:
	character_ids = RosterData.get_all_ids()
	p2_is_cpu = MatchConfig.p2_is_cpu
	
	# Find current indices from MatchConfig if set
	var p1_found: int = character_ids.find(MatchConfig.p1_character_id)
	if p1_found != -1:
		p1_index = p1_found
	var p2_found: int = character_ids.find(MatchConfig.p2_character_id)
	if p2_found != -1:
		p2_index = p2_found
		
	_setup_grid()
	_update_p1_display()
	_update_p2_display()
	_update_grid_highlights()
	_update_cpu_button_text()
	
	if cpu_toggle_button and not cpu_toggle_button.pressed.is_connected(_on_cpu_toggle_pressed):
		cpu_toggle_button.pressed.connect(_on_cpu_toggle_pressed)
	if start_match_button and not start_match_button.pressed.is_connected(_start_match):
		start_match_button.pressed.connect(_start_match)

func _setup_grid() -> void:
	if not grid_container:
		return
		
	for child in grid_container.get_children():
		child.queue_free()
	roster_buttons.clear()
	
	for i in range(character_ids.size()):
		var id: String = character_ids[i]
		var data: Dictionary = RosterData.get_character(id)
		var btn: Button = Button.new()
		btn.text = data.get("name", id)
		btn.custom_minimum_size = Vector2(160, 60)
		btn.focus_mode = Control.FOCUS_ALL
		
		# Connect click
		var idx: int = i
		btn.pressed.connect(func(): _on_roster_button_clicked(idx))
		grid_container.add_child(btn)
		roster_buttons.append(btn)

func _on_roster_button_clicked(idx: int) -> void:
	# Clicking selects P1, right clicking or clicking when shift pressed selects P2
	if Input.is_key_pressed(KEY_SHIFT):
		p2_index = idx
		_update_p2_display()
	else:
		p1_index = idx
		_update_p1_display()
	_update_grid_highlights()

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
		
	var num_chars: int = character_ids.size()
	if num_chars == 0:
		return
		
	# P1 controls: A / D or W / S
	if event.keycode in [KEY_A, KEY_D, KEY_W, KEY_S]:
		if event.keycode == KEY_A:
			p1_index = (p1_index - 1 + num_chars) % num_chars
		elif event.keycode == KEY_D:
			p1_index = (p1_index + 1) % num_chars
		elif event.keycode == KEY_W:
			p1_index = (p1_index - 4 + num_chars) % num_chars
		elif event.keycode == KEY_S:
			p1_index = (p1_index + 4) % num_chars
		_update_p1_display()
		_update_grid_highlights()
		if AudioManager.instance:
			AudioManager.instance.play_rope_twang()
		
	# P2 controls: Left / Right or Up / Down
	elif event.keycode in [KEY_LEFT, KEY_RIGHT, KEY_UP, KEY_DOWN]:
		if event.keycode == KEY_LEFT:
			p2_index = (p2_index - 1 + num_chars) % num_chars
		elif event.keycode == KEY_RIGHT:
			p2_index = (p2_index + 1) % num_chars
		elif event.keycode == KEY_UP:
			p2_index = (p2_index - 4 + num_chars) % num_chars
		elif event.keycode == KEY_DOWN:
			p2_index = (p2_index + 4) % num_chars
		_update_p2_display()
		_update_grid_highlights()
		if AudioManager.instance:
			AudioManager.instance.play_rope_twang()
		
	# Toggle CPU: C
	elif event.keycode == KEY_C:
		_on_cpu_toggle_pressed()
		
	# Start match: Space or Enter
	elif event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
		_start_match()

func _on_cpu_toggle_pressed() -> void:
	p2_is_cpu = not p2_is_cpu
	MatchConfig.p2_is_cpu = p2_is_cpu
	if AudioManager.instance:
		AudioManager.instance.play_strike(true)
	_update_cpu_button_text()

func _update_cpu_button_text() -> void:
	if cpu_toggle_button:
		cpu_toggle_button.text = "P2 MODE: [CPU]" if p2_is_cpu else "P2 MODE: [HUMAN]"

func _update_grid_highlights() -> void:
	for i in range(roster_buttons.size()):
		var btn: Button = roster_buttons[i]
		var id: String = character_ids[i]
		var data: Dictionary = RosterData.get_character(id)
		var base_name: String = data.get("name", id)
		
		var tags: String = ""
		if i == p1_index and i == p2_index:
			tags = " [P1 & P2]"
			btn.modulate = Color(1.0, 0.9, 0.4)
		elif i == p1_index:
			tags = " [P1]"
			btn.modulate = Color(0.4, 0.8, 1.0)
		elif i == p2_index:
			tags = " [P2]"
			btn.modulate = Color(1.0, 0.4, 0.4)
		else:
			btn.modulate = Color(0.85, 0.85, 0.85)
			
		btn.text = base_name + tags

func _update_p1_display() -> void:
	if p1_index < 0 or p1_index >= character_ids.size():
		return
	var id: String = character_ids[p1_index]
	var data: Dictionary = RosterData.get_character(id)
	
	if p1_name_label:
		p1_name_label.text = data.get("name", id).to_upper()
	if p1_title_label:
		p1_title_label.text = '"' + data.get("title", "") + '"'
	if p1_archetype_label:
		p1_archetype_label.text = data.get("archetype", "")
		
	var moves: Dictionary = data.get("moves", {})
	if p1_finisher_label:
		p1_finisher_label.text = "FINISHER: " + moves.get("finisher", "N/A")
	if p1_trait_label:
		p1_trait_label.text = "TRAIT: " + moves.get("trait", "N/A")
		
	_render_stat_bars(p1_stats_container, data.get("stats", {}))

func _update_p2_display() -> void:
	if p2_index < 0 or p2_index >= character_ids.size():
		return
	var id: String = character_ids[p2_index]
	var data: Dictionary = RosterData.get_character(id)
	
	if p2_name_label:
		p2_name_label.text = data.get("name", id).to_upper()
	if p2_title_label:
		p2_title_label.text = '"' + data.get("title", "") + '"'
	if p2_archetype_label:
		p2_archetype_label.text = data.get("archetype", "")
		
	var moves: Dictionary = data.get("moves", {})
	if p2_finisher_label:
		p2_finisher_label.text = "FINISHER: " + moves.get("finisher", "N/A")
	if p2_trait_label:
		p2_trait_label.text = "TRAIT: " + moves.get("trait", "N/A")
		
	_render_stat_bars(p2_stats_container, data.get("stats", {}))

func _render_stat_bars(container: VBoxContainer, stats: Dictionary) -> void:
	if not container:
		return
	for child in container.get_children():
		child.queue_free()
		
	var stat_keys: Array = [
		["Power", "power"],
		["Mobility", "mobility"],
		["Grappling", "grappling"],
		["Stamina", "stamina"],
		["Durability", "durability"],
		["Reversal", "reversal"],
		["Showmanship", "showmanship"]
	]
	
	for pair in stat_keys:
		var stat_title: String = pair[0]
		var stat_key: String = pair[1]
		var val: int = stats.get(stat_key, 5)
		
		var row: HBoxContainer = HBoxContainer.new()
		var lbl: Label = Label.new()
		lbl.text = "%-12s %2d/10" % [stat_title, val]
		lbl.custom_minimum_size = Vector2(130, 20)
		row.add_child(lbl)
		
		var bar: ProgressBar = ProgressBar.new()
		bar.min_value = 0
		bar.max_value = 10
		bar.value = val
		bar.show_percentage = false
		bar.custom_minimum_size = Vector2(120, 16)
		bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		row.add_child(bar)
		
		container.add_child(row)

func _start_match() -> void:
	var p1_id: String = character_ids[p1_index]
	var p2_id: String = character_ids[p2_index]
	MatchConfig.set_match(p1_id, p2_id, p2_is_cpu)
	if AudioManager.instance:
		AudioManager.instance.play_ring_bell()
	character_selected.emit(p1_id, p2_id, p2_is_cpu)
	get_tree().change_scene_to_file("res://scenes/main.tscn")

```

## File: scripts/ui/match_hud.gd

```gdscript
class_name MatchHUD
extends Control

## Broadcast television style HUD for LOLCOW WRESTLING: OFFLINE MAYHEM.

@export var match_manager: MatchManager
@export var p1_name_label: Label
@export var p1_title_label: Label
@export var p1_vitality_bar: ProgressBar
@export var p1_stamina_bar: ProgressBar
@export var p1_hype_bar: ProgressBar
@export var p1_state_label: Label

@export var p2_name_label: Label
@export var p2_title_label: Label
@export var p2_vitality_bar: ProgressBar
@export var p2_stamina_bar: ProgressBar
@export var p2_hype_bar: ProgressBar
@export var p2_state_label: Label

@export var center_announcement: Label
@export var pin_escape_container: Control
@export var pin_escape_bar: ProgressBar
@export var victory_panel: Control
@export var victory_label: Label

var current_pinned_fighter: Fighter = null

func _ready() -> void:
	if victory_panel:
		victory_panel.visible = false
	if pin_escape_container:
		pin_escape_container.visible = false
	if center_announcement:
		center_announcement.visible = false
		
	if match_manager:
		match_manager.pin_started.connect(_on_pin_started)
		match_manager.pin_count_ticked.connect(_on_pin_count)
		match_manager.pin_broken.connect(_on_pin_broken)
		match_manager.submission_started.connect(_on_submission_started)
		match_manager.submission_escaped.connect(_on_submission_escaped)
		match_manager.rope_break_called.connect(_on_rope_break)
		match_manager.match_ended.connect(_on_match_ended)
		
		_bind_fighter(match_manager.fighter_1, 1)
		_bind_fighter(match_manager.fighter_2, 2)

func _process(_delta: float) -> void:
	if is_instance_valid(current_pinned_fighter) and pin_escape_container and pin_escape_container.visible:
		pin_escape_bar.value = current_pinned_fighter.pin_escape_progress

func _bind_fighter(f: Fighter, p_idx: int) -> void:
	if not is_instance_valid(f):
		return
		
	if p_idx == 1:
		if p1_name_label: p1_name_label.text = f.char_name.to_upper()
		if p1_title_label: p1_title_label.text = f.char_title
		if p1_vitality_bar:
			p1_vitality_bar.max_value = f.max_vitality
			p1_vitality_bar.value = f.vitality
		if p1_stamina_bar:
			p1_stamina_bar.max_value = f.max_stamina
			p1_stamina_bar.value = f.stamina
		if p1_hype_bar:
			p1_hype_bar.max_value = MatchRules.MAX_HYPE
			p1_hype_bar.value = f.hype
			
		f.vitality_changed.connect(func(cur, max_v):
			if p1_vitality_bar:
				p1_vitality_bar.max_value = max_v
				p1_vitality_bar.value = cur
		)
		f.stamina_changed.connect(func(cur, max_s):
			if p1_stamina_bar:
				p1_stamina_bar.max_value = max_s
				p1_stamina_bar.value = cur
		)
		f.hype_changed.connect(func(cur, max_h):
			if p1_hype_bar:
				p1_hype_bar.max_value = max_h
				p1_hype_bar.value = cur
		)
		f.character_loaded.connect(func(fighter: Fighter):
			if p1_name_label: p1_name_label.text = fighter.char_name.to_upper()
			if p1_title_label: p1_title_label.text = fighter.char_title
			if p1_vitality_bar:
				p1_vitality_bar.max_value = fighter.max_vitality
				p1_vitality_bar.value = fighter.vitality
			if p1_stamina_bar:
				p1_stamina_bar.max_value = fighter.max_stamina
				p1_stamina_bar.value = fighter.stamina
		)
		f.state_changed.connect(func(_old_s, new_s):
			if p1_state_label:
				p1_state_label.text = Fighter.State.keys()[new_s]
		)
	else:
		if p2_name_label: p2_name_label.text = f.char_name.to_upper()
		if p2_title_label: p2_title_label.text = f.char_title
		if p2_vitality_bar:
			p2_vitality_bar.max_value = f.max_vitality
			p2_vitality_bar.value = f.vitality
		if p2_stamina_bar:
			p2_stamina_bar.max_value = f.max_stamina
			p2_stamina_bar.value = f.stamina
		if p2_hype_bar:
			p2_hype_bar.max_value = MatchRules.MAX_HYPE
			p2_hype_bar.value = f.hype
			
		f.vitality_changed.connect(func(cur, max_v):
			if p2_vitality_bar:
				p2_vitality_bar.max_value = max_v
				p2_vitality_bar.value = cur
		)
		f.stamina_changed.connect(func(cur, max_s):
			if p2_stamina_bar:
				p2_stamina_bar.max_value = max_s
				p2_stamina_bar.value = cur
		)
		f.hype_changed.connect(func(cur, max_h):
			if p2_hype_bar:
				p2_hype_bar.max_value = max_h
				p2_hype_bar.value = cur
		)
		f.character_loaded.connect(func(fighter: Fighter):
			if p2_name_label: p2_name_label.text = fighter.char_name.to_upper()
			if p2_title_label: p2_title_label.text = fighter.char_title
			if p2_vitality_bar:
				p2_vitality_bar.max_value = fighter.max_vitality
				p2_vitality_bar.value = fighter.vitality
			if p2_stamina_bar:
				p2_stamina_bar.max_value = fighter.max_stamina
				p2_stamina_bar.value = fighter.stamina
		)
		f.state_changed.connect(func(_old_s, new_s):
			if p2_state_label:
				p2_state_label.text = Fighter.State.keys()[new_s]
		)

func _on_pin_started(_pinner: Fighter, pinned: Fighter) -> void:
	current_pinned_fighter = pinned
	if pin_escape_container:
		pin_escape_container.visible = true
	if center_announcement:
		center_announcement.text = "PIN ATTEMPT!"
		center_announcement.visible = true

func _on_pin_count(count: int) -> void:
	if center_announcement:
		center_announcement.text = "COUNT: " + str(count) + "!"
		center_announcement.visible = true

func _on_pin_broken(reason: String) -> void:
	current_pinned_fighter = null
	if pin_escape_container:
		pin_escape_container.visible = false
	if center_announcement:
		center_announcement.text = "KICK OUT!" if reason == "KICKOUT" else "PIN BROKEN"
		var tween: Tween = create_tween()
		tween.tween_interval(0.8)
		tween.tween_callback(func(): center_announcement.visible = false)

func _on_submission_started(_attacker: Fighter, defender: Fighter) -> void:
	current_pinned_fighter = defender
	if pin_escape_container:
		pin_escape_container.visible = true
	if center_announcement:
		center_announcement.text = "SUBMISSION HOLD!"
		center_announcement.visible = true

func _on_submission_escaped() -> void:
	current_pinned_fighter = null
	if pin_escape_container:
		pin_escape_container.visible = false
	if center_announcement:
		center_announcement.text = "ESCAPED!"
		var tween: Tween = create_tween()
		tween.tween_interval(0.8)
		tween.tween_callback(func(): center_announcement.visible = false)

func _on_rope_break() -> void:
	current_pinned_fighter = null
	if pin_escape_container:
		pin_escape_container.visible = false
	if center_announcement:
		center_announcement.text = "ROPE BREAK!"
		center_announcement.visible = true
		var tween: Tween = create_tween()
		tween.tween_interval(1.2)
		tween.tween_callback(func(): center_announcement.visible = false)

func _on_match_ended(winner: Fighter, method: String) -> void:
	current_pinned_fighter = null
	if pin_escape_container:
		pin_escape_container.visible = false
	if center_announcement:
		center_announcement.visible = false
	if victory_panel:
		victory_panel.visible = true
		if victory_label:
			victory_label.text = winner.char_name.to_upper() + " WINS!\n[" + method + "]\n\nPress [R] to Rematch | [ESC] Character Select"

```

## File: tests/test_visual_presentation.gd

```gdscript
extends SceneTree

## Dedicated Visual Presentation Test for LOLCOW WRESTLING
## Verifies skinned mesh loading, 22-bone humanoid armature, 16-clip animation library,
## state playback routing, stride scaling, and fallback safety for unmigrated characters.

var total_tests: int = 0
var passed_tests: int = 0
var failed_tests: int = 0

func _init() -> void:
	print("==================================================")
	print("RUNNING VISUAL PRESENTATION & SKELETAL RIG TESTS")
	print("==================================================")
	
	test_tophiachu_skeletal_rig_and_bones()
	test_tophiachu_animation_library()
	test_animation_timing_and_canonical_synchronization()
	test_ground_animation_mat_contact_height()
	test_state_driven_animation_routing()
	test_visual_root_legacy_override_disabled_for_rigged()
	test_locomotion_stride_scaling()
	test_unmigrated_roster_fallback_safety()
	
	print("==================================================")
	print("PRESENTATION TEST RESULTS: %d Passed, %d Failed, %d Total" % [passed_tests, failed_tests, total_tests])
	print("==================================================")
	
	if failed_tests > 0:
		quit(1)
	else:
		quit(0)

func assert_test(condition: bool, test_name: String) -> void:
	total_tests += 1
	if condition:
		passed_tests += 1
		print("[PASS] %s" % test_name)
	else:
		failed_tests += 1
		printerr("[FAIL] %s" % test_name)

func test_tophiachu_skeletal_rig_and_bones() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	assert_test(fighter_scene != null, "Tophiachu Rig: fighter.tscn loaded successfully")
	
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	assert_test(fighter.presentation != null, "Tophiachu Rig: FighterPresentation component instantiated")
	assert_test(fighter.presentation.has_skeletal_rig == true, "Tophiachu Rig: has_skeletal_rig is true")
	assert_test(fighter.is_rigged() == true, "Tophiachu Rig: fighter.is_rigged() reports true")
	assert_test(is_instance_valid(fighter.presentation.skeleton), "Tophiachu Rig: Skeleton3D node valid")
	assert_test(is_instance_valid(fighter.presentation.anim_player), "Tophiachu Rig: AnimationPlayer node valid")
	
	var skel: Skeleton3D = fighter.presentation.skeleton
	var expected_bones = [
		"Root", "Hips", "Spine", "Chest", "Neck", "Head",
		"Clavicle.L", "Clavicle.R", "UpperArm.L", "UpperArm.R",
		"Forearm.L", "Forearm.R", "Hand.L", "Hand.R",
		"Thigh.L", "Thigh.R", "Shin.L", "Shin.R",
		"Foot.L", "Foot.R", "Toe.L", "Toe.R"
	]
	
	var all_bones_found: bool = true
	for b_name in expected_bones:
		var b_idx = skel.find_bone(b_name)
		if b_idx == -1:
			all_bones_found = false
			printerr("Missing bone in skeleton: %s" % b_name)
	assert_test(all_bones_found, "Tophiachu Rig: All 22 canonical humanoid bones found in Skeleton3D")
	assert_test(skel.get_bone_count() >= 22, "Tophiachu Rig: Bone count is at least 22 (actual: %d)" % skel.get_bone_count())
	
	fighter.queue_free()

func test_tophiachu_animation_library() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	var ap: AnimationPlayer = fighter.presentation.anim_player
	var expected_clips = [
		"idle", "walk", "strike", "knockdown", "getup",
		"block", "reversal", "grapple", "throw_attacker", "throw_defender",
		"pinning", "pinned", "submission_attacker", "submission_defender",
		"victory", "defeated"
	]
	
	var all_clips_exist: bool = true
	for c_name in expected_clips:
		if not ap.has_animation(c_name):
			all_clips_exist = false
			printerr("Missing animation clip: %s" % c_name)
	assert_test(all_clips_exist, "Tophiachu Library: All 16 keyframed clips present in AnimationPlayer")
	
	# Verify looping behavior
	var idle_anim: Animation = ap.get_animation("idle")
	var walk_anim: Animation = ap.get_animation("walk")
	var strike_anim: Animation = ap.get_animation("strike")
	
	assert_test(idle_anim.loop_mode == Animation.LOOP_LINEAR, "Tophiachu Library: 'idle' loop_mode is LOOP_LINEAR")
	assert_test(walk_anim.loop_mode == Animation.LOOP_LINEAR, "Tophiachu Library: 'walk' loop_mode is LOOP_LINEAR")
	assert_test(strike_anim.loop_mode == Animation.LOOP_NONE, "Tophiachu Library: 'strike' loop_mode is LOOP_NONE")
	
	fighter.queue_free()

func test_animation_timing_and_canonical_synchronization() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	var ap: AnimationPlayer = fighter.presentation.anim_player
	
	# Strike matches attack_total_time = 0.45s
	var a_strike = ap.get_animation("strike")
	assert_test(abs(a_strike.length - 0.45) < 0.01, "Timing: 'strike' length is 0.45s (actual: %.3fs)" % a_strike.length)
	
	# Getup matches getup duration = 0.60s
	var a_getup = ap.get_animation("getup")
	assert_test(abs(a_getup.length - 0.60) < 0.01, "Timing: 'getup' length is 0.60s (actual: %.3fs)" % a_getup.length)
	
	# Grapple startup matches MatchRules.GRAPPLE_STARTUP_DURATION = 0.18s
	var a_grapple = ap.get_animation("grapple")
	assert_test(abs(a_grapple.length - 0.183) < 0.01, "Timing: 'grapple' length is ~0.183s (actual: %.3fs)" % a_grapple.length)
	
	# Throws match throw_duration = 1.0s
	var a_ta = ap.get_animation("throw_attacker")
	var a_td = ap.get_animation("throw_defender")
	assert_test(abs(a_ta.length - 1.0) < 0.01, "Timing: 'throw_attacker' length is 1.00s")
	assert_test(abs(a_td.length - 1.0) < 0.01, "Timing: 'throw_defender' length is 1.00s")
	
	fighter.queue_free()

func test_ground_animation_mat_contact_height() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	var ap: AnimationPlayer = fighter.presentation.anim_player
	var skel: Skeleton3D = fighter.presentation.skeleton
	var hips_idx = skel.find_bone("Hips")
	
	# In knockdown at t=1.0s, hips must be down near the canvas (Y <= 0.20m), NOT floating at 1.68m
	ap.play("knockdown")
	ap.seek(1.0, true)
	var kd_hips = skel.get_bone_pose_position(hips_idx)
	assert_test(kd_hips.y < 0.20, "Ground Height: Knockdown settled hips height is near canvas (actual Y: %.2fm, must be < 0.20m)" % kd_hips.y)
	
	# In getup at t=0.60s, hips must return to standing height (Y >= 0.80m)
	ap.play("getup")
	ap.seek(0.60, true)
	var gu_hips = skel.get_bone_pose_position(hips_idx)
	assert_test(gu_hips.y > 0.80, "Ground Height: Getup complete hips height is upright (actual Y: %.2fm, must be > 0.80m)" % gu_hips.y)
	
	fighter.queue_free()

func test_state_driven_animation_routing() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	var pres = fighter.presentation
	
	pres.play_state_animation(Fighter.State.IDLE)
	assert_test(pres.current_anim == "idle", "State Routing: IDLE plays 'idle'")
	
	pres.play_state_animation(Fighter.State.MOVING)
	assert_test(pres.current_anim == "walk", "State Routing: MOVING plays 'walk'")
	
	pres.play_state_animation(Fighter.State.STRIKING)
	assert_test(pres.current_anim == "strike", "State Routing: STRIKING plays 'strike'")
	
	pres.play_state_animation(Fighter.State.KNOCKED_DOWN)
	assert_test(pres.current_anim == "knockdown", "State Routing: KNOCKED_DOWN plays 'knockdown'")
	
	pres.play_state_animation(Fighter.State.GETTING_UP)
	assert_test(pres.current_anim == "getup", "State Routing: GETTING_UP plays 'getup'")
	
	pres.play_state_animation(Fighter.State.VICTORY)
	assert_test(pres.current_anim == "victory", "State Routing: VICTORY plays 'victory'")
	
	pres.play_state_animation(Fighter.State.DEFEATED)
	assert_test(pres.current_anim == "defeated", "State Routing: DEFEATED plays 'defeated'")
	
	fighter.queue_free()

func test_visual_root_legacy_override_disabled_for_rigged() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	# Transition fighter to KNOCKED_DOWN
	fighter.current_state = Fighter.State.KNOCKED_DOWN
	fighter._play_state_animation(Fighter.State.KNOCKED_DOWN)
	
	# visual_root rotation should NOT be tipped over (legacy mannequin did -PI/2)
	assert_test(fighter.visual_root.rotation.x == 0.0, "Legacy Guard: Rigged fighter visual_root.rotation.x remains 0 on KNOCKED_DOWN")
	assert_test(fighter.visual_root.position.y == 0.0, "Legacy Guard: Rigged fighter visual_root.position.y remains 0 on KNOCKED_DOWN")
	
	# Transition to DEFEATED
	fighter.current_state = Fighter.State.DEFEATED
	fighter._play_state_animation(Fighter.State.DEFEATED)
	assert_test(fighter.visual_root.rotation.x == 0.0, "Legacy Guard: Rigged fighter visual_root.rotation.x remains 0 on DEFEATED")
	
	fighter.queue_free()

func test_locomotion_stride_scaling() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	fighter.current_state = Fighter.State.MOVING
	# Set velocity to match nominal speed: 3.0 + (stat_mobility * 0.4)
	var nominal = 3.0 + (fighter.stat_mobility * 0.4)
	fighter.velocity = Vector3(nominal, 0, 0)
	fighter.presentation.update_locomotion_stride()
	
	assert_test(abs(fighter.presentation.anim_player.speed_scale - 1.0) < 0.05, "Stride Scaling: Speed scale is ~1.0 at nominal speed")
	
	# Faster sprint
	fighter.velocity = Vector3(nominal * 1.5, 0, 0)
	fighter.presentation.update_locomotion_stride()
	assert_test(abs(fighter.presentation.anim_player.speed_scale - 1.5) < 0.05, "Stride Scaling: Speed scale increases to ~1.5 when moving faster")
	
	# Stationary or IDLE
	fighter.current_state = Fighter.State.IDLE
	fighter.presentation.update_locomotion_stride()
	assert_test(fighter.presentation.anim_player.speed_scale == 1.0, "Stride Scaling: Speed scale resets to 1.0 in IDLE")
	
	fighter.queue_free()

func test_unmigrated_roster_fallback_safety() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	# Load an unmigrated character
	fighter.load_character_data("cyraxx")
	
	assert_test(fighter.presentation != null, "Fallback Safety: Presentation component exists for unmigrated fighter")
	assert_test(fighter.is_rigged() == false, "Fallback Safety: Unmigrated fighter is_rigged() is false")
	
	# Check that legacy state changes still set visual_root rotations without errors
	fighter.current_state = Fighter.State.KNOCKED_DOWN
	# Legacy code sets visual_root.rotation.x = -PI/2
	fighter.visual_root.rotation.x = -PI / 2.0
	assert_test(abs(fighter.visual_root.rotation.x - (-PI / 2.0)) < 0.01, "Fallback Safety: Legacy mannequin rotation applies cleanly to unmigrated fighter")
	
	fighter.queue_free()

```

## File: tests/test_suite.gd

```gdscript
extends SceneTree

## Automated Headless Test Suite for LOLCOW WRESTLING: OFFLINE MAYHEM.
## Verifies roster data, character models, state machines, movement locking,
## single-hit damage, synchronized throws, pin counts, submissions, audio synthesis,
## character select interface, and all 64 matchups.

var total_tests: int = 0
var passed_tests: int = 0
var failed_tests: int = 0

func _init() -> void:
	print("==================================================")
	print("RUNNING LOLCOW WRESTLING AUTOMATED TEST SUITE (M2/M3)")
	print("==================================================")
	
	test_roster_stats_and_points()
	test_character_models_exist_and_load()
	test_fighter_movement_lock()
	test_damage_occurs_only_once()
	test_synchronized_grapple_lock_and_release()
	test_leverage_throw_routing()
	test_pin_count_and_rope_break_priority()
	test_submission_and_tap_out()
	test_audio_and_trauma_shake()
	test_match_config_and_character_select()
	test_roster_pair_matrix_compatibility()
	test_pass_a_cpu_escape_mechanisms()
	test_pass_a_throw_height_and_ownership()
	test_pass_a_slot_inversions_and_facing_vectors()
	test_pass_a_resource_aware_pinfall_balance()
	test_explicit_impact_classification()
	test_pass_a_boundary_safe_paired_throws()
	test_pass_a_strike_directional_cone()
	test_pass_a_grapple_startup_and_interruption()
	test_pass_a_simultaneous_submission_ordering()
	test_pass_a_callback_state_overwrite_resilience()
	test_pass_a_final_count_escape_crossing()
	test_visual_presentation_and_skeletal_rig()
	
	print("==================================================")
	print("TEST RESULTS: %d Passed, %d Failed, %d Total" % [passed_tests, failed_tests, total_tests])
	print("==================================================")
	
	quit(1 if failed_tests > 0 else 0)

func assert_true(condition: bool, test_name: String) -> void:
	total_tests += 1
	if condition:
		passed_tests += 1
		print("[PASS] " + test_name)
	else:
		failed_tests += 1
		printerr("[FAIL] " + test_name)

func test_roster_stats_and_points() -> void:
	var ids: Array = RosterData.get_all_ids()
	assert_true(ids.size() == 8, "Roster contains all 8 required characters")
	
	for id in ids:
		var char_data: Dictionary = RosterData.get_character(id)
		var stats: Dictionary = char_data.get("stats", {})
		var sum_points: int = 0
		var within_range: bool = true
		for stat_name in ["power", "mobility", "grappling", "stamina", "durability", "reversal", "showmanship"]:
			var val: int = stats.get(stat_name, 0)
			sum_points += val
			if val < 1 or val > 10:
				within_range = false
		
		assert_true(sum_points == 42, "Character '%s' has exact 42-point allocation (Got %d)" % [id, sum_points])
		assert_true(within_range, "Character '%s' stats all in 1-10 range" % id)
		
		var moves: Dictionary = char_data.get("moves", {})
		assert_true(moves.has("finisher"), "Character '%s' defines a finisher" % id)
		assert_true(moves.has("trait"), "Character '%s' defines a personality trait" % id)

func test_character_models_exist_and_load() -> void:
	var ids: Array = RosterData.get_all_ids()
	for id in ids:
		var path: String = "res://assets/models/" + id + ".glb"
		assert_true(ResourceLoader.exists(path), "3D Model exists for character '%s'" % id)
		var res = load(path)
		assert_true(res is PackedScene, "Character '%s' model loads as PackedScene" % id)
		if res is PackedScene:
			var node = res.instantiate()
			assert_true(node != null and node.get_child_count() > 0, "Character '%s' instantiates with geometry nodes" % id)
			node.free()
			
	# Test arena and referee
	assert_true(ResourceLoader.exists("res://assets/models/ring_arena.glb"), "Arena model exists")
	assert_true(ResourceLoader.exists("res://assets/models/referee_cobra.glb"), "KingCobraJFS referee model exists")

func test_fighter_movement_lock() -> void:
	var fighter: Fighter = Fighter.new()
	fighter.character_id = "tophiachu"
	fighter.load_character_data()
	
	# 1. Idle state accepts movement
	fighter.current_state = Fighter.State.IDLE
	fighter.input_dir = Vector2(1.0, 0.0)
	fighter._handle_locomotion(0.016)
	assert_true(fighter.velocity.length() > 0.0, "Fighter moves in IDLE state when receiving input")
	
	# 2. Strict movement ownership locks
	fighter.input_dir = Vector2(1.0, 0.0)
	fighter._set_state(Fighter.State.KNOCKED_DOWN)
	fighter._update_state_machine(0.016)
	assert_true(fighter.velocity == Vector3.ZERO, "Fighter movement is strictly locked during KNOCKED_DOWN")
	
	fighter._set_state(Fighter.State.GRAPPLING_DEFENDER)
	fighter._update_state_machine(0.016)
	assert_true(fighter.velocity == Vector3.ZERO, "Fighter movement is strictly locked during GRAPPLING_DEFENDER")
	
	fighter._set_state(Fighter.State.PINNED)
	fighter._update_state_machine(0.016)
	assert_true(fighter.velocity == Vector3.ZERO, "Fighter movement is strictly locked during PINNED")
	
	fighter.free()

func test_damage_occurs_only_once() -> void:
	var attacker: Fighter = Fighter.new()
	var defender: Fighter = Fighter.new()
	attacker.character_id = "tophiachu"
	defender.character_id = "cyraxx"
	attacker.load_character_data()
	defender.load_character_data()
	
	attacker.opponent = defender
	attacker.position = Vector3(0, 0, 0)
	defender.position = Vector3(0, 0, -0.8) # Within reach and forward cone
	
	attacker.input_strike = true
	attacker._start_strike()
	assert_true(attacker.current_state == Fighter.State.STRIKING, "Fighter enters STRIKING state")
	
	var initial_hp: float = defender.vitality
	attacker.state_timer = 0.15 # Inside [0.12, 0.32] window
	attacker._handle_strike_active_window()
	
	assert_true(defender.vitality < initial_hp, "First contact applies damage")
	var hp_after_hit: float = defender.vitality
	
	# Tick again inside same active window
	attacker.state_timer = 0.20
	attacker._handle_strike_active_window()
	assert_true(defender.vitality == hp_after_hit, "Subsequent active frames do NOT apply duplicate damage")
	
	attacker.free()
	defender.free()

func test_synchronized_grapple_lock_and_release() -> void:
	var attacker: Fighter = Fighter.new()
	var defender: Fighter = Fighter.new()
	attacker.character_id = "tophiachu"
	defender.character_id = "cyraxx"
	attacker.load_character_data()
	defender.load_character_data()
	
	attacker.opponent = defender
	attacker.position = Vector3(0, 0, 0)
	defender.position = Vector3(0, 0, 1.0)
	
	attacker._start_synchronized_throw(defender)
	assert_true(attacker.current_state == Fighter.State.GRAPPLING_ATTACKER, "Attacker enters GRAPPLING_ATTACKER")
	assert_true(defender.current_state == Fighter.State.GRAPPLING_DEFENDER, "Defender enters GRAPPLING_DEFENDER")
	
	# Tick to impact
	attacker.state_timer = 0.65
	attacker._process_synchronized_attacker()
	assert_true(attacker.throw_has_impacted, "Throw registers impact at keyframe")
	
	# Tick to throw release
	attacker.state_timer = 1.15
	attacker._process_synchronized_attacker()
	assert_true(attacker.current_state == Fighter.State.IDLE, "Attacker cleanly returns to IDLE after throw")
	assert_true(defender.current_state == Fighter.State.KNOCKED_DOWN, "Defender transitions to KNOCKED_DOWN after throw")
	
	attacker.free()
	defender.free()

func test_pin_count_and_rope_break_priority() -> void:
	var manager: MatchManager = MatchManager.new()
	var f1: Fighter = Fighter.new()
	var f2: Fighter = Fighter.new()
	root.add_child(f1)
	root.add_child(f2)
	root.add_child(manager)
	
	f1.character_id = "tophiachu"
	f2.character_id = "cyraxx"
	f1.load_character_data()
	f2.load_character_data()
	
	manager.fighter_1 = f1
	manager.fighter_2 = f2
	manager._setup_match()
	
	# 1. Test Rope Break detection
	var near_rope_pos: Vector3 = Vector3(3.5, 0, 0) # Mat edge is 4.0, within 0.85
	var center_pos: Vector3 = Vector3(0, 0, 0)
	assert_true(MatchRules.is_near_ropes(near_rope_pos), "Position near ropes detected correctly")
	assert_true(not MatchRules.is_near_ropes(center_pos), "Center ring is clear of ropes")
	
	# 2. Rope Break cancels pin immediately
	f2.position = near_rope_pos
	f1.position = near_rope_pos
	var rope_break_called: Array[bool] = [false]
	manager.rope_break_called.connect(func(): rope_break_called[0] = true)
	manager._on_fighter_pin_initiated(f1, f2)
	assert_true(rope_break_called[0], "Rope break immediately triggered when pin initiated near ropes")
	assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Match returns to IN_PROGRESS on rope break")
	
	# 3. Clean Pin in center
	f1.position = center_pos
	f2.position = center_pos
	manager._on_fighter_pin_initiated(f1, f2)
	assert_true(manager.current_state == MatchManager.MatchState.PIN_ATTEMPT, "Pin attempt successfully started in center")
	
	# Tick pin countdown
	manager._process_pin_countdown(1.2)
	assert_true(manager.current_count == 1, "Referee counts 1 at first interval")
	manager._process_pin_countdown(1.2)
	assert_true(manager.current_count == 2, "Referee counts 2 at second interval")
	
	# Kickout before count 3
	var pin_broken_called: Array[bool] = [false]
	manager.pin_broken.connect(func(_reason): pin_broken_called[0] = true)
	manager._on_kick_out_succeeded(f2)
	assert_true(pin_broken_called[0], "Kick-out breaks pin before count 3")
	assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Match returns to IN_PROGRESS on kickout")
	
	manager.free()
	f1.free()
	f2.free()

func test_roster_pair_matrix_compatibility() -> void:
	var ids: Array = RosterData.get_all_ids()
	var total_pairs: int = 0
	var success_pairs: int = 0
	
	for atk_id in ids:
		for def_id in ids:
			total_pairs += 1
			var atk: Fighter = Fighter.new()
			var def: Fighter = Fighter.new()
			atk.character_id = atk_id
			def.character_id = def_id
			atk.load_character_data()
			def.load_character_data()
			
			atk.opponent = def
			atk._start_synchronized_throw(def)
			
			if atk.current_state == Fighter.State.GRAPPLING_ATTACKER and def.current_state == Fighter.State.GRAPPLING_DEFENDER:
				success_pairs += 1
				
			atk.free()
			def.free()
			
	assert_true(total_pairs == 64, "Total roster pairings equal 64 (8x8 matrix)")
	assert_true(success_pairs == 64, "All 64 attacker-defender pairings initialize throws without error")

func test_leverage_throw_routing() -> void:
	var cyraxx: Fighter = Fighter.new()
	var tophiachu: Fighter = Fighter.new()
	cyraxx.character_id = "cyraxx"
	tophiachu.character_id = "tophiachu"
	cyraxx.load_character_data()
	tophiachu.load_character_data()
	
	# Cyraxx (Power 4, reach 0.95) vs Tophiachu (Power 8, reach 1.25)
	var cyraxx_is_leverage: bool = (cyraxx.stat_power < tophiachu.stat_power or cyraxx.reach_distance < tophiachu.reach_distance)
	assert_true(cyraxx_is_leverage, "Lightweight Cyraxx correctly routes to low leverage trip against heavyweight Tophiachu")
	
	# Tophiachu vs Cyraxx
	var tophiachu_is_leverage: bool = (tophiachu.stat_power < cyraxx.stat_power or tophiachu.reach_distance < cyraxx.reach_distance)
	assert_true(not tophiachu_is_leverage, "Heavyweight Tophiachu correctly routes to high overhead powerslam against Cyraxx")
	
	cyraxx.free()
	tophiachu.free()

func test_submission_and_tap_out() -> void:
	var manager: MatchManager = MatchManager.new()
	var f1: Fighter = Fighter.new()
	var f2: Fighter = Fighter.new()
	root.add_child(f1)
	root.add_child(f2)
	root.add_child(manager)
	f1.character_id = "tophiachu"
	f2.character_id = "cyraxx"
	f1.load_character_data()
	f2.load_character_data()
	
	manager.fighter_1 = f1
	manager.fighter_2 = f2
	manager._setup_match()
	
	# Knock down opponent to allow submission
	f2.current_state = Fighter.State.KNOCKED_DOWN
	f1.position = Vector3(0, 0, 0)
	f2.position = Vector3(0, 0, 0.5)
	
	# 1. Attempt submission
	f1._attempt_submission(false)
	assert_true(f1.current_state == Fighter.State.SUBMISSION_ATTACKER, "Attacker enters SUBMISSION_ATTACKER")
	assert_true(f2.current_state == Fighter.State.SUBMISSION_DEFENDER, "Defender enters SUBMISSION_DEFENDER")
	
	# 2. Process submission hold pressure
	var hp_before: float = f2.vitality
	var sta_before: float = f2.stamina
	f1._process_submission_attacker(0.6)
	assert_true(f2.vitality < hp_before, "Submission hold applies continuous pressure damage")
	assert_true(f2.stamina < sta_before, "Submission hold drains defender stamina")
	
	# 3. Test escape
	f2.pin_escape_progress = 100.0
	var escaped_flag: Array[bool] = [false]
	manager.submission_escaped.connect(func(): escaped_flag[0] = true)
	f2._execute_submission_escape()
	assert_true(escaped_flag[0], "Defender escape breaks submission hold")
	assert_true(f2.current_state == Fighter.State.GETTING_UP, "Defender transitions to GETTING_UP on escape")
	assert_true(f1.current_state == Fighter.State.IDLE, "Attacker returns to IDLE on submission escape")
	
	# 4. Test Tap-Out Victory
	f2.current_state = Fighter.State.KNOCKED_DOWN
	f2.vitality = 5.0 # Low health
	f1.position = Vector3(0, 0, 0)
	f2.position = Vector3(0, 0, 0.5)
	f1._attempt_submission(false)
	
	var tap_out_called: Array[bool] = [false]
	manager.match_ended.connect(func(_winner, method):
		if method == "SUBMISSION (TAP OUT)":
			tap_out_called[0] = true
	)
	f1._process_submission_attacker(0.6) # Depletes remaining 5.0 HP
	manager._physics_process(1.0 / 60.0) # Authoritative manager evaluates submission outcome
	assert_true(tap_out_called[0], "Depleting vitality during submission results in SUBMISSION (TAP OUT) victory")
	assert_true(manager.current_state == MatchManager.MatchState.MATCH_OVER, "Match terminates with MATCH_OVER on tap-out")
	
	manager.free()
	f1.free()
	f2.free()

func test_audio_and_trauma_shake() -> void:
	# 1. Test AudioManager synthesis
	var audio: AudioManager = AudioManager.new()
	audio._create_audio_streams()
	assert_true(audio.snd_bell != null, "Bell audio stream synthesized successfully")
	assert_true(audio.snd_mat_slam != null, "Mat slam audio stream synthesized successfully")
	assert_true(audio.snd_strike_clean != null, "Strike audio stream synthesized successfully")
	assert_true(audio.snd_ref_slap != null, "Referee slap audio stream synthesized successfully")
	assert_true(audio.snd_crowd_cheer != null, "Crowd cheer audio stream synthesized successfully")
	assert_true(audio.snd_finisher_stinger != null, "Finisher stinger audio stream synthesized successfully")
	assert_true(audio.snd_victory_fanfare != null, "Victory fanfare audio stream synthesized successfully")
	assert_true(audio.snd_rope_break != null, "Rope break buzzer audio stream synthesized successfully")
	assert_true(audio.snd_counts.size() == 3, "Count tones synthesized for counts 1, 2, and 3")
	audio.free()
	
	# 2. Test BroadcastCamera trauma shake
	var cam: BroadcastCamera = BroadcastCamera.new()
	var t1: Node3D = Node3D.new()
	var t2: Node3D = Node3D.new()
	cam.target_1 = t1
	cam.target_2 = t2
	cam.add_trauma(0.6)
	assert_true(cam.trauma == 0.6, "Camera trauma added correctly")
	cam._physics_process(0.1)
	assert_true(cam.trauma < 0.6, "Camera trauma decays smoothly over time")
	
	cam.free()
	t1.free()
	t2.free()

func test_match_config_and_character_select() -> void:
	# 1. MatchConfig persistence
	MatchConfig.set_match("novaonline", "daniel_larson", false)
	assert_true(MatchConfig.p1_character_id == "novaonline", "MatchConfig stores P1 selection")
	assert_true(MatchConfig.p2_character_id == "daniel_larson", "MatchConfig stores P2 selection")
	assert_true(MatchConfig.p2_is_cpu == false, "MatchConfig stores CPU toggle")
	
	# 2. CharacterSelect UI instantiation
	var select_scene_res = load("res://scenes/ui/character_select.tscn")
	assert_true(select_scene_res is PackedScene, "CharacterSelect scene resource exists and loads")
	if select_scene_res is PackedScene:
		var select_ui: CharacterSelect = select_scene_res.instantiate() as CharacterSelect
		root.add_child(select_ui)
		select_ui._ready()
		assert_true(select_ui.roster_buttons.size() == 8, "CharacterSelect creates 8 buttons in roster grid")
		assert_true(select_ui.p1_index == select_ui.character_ids.find("novaonline"), "CharacterSelect reflects initial MatchConfig P1")
		assert_true(select_ui.p2_index == select_ui.character_ids.find("daniel_larson"), "CharacterSelect reflects initial MatchConfig P2")
		
		# Test CPU toggle
		var cpu_before: bool = select_ui.p2_is_cpu
		select_ui._on_cpu_toggle_pressed()
		assert_true(select_ui.p2_is_cpu != cpu_before, "CharacterSelect toggles P2 CPU mode")
		
		select_ui.queue_free()
	
	# Reset MatchConfig to defaults
	MatchConfig.reset_defaults()

func test_pass_a_cpu_escape_mechanisms() -> void:
	# 1. Test CPU Pin Escape without keyboard input
	var cpu_fighter: Fighter = Fighter.new()
	var opponent: Fighter = Fighter.new()
	var cpu_ctrl: CPUController = CPUController.new()
	
	root.add_child(cpu_fighter)
	root.add_child(opponent)
	root.add_child(cpu_ctrl)
	
	cpu_fighter.character_id = "cyraxx"
	opponent.character_id = "tophiachu"
	cpu_fighter.load_character_data()
	opponent.load_character_data()
	
	cpu_fighter.opponent = opponent
	opponent.opponent = cpu_fighter
	cpu_fighter.is_cpu = true
	cpu_ctrl.fighter = cpu_fighter
	
	# Lock into pin
	opponent.current_state = Fighter.State.PINNING
	cpu_fighter.on_pinned(opponent)
	assert_true(cpu_fighter.current_state == Fighter.State.PINNED, "Pass A: Defender enters PINNED state")
	assert_true(cpu_fighter.pin_escape_progress == 0.0, "Pass A: Pin escape progress starts at 0")
	
	# Simulate in-tree physics processing
	var kicked_out: Array[bool] = [false]
	cpu_fighter.kick_out_succeeded.connect(func(_f): kicked_out[0] = true)
	
	# Tick through physics updates until kickout or max frames
	for frame in range(90):
		cpu_ctrl._physics_process(1.0 / 60.0)
		cpu_fighter._physics_process(1.0 / 60.0)
		if kicked_out[0]:
			break
			
	assert_true(cpu_fighter.pin_escape_progress > 20.0, "Pass A: CPU defender accumulates pin escape progress without keyboard input")
	assert_true(kicked_out[0] and cpu_fighter.current_state == Fighter.State.GETTING_UP, "Pass A: CPU defender successfully kicks out via command interface")
	
	# 2. Test CPU Submission Escape without keyboard input
	opponent.current_state = Fighter.State.SUBMISSION_ATTACKER
	opponent.synchronized_partner = cpu_fighter
	cpu_fighter.on_locked_by_submission(opponent)
	assert_true(cpu_fighter.current_state == Fighter.State.SUBMISSION_DEFENDER, "Pass A: Defender enters SUBMISSION_DEFENDER state")
	
	var submission_escaped: Array[bool] = [false]
	cpu_fighter.submission_escaped.connect(func(_f): submission_escaped[0] = true)
	
	for frame in range(90):
		cpu_ctrl._physics_process(1.0 / 60.0)
		cpu_fighter._physics_process(1.0 / 60.0)
		if submission_escaped[0]:
			break
			
	assert_true(submission_escaped[0] and cpu_fighter.current_state == Fighter.State.GETTING_UP, "Pass A: CPU defender successfully escapes submission via command interface")
	
	cpu_ctrl.free()
	cpu_fighter.free()
	opponent.free()

func test_pass_a_throw_height_and_ownership() -> void:
	var atk: Fighter = Fighter.new()
	var def: Fighter = Fighter.new()
	root.add_child(atk)
	root.add_child(def)
	
	atk.character_id = "tophiachu"
	def.character_id = "cyraxx"
	atk.load_character_data()
	def.load_character_data()
	
	atk.position = Vector3(0, 0, -1.0)
	def.position = Vector3(0, 0, 1.0)
	atk.opponent = def
	def.opponent = atk
	
	atk._start_synchronized_throw(def)
	assert_true(atk.current_state == Fighter.State.GRAPPLING_ATTACKER, "Pass A: Attacker in GRAPPLING_ATTACKER")
	assert_true(def.current_state == Fighter.State.GRAPPLING_DEFENDER, "Pass A: Defender in GRAPPLING_DEFENDER")
	
	# Advance physics frames into the mid-lift peak (state_timer ~ 0.3s)
	var peak_height_observed: float = 0.0
	for frame in range(20):
		atk._physics_process(0.016)
		def._physics_process(0.016)
		var def_y: float = def.global_position.y if def.is_inside_tree() else def.position.y
		if def_y > peak_height_observed:
			peak_height_observed = def_y
			
	assert_true(peak_height_observed > 1.2, "Pass A: Defender reaches peak throw height (> 1.2m) without being clamped to 0 by _clamp_within_ring (Observed: %.2fm)" % peak_height_observed)
	
	# Continue to throw completion
	for frame in range(60):
		atk._physics_process(0.016)
		def._physics_process(0.016)
		
	assert_true(atk.current_state == Fighter.State.IDLE, "Pass A: Attacker cleanly transitions to IDLE after throw")
	assert_true(def.current_state == Fighter.State.KNOCKED_DOWN, "Pass A: Defender transitions to KNOCKED_DOWN after throw")
	var final_y: float = def.global_position.y if def.is_inside_tree() else def.position.y
	assert_true(is_equal_approx(final_y, 0.0), "Pass A: Defender cleanly grounded on canvas after throw (Y=%.2f)" % final_y)
	
	atk.free()
	def.free()

func test_pass_a_slot_inversions_and_facing_vectors() -> void:
	var configs = [
		{"atk_id": "tophiachu", "atk_slot": 1, "atk_pos": Vector3(-1.5, 0, 0), "def_id": "cyraxx", "def_slot": 2, "def_pos": Vector3(1.5, 0, 0), "desc": "P1 Attacker (-X) vs P2 Defender (+X)"},
		{"atk_id": "tophiachu", "atk_slot": 2, "atk_pos": Vector3(1.5, 0, 0), "def_id": "cyraxx", "def_slot": 1, "def_pos": Vector3(-1.5, 0, 0), "desc": "P2 Attacker (+X) vs P1 Defender (-X)"},
		{"atk_id": "cyraxx", "atk_slot": 1, "atk_pos": Vector3(0, 0, -1.5), "def_id": "tophiachu", "def_slot": 2, "def_pos": Vector3(0, 0, 1.5), "desc": "P1 Attacker (-Z) vs P2 Defender (+Z)"},
		{"atk_id": "cyraxx", "atk_slot": 2, "atk_pos": Vector3(0, 0, 1.5), "def_id": "tophiachu", "def_slot": 1, "def_pos": Vector3(0, 0, -1.5), "desc": "P2 Attacker (+Z) vs P1 Defender (-Z)"}
	]
	
	for cfg in configs:
		var atk: Fighter = Fighter.new()
		var def: Fighter = Fighter.new()
		root.add_child(atk)
		root.add_child(def)
		
		atk.character_id = cfg["atk_id"]
		atk.player_index = cfg["atk_slot"]
		def.character_id = cfg["def_id"]
		def.player_index = cfg["def_slot"]
		atk.load_character_data()
		def.load_character_data()
		
		atk.position = cfg["atk_pos"]
		def.position = cfg["def_pos"]
		atk.opponent = def
		def.opponent = atk
		
		atk._start_synchronized_throw(def)
		
		var atk_fwd: Vector3 = -atk.transform.basis.z.normalized()
		var def_fwd: Vector3 = -def.transform.basis.z.normalized()
		var expected_atk_dir: Vector3 = (cfg["def_pos"] - cfg["atk_pos"]).normalized()
		var expected_def_dir: Vector3 = (cfg["atk_pos"] - cfg["def_pos"]).normalized()
		
		var atk_facing_dot: float = atk_fwd.dot(expected_atk_dir)
		var def_facing_dot: float = def_fwd.dot(expected_def_dir)
		assert_true(atk_facing_dot > 0.98, "Pass A Facing: Attacker faces defender in %s (dot=%.3f)" % [cfg["desc"], atk_facing_dot])
		assert_true(def_facing_dot > 0.98, "Pass A Facing: Defender faces attacker in %s (dot=%.3f)" % [cfg["desc"], def_facing_dot])
		
		# Advance to post-impact slam
		atk.state_timer = 0.65
		atk._process_synchronized_attacker()
		
		# Slam position must be in front of attacker along attacker forward vector
		var slam_offset: Vector3 = (def.position - atk.position).normalized()
		var slam_in_front: float = slam_offset.dot(atk_fwd)
		assert_true(slam_in_front > 0.95, "Pass A Trajectory: Slam position is in front of attacker in %s (dot=%.3f)" % [cfg["desc"], slam_in_front])
		
		atk.free()
		def.free()

func test_pass_a_resource_aware_pinfall_balance() -> void:
	# 1. Fresh CPU escaping an ordinary pin
	var mm_fresh: MatchManager = MatchManager.new()
	var p1_fresh: Fighter = Fighter.new()
	var p2_fresh: Fighter = Fighter.new()
	var cpu_fresh: CPUController = CPUController.new()
	root.add_child(mm_fresh)
	root.add_child(p1_fresh)
	root.add_child(p2_fresh)
	root.add_child(cpu_fresh)
	
	p1_fresh.character_id = "tophiachu"
	p2_fresh.character_id = "cyraxx"
	p1_fresh.load_character_data()
	p2_fresh.load_character_data()
	p2_fresh.is_cpu = true
	cpu_fresh.fighter = p2_fresh
	p2_fresh.vitality = p2_fresh.max_vitality
	p2_fresh.stamina = p2_fresh.max_stamina
	p1_fresh.position = Vector3.ZERO
	p2_fresh.position = Vector3.ZERO
	mm_fresh.fighter_1 = p1_fresh
	mm_fresh.fighter_2 = p2_fresh
	mm_fresh._setup_match()
	
	p1_fresh._start_pin(p2_fresh)
	var fresh_outcome: Array = ["NONE"]
	var fresh_count_at_break: Array = [0]
	mm_fresh.pin_broken.connect(func(reason):
		fresh_outcome[0] = reason
		fresh_count_at_break[0] = mm_fresh.current_count
	)
	
	for frame in range(240):
		cpu_fresh._physics_process(1.0 / 60.0)
		p1_fresh._physics_process(1.0 / 60.0)
		p2_fresh._physics_process(1.0 / 60.0)
		mm_fresh._physics_process(1.0 / 60.0)
		if fresh_outcome[0] != "NONE":
			break
			
	assert_true(fresh_outcome[0] == "KICKOUT", "Pass A Pinfall: Fresh CPU defender kicks out of pin (Reason: %s)" % fresh_outcome[0])
	assert_true(fresh_count_at_break[0] <= 2, "Pass A Pinfall: Fresh CPU kicks out before referee 3-count (Count: %d)" % fresh_count_at_break[0])
	
	mm_fresh.free()
	p1_fresh.free()
	p2_fresh.free()
	cpu_fresh.free()
	
	# 2. Sufficiently weakened CPU losing a valid pin (15% vitality, 10% stamina)
	var mm_weak: MatchManager = MatchManager.new()
	var p1_weak: Fighter = Fighter.new()
	var p2_weak: Fighter = Fighter.new()
	var cpu_weak: CPUController = CPUController.new()
	root.add_child(mm_weak)
	root.add_child(p1_weak)
	root.add_child(p2_weak)
	root.add_child(cpu_weak)
	
	p1_weak.character_id = "tophiachu"
	p2_weak.character_id = "cyraxx"
	p1_weak.load_character_data()
	p2_weak.load_character_data()
	p2_weak.is_cpu = true
	cpu_weak.fighter = p2_weak
	p2_weak.vitality = p2_weak.max_vitality * 0.15
	p2_weak.stamina = p2_weak.max_stamina * 0.10
	p1_weak.position = Vector3.ZERO
	p2_weak.position = Vector3.ZERO
	mm_weak.fighter_1 = p1_weak
	mm_weak.fighter_2 = p2_weak
	mm_weak._setup_match()
	
	p1_weak._start_pin(p2_weak)
	var weak_outcome: Array = ["NONE"]
	var weak_winner: Array = [null]
	mm_weak.match_ended.connect(func(winner, method):
		weak_outcome[0] = method
		weak_winner[0] = winner
	)
	
	for frame in range(240):
		cpu_weak._physics_process(1.0 / 60.0)
		p1_weak._physics_process(1.0 / 60.0)
		p2_weak._physics_process(1.0 / 60.0)
		mm_weak._physics_process(1.0 / 60.0)
		if weak_outcome[0] != "NONE":
			break
			
	assert_true(weak_outcome[0] == "PINFALL (3-COUNT)", "Pass A Pinfall: Weakened CPU loses by 3-count pinfall (Outcome: %s)" % weak_outcome[0])
	assert_true(weak_winner[0] == p1_weak, "Pass A Pinfall: Attacker P1 declared match winner over weakened CPU")
	
	mm_weak.free()
	p1_weak.free()
	p2_weak.free()
	cpu_weak.free()
	
	# 3. Exhausted CPU losing a valid pin (0% vitality, 0% stamina)
	var mm_exh: MatchManager = MatchManager.new()
	var p1_exh: Fighter = Fighter.new()
	var p2_exh: Fighter = Fighter.new()
	var cpu_exh: CPUController = CPUController.new()
	root.add_child(mm_exh)
	root.add_child(p1_exh)
	root.add_child(p2_exh)
	root.add_child(cpu_exh)
	
	p1_exh.character_id = "tophiachu"
	p2_exh.character_id = "cyraxx"
	p1_exh.load_character_data()
	p2_exh.load_character_data()
	p2_exh.is_cpu = true
	cpu_exh.fighter = p2_exh
	p2_exh.vitality = 0.0
	p2_exh.stamina = 0.0
	p1_exh.position = Vector3.ZERO
	p2_exh.position = Vector3.ZERO
	mm_exh.fighter_1 = p1_exh
	mm_exh.fighter_2 = p2_exh
	mm_exh._setup_match()
	
	p1_exh._start_pin(p2_exh)
	var exh_outcome: Array = ["NONE"]
	mm_exh.match_ended.connect(func(_winner, method):
		exh_outcome[0] = method
	)
	
	for frame in range(240):
		cpu_exh._physics_process(1.0 / 60.0)
		p1_exh._physics_process(1.0 / 60.0)
		p2_exh._physics_process(1.0 / 60.0)
		mm_exh._physics_process(1.0 / 60.0)
		if exh_outcome[0] != "NONE":
			break
			
	assert_true(exh_outcome[0] == "PINFALL (3-COUNT)", "Pass A Pinfall: Exhausted CPU (0 HP) loses by 3-count pinfall")
	
	mm_exh.free()
	p1_exh.free()
	p2_exh.free()
	cpu_exh.free()
	
	# 4. Human Input Modes: Hold-to-Resist and Active Mash
	# A) Fresh Human Hold-to-Resist
	var mm_hum_fresh: MatchManager = MatchManager.new()
	var p1_hum_atk: Fighter = Fighter.new()
	var p2_hum_def: Fighter = Fighter.new()
	root.add_child(mm_hum_fresh)
	root.add_child(p1_hum_atk)
	root.add_child(p2_hum_def)
	
	p1_hum_atk.character_id = "tophiachu"
	p2_hum_def.character_id = "cyraxx"
	p1_hum_atk.player_index = 1
	p2_hum_def.player_index = 2
	p1_hum_atk.load_character_data()
	p2_hum_def.load_character_data()
	p2_hum_def.is_cpu = false
	p2_hum_def.vitality = p2_hum_def.max_vitality
	p2_hum_def.stamina = p2_hum_def.max_stamina
	mm_hum_fresh.fighter_1 = p1_hum_atk
	mm_hum_fresh.fighter_2 = p2_hum_def
	mm_hum_fresh._setup_match()
	
	p1_hum_atk._start_pin(p2_hum_def)
	
	# Simulate human hold via Input action press
	Input.action_press("p2_pin")
	for frame in range(60):
		p1_hum_atk._physics_process(1.0 / 60.0)
		p2_hum_def._physics_process(1.0 / 60.0)
		mm_hum_fresh._physics_process(1.0 / 60.0)
	Input.action_release("p2_pin")
		
	assert_true(p2_hum_def.pin_escape_progress > 20.0, "Pass A Pinfall: Fresh human hold-to-resist accumulates escape progress (Observed: %.1f)" % p2_hum_def.pin_escape_progress)
	
	mm_hum_fresh.free()
	p1_hum_atk.free()
	p2_hum_def.free()
	
	# B) Exhausted Human Hold-to-Resist suffers 3-count pinfall
	var mm_hum_exh: MatchManager = MatchManager.new()
	var p1_hum_atk2: Fighter = Fighter.new()
	var p2_hum_def2: Fighter = Fighter.new()
	root.add_child(mm_hum_exh)
	root.add_child(p1_hum_atk2)
	root.add_child(p2_hum_def2)
	
	p1_hum_atk2.character_id = "tophiachu"
	p2_hum_def2.character_id = "cyraxx"
	p1_hum_atk2.player_index = 1
	p2_hum_def2.player_index = 2
	p1_hum_atk2.load_character_data()
	p2_hum_def2.load_character_data()
	p2_hum_def2.is_cpu = false
	p2_hum_def2.vitality = 0.0
	p2_hum_def2.stamina = 0.0
	mm_hum_exh.fighter_1 = p1_hum_atk2
	mm_hum_exh.fighter_2 = p2_hum_def2
	mm_hum_exh._setup_match()
	
	p1_hum_atk2._start_pin(p2_hum_def2)
	var hum_exh_outcome: Array = ["NONE"]
	mm_hum_exh.match_ended.connect(func(_w, m): hum_exh_outcome[0] = m)
	
	Input.action_press("p2_pin")
	for frame in range(240):
		p1_hum_atk2._physics_process(1.0 / 60.0)
		p2_hum_def2._physics_process(1.0 / 60.0)
		mm_hum_exh._physics_process(1.0 / 60.0)
		if hum_exh_outcome[0] != "NONE":
			break
	Input.action_release("p2_pin")
			
	assert_true(hum_exh_outcome[0] == "PINFALL (3-COUNT)", "Pass A Pinfall: Exhausted human holding pin button loses by 3-count pinfall")
	
	mm_hum_exh.free()
	p1_hum_atk2.free()
	p2_hum_def2.free()
	
	# C) Fresh Human Mashing Input kicks out
	var mm_mash_fresh: MatchManager = MatchManager.new()
	var p1_mash_atk: Fighter = Fighter.new()
	var p2_mash_def: Fighter = Fighter.new()
	root.add_child(mm_mash_fresh)
	root.add_child(p1_mash_atk)
	root.add_child(p2_mash_def)
	p1_mash_atk.character_id = "tophiachu"
	p2_mash_def.character_id = "cyraxx"
	p1_mash_atk.player_index = 1
	p2_mash_def.player_index = 2
	p1_mash_atk.load_character_data()
	p2_mash_def.load_character_data()
	p2_mash_def.is_cpu = false
	p2_mash_def.vitality = p2_mash_def.max_vitality
	p2_mash_def.stamina = p2_mash_def.max_stamina
	mm_mash_fresh.fighter_1 = p1_mash_atk
	mm_mash_fresh.fighter_2 = p2_mash_def
	mm_mash_fresh._setup_match()
	p1_mash_atk._start_pin(p2_mash_def)
	var mash_fresh_outcome: Array = ["NONE"]
	mm_mash_fresh.pin_broken.connect(func(r): mash_fresh_outcome[0] = r)
	for frame in range(240):
		if frame % 6 == 0:
			Input.action_press("p2_pin")
		else:
			Input.action_release("p2_pin")
		p1_mash_atk._physics_process(1.0 / 60.0)
		p2_mash_def._physics_process(1.0 / 60.0)
		mm_mash_fresh._physics_process(1.0 / 60.0)
		if mash_fresh_outcome[0] != "NONE":
			break
	Input.action_release("p2_pin")
	assert_true(mash_fresh_outcome[0] == "KICKOUT", "Pass A Pinfall: Fresh human mashing kicks out of pin")
	mm_mash_fresh.free()
	p1_mash_atk.free()
	p2_mash_def.free()
	
	# D) Exhausted Human Mashing Input (0% HP) loses by pinfall despite mashing
	var mm_mash_exh: MatchManager = MatchManager.new()
	var p1_mash_atk2: Fighter = Fighter.new()
	var p2_mash_def2: Fighter = Fighter.new()
	root.add_child(mm_mash_exh)
	root.add_child(p1_mash_atk2)
	root.add_child(p2_mash_def2)
	p1_mash_atk2.character_id = "tophiachu"
	p2_mash_def2.character_id = "cyraxx"
	p1_mash_atk2.player_index = 1
	p2_mash_def2.player_index = 2
	p1_mash_atk2.load_character_data()
	p2_mash_def2.load_character_data()
	p2_mash_def2.is_cpu = false
	p2_mash_def2.vitality = 0.0
	p2_mash_def2.stamina = 0.0
	mm_mash_exh.fighter_1 = p1_mash_atk2
	mm_mash_exh.fighter_2 = p2_mash_def2
	mm_mash_exh._setup_match()
	p1_mash_atk2._start_pin(p2_mash_def2)
	var mash_exh_outcome: Array = ["NONE"]
	mm_mash_exh.match_ended.connect(func(_w, m): mash_exh_outcome[0] = m)
	for frame in range(240):
		if frame % 6 == 0:
			Input.action_press("p2_pin")
		else:
			Input.action_release("p2_pin")
		p1_mash_atk2._physics_process(1.0 / 60.0)
		p2_mash_def2._physics_process(1.0 / 60.0)
		mm_mash_exh._physics_process(1.0 / 60.0)
		if mash_exh_outcome[0] != "NONE":
			break
	Input.action_release("p2_pin")
	assert_true(mash_exh_outcome[0] == "PINFALL (3-COUNT)", "Pass A Pinfall: Exhausted human mashing at 10 Hz still loses by 3-count pinfall")
	mm_mash_exh.free()
	p1_mash_atk2.free()
	p2_mash_def2.free()
	
	# 5. Slot Inversion (P2 Attacker vs P1 CPU Defender)
	var mm_inv: MatchManager = MatchManager.new()
	var p1_inv: Fighter = Fighter.new()
	var p2_inv: Fighter = Fighter.new()
	var cpu_inv: CPUController = CPUController.new()
	root.add_child(mm_inv)
	root.add_child(p2_inv)
	root.add_child(p1_inv)
	root.add_child(cpu_inv)
	
	p1_inv.character_id = "cyraxx"
	p2_inv.character_id = "tophiachu"
	p1_inv.player_index = 1
	p2_inv.player_index = 2
	p1_inv.load_character_data()
	p2_inv.load_character_data()
	p1_inv.is_cpu = true
	cpu_inv.fighter = p1_inv
	p1_inv.vitality = 0.0
	p1_inv.stamina = 0.0
	mm_inv.fighter_1 = p1_inv
	mm_inv.fighter_2 = p2_inv
	mm_inv._setup_match()
	
	p2_inv._start_pin(p1_inv)
	var inv_winner: Array = [null]
	var inv_outcome: Array = ["NONE"]
	mm_inv.match_ended.connect(func(w, m):
		inv_winner[0] = w
		inv_outcome[0] = m
	)
	
	for frame in range(240):
		cpu_inv._physics_process(1.0 / 60.0)
		p2_inv._physics_process(1.0 / 60.0)
		p1_inv._physics_process(1.0 / 60.0)
		mm_inv._physics_process(1.0 / 60.0)
		if inv_outcome[0] != "NONE":
			break
			
	assert_true(inv_outcome[0] == "PINFALL (3-COUNT)" and inv_winner[0] == p2_inv, "Pass A Pinfall: Slot Inversion (P2 Attacker wins over P1 CPU Defender)")
	
	mm_inv.free()
	p1_inv.free()
	p2_inv.free()
	cpu_inv.free()
	
	# 6. Tree Processing Order Inversion (Defender added before Attacker)
	var mm_order: MatchManager = MatchManager.new()
	var p1_ord: Fighter = Fighter.new()
	var p2_ord: Fighter = Fighter.new()
	var cpu_ord: CPUController = CPUController.new()
	root.add_child(mm_order)
	root.add_child(p2_ord)
	root.add_child(p1_ord)
	root.add_child(cpu_ord)
	
	p1_ord.character_id = "tophiachu"
	p2_ord.character_id = "cyraxx"
	p1_ord.load_character_data()
	p2_ord.load_character_data()
	p2_ord.is_cpu = true
	cpu_ord.fighter = p2_ord
	p2_ord.vitality = 0.0
	p2_ord.stamina = 0.0
	mm_order.fighter_1 = p1_ord
	mm_order.fighter_2 = p2_ord
	mm_order._setup_match()
	
	p1_ord._start_pin(p2_ord)
	var ord_outcome: Array = ["NONE"]
	mm_order.match_ended.connect(func(_w, m): ord_outcome[0] = m)
	
	for frame in range(240):
		p2_ord._physics_process(1.0 / 60.0)
		cpu_ord._physics_process(1.0 / 60.0)
		p1_ord._physics_process(1.0 / 60.0)
		mm_order._physics_process(1.0 / 60.0)
		if ord_outcome[0] != "NONE":
			break
			
	assert_true(ord_outcome[0] == "PINFALL (3-COUNT)", "Pass A Pinfall: Tree processing order inversion resolves deterministic 3-count pinfall")
	
	mm_order.free()
	p1_ord.free()
	p2_ord.free()
	cpu_ord.free()
	
	# 7. Rope Break Priority competing with Pin Count
	var mm_rope: MatchManager = MatchManager.new()
	var p1_rope: Fighter = Fighter.new()
	var p2_rope: Fighter = Fighter.new()
	root.add_child(mm_rope)
	root.add_child(p1_rope)
	root.add_child(p2_rope)
	
	p1_rope.character_id = "tophiachu"
	p2_rope.character_id = "cyraxx"
	p1_rope.load_character_data()
	p2_rope.load_character_data()
	p2_rope.vitality = 0.0
	p2_rope.stamina = 0.0
	p1_rope.position = Vector3(3.3, 0, 0)
	p2_rope.position = Vector3(3.3, 0, 0)
	mm_rope.fighter_1 = p1_rope
	mm_rope.fighter_2 = p2_rope
	mm_rope._setup_match()
	
	var rope_break_called: Array = [false]
	mm_rope.rope_break_called.connect(func(): rope_break_called[0] = true)
	
	p1_rope._start_pin(p2_rope)
	
	for frame in range(10):
		p1_rope._physics_process(1.0 / 60.0)
		p2_rope._physics_process(1.0 / 60.0)
		mm_rope._physics_process(1.0 / 60.0)
		
	assert_true(rope_break_called[0], "Pass A Pinfall: Pin near ropes immediately triggers rope break alert")
	assert_true(mm_rope.current_state == MatchManager.MatchState.IN_PROGRESS, "Pass A Pinfall: Match state returns to IN_PROGRESS on rope break")
	assert_true(mm_rope.current_count == 0, "Pass A Pinfall: Pin count aborted at 0 on rope break")
	
	mm_rope.free()
	p1_rope.free()
	p2_rope.free()

func test_explicit_impact_classification() -> void:
	var f: Fighter = Fighter.new()
	f.character_id = "cyraxx"
	f.load_character_data()
	
	# 1. Ordinary heavy attack (amount = 177.0, is_finisher = false)
	f.receive_damage(177.0, null, false, false)
	assert_true(f.recent_finisher_impact_timer == 0.0, "Impact Classification: Ordinary heavy throw does not set finisher disorientation")
	assert_true(f.recent_heavy_impact_timer == MatchRules.HEAVY_IMPACT_DISORIENTATION_DURATION, "Impact Classification: Ordinary heavy throw sets 1.5s heavy impact timer")
	
	# 2. Genuine finisher attack (amount = 177.0, is_finisher = true)
	f.receive_damage(177.0, null, false, true)
	assert_true(f.recent_finisher_impact_timer == MatchRules.FINISHER_DISORIENTATION_DURATION, "Impact Classification: Genuine finisher sets 4.5s finisher disorientation")
	assert_true(f.recent_heavy_impact_timer == 0.0, "Impact Classification: Genuine finisher overrides heavy impact disorientation")
	
	f.free()

func test_pass_a_boundary_safe_paired_throws() -> void:
	var boundary_cases = [
		{"name": "East Edge (+X)", "atk": Vector3(2.8, 0, 0), "def": Vector3(3.4, 0, 0)},
		{"name": "West Edge (-X)", "atk": Vector3(-2.8, 0, 0), "def": Vector3(-3.4, 0, 0)},
		{"name": "North Edge (+Z)", "atk": Vector3(0, 0, 2.8), "def": Vector3(0, 0, 3.4)},
		{"name": "South Edge (-Z)", "atk": Vector3(0, 0, -2.8), "def": Vector3(0, 0, -3.4)},
		{"name": "NE Corner (+X, +Z)", "atk": Vector3(2.5, 0, 2.5), "def": Vector3(3.1, 0, 3.1)},
		{"name": "NW Corner (-X, +Z)", "atk": Vector3(-2.5, 0, 2.5), "def": Vector3(-3.1, 0, 3.1)},
		{"name": "SE Corner (+X, -Z)", "atk": Vector3(2.5, 0, -2.5), "def": Vector3(3.1, 0, -3.1)},
		{"name": "SW Corner (-X, -Z)", "atk": Vector3(-2.5, 0, -2.5), "def": Vector3(-3.1, 0, -3.1)}
	]
	
	for tc in boundary_cases:
		for invert_slots in [false, true]:
			for invert_tree in [false, true]:
				var tag = "%s [%s/%s]" % [
					tc["name"],
					"P2Atk" if invert_slots else "P1Atk",
					"TreeInv" if invert_tree else "TreeNorm"
				]
				
				var p1: Fighter = Fighter.new()
				var p2: Fighter = Fighter.new()
				
				if invert_tree:
					root.add_child(p2)
					root.add_child(p1)
				else:
					root.add_child(p1)
					root.add_child(p2)
					
				p1.character_id = "tophiachu" if not invert_slots else "cyraxx"
				p2.character_id = "cyraxx" if not invert_slots else "tophiachu"
				p1.player_index = 1
				p2.player_index = 2
				p1.load_character_data()
				p2.load_character_data()
				
				var atk: Fighter = p2 if invert_slots else p1
				var def: Fighter = p1 if invert_slots else p2
				
				atk.position = tc["atk"]
				def.position = tc["def"]
				
				atk._start_synchronized_throw(def)
				
				var max_defender_radius: float = 0.0
				for frame in range(70):
					p1._physics_process(1.0 / 60.0)
					p2._physics_process(1.0 / 60.0)
					var def_r: float = max(abs(def.position.x), abs(def.position.z))
					max_defender_radius = max(max_defender_radius, def_r)
					
				assert_true(max_defender_radius <= MatchRules.THROW_SAFE_RING_BOUND + 0.01, "Boundary Throw: Defender remains strictly inside ring boundary (%s, max: %.2fm)" % [tag, max_defender_radius])
				assert_true(atk.current_state == Fighter.State.IDLE, "Boundary Throw: Attacker returns to IDLE (%s)" % tag)
				assert_true(def.current_state == Fighter.State.KNOCKED_DOWN, "Boundary Throw: Defender enters KNOCKED_DOWN (%s)" % tag)
				
				# Check for snap-back on subsequent frame when _clamp_within_ring runs on KNOCKED_DOWN
				var pos_at_release: Vector3 = def.position
				for frame in range(5):
					p1._physics_process(1.0 / 60.0)
					p2._physics_process(1.0 / 60.0)
				var pos_after: Vector3 = def.position
				assert_true(pos_at_release.distance_to(pos_after) < 0.01, "Boundary Throw: Zero snap-back on ground release (%s)" % tag)
				
				p1.free()
				p2.free()

func test_pass_a_strike_directional_cone() -> void:
	# Test forward cone validation for strikes (120 degree cone, STRIKE_CONE_MIN_DOT = 0.50)
	var attacker: Fighter = Fighter.new()
	var defender: Fighter = Fighter.new()
	attacker.character_id = "tophiachu"
	defender.character_id = "cyraxx"
	attacker.load_character_data()
	defender.load_character_data()
	attacker.opponent = defender
	defender.opponent = attacker
	
	# Test 1: Defender directly in front at (0, 0, -0.8) (0 deg) -> CONNECTS
	attacker.position = Vector3(0, 0, 0)
	attacker.rotation.y = 0.0 # Facing -Z
	defender.position = Vector3(0, 0, -0.8)
	defender.vitality = defender.max_vitality
	attacker._start_strike()
	attacker.state_timer = 0.15
	attacker._handle_strike_active_window()
	assert_true(attacker.attack_has_damaged, "Strike Cone [0 deg In Front]: Attack marks as damaged")
	assert_true(defender.vitality < defender.max_vitality, "Strike Cone [0 deg In Front]: Defender takes damage")
	
	# Test 2: Defender angled at 45 deg (-0.56, 0, -0.56) (dist = 0.79m, dot = 0.707 >= 0.50) -> CONNECTS
	attacker.position = Vector3(0, 0, 0)
	attacker.rotation.y = 0.0 # Facing -Z
	defender.position = Vector3(-0.56, 0, -0.56)
	defender.vitality = defender.max_vitality
	attacker._start_strike()
	attacker.state_timer = 0.15
	attacker._handle_strike_active_window()
	assert_true(attacker.attack_has_damaged, "Strike Cone [45 deg Angled]: Attack marks as damaged")
	assert_true(defender.vitality < defender.max_vitality, "Strike Cone [45 deg Angled]: Defender takes damage")
	
	# Test 3: Defender directly to the right at (0.8, 0, 0) (90 deg flank, dot = 0.0 < 0.50) -> MISSES
	attacker.position = Vector3(0, 0, 0)
	attacker.rotation.y = 0.0 # Facing -Z
	defender.position = Vector3(0.8, 0, 0)
	defender.vitality = defender.max_vitality
	attacker._start_strike()
	attacker.state_timer = 0.15
	attacker._handle_strike_active_window()
	assert_true(not attacker.attack_has_damaged, "Strike Cone [90 deg Flank]: Attack does NOT mark as damaged")
	assert_true(defender.vitality == defender.max_vitality, "Strike Cone [90 deg Flank]: Defender takes zero damage")
	
	# Test 4: Defender directly behind at (0, 0, 0.8) (180 deg, dot = -1.0 < 0.50) -> MISSES
	attacker.position = Vector3(0, 0, 0)
	attacker.rotation.y = 0.0 # Facing -Z
	defender.position = Vector3(0, 0, 0.8)
	defender.vitality = defender.max_vitality
	attacker._start_strike()
	attacker.state_timer = 0.15
	attacker._handle_strike_active_window()
	assert_true(not attacker.attack_has_damaged, "Strike Cone [180 deg Behind]: Attack does NOT mark as damaged")
	assert_true(defender.vitality == defender.max_vitality, "Strike Cone [180 deg Behind]: Defender takes zero damage")
	
	# Test 5: Attacker rotated to face right (+X, rotation.y = -PI/2)
	attacker.position = Vector3(0, 0, 0)
	attacker.rotation.y = -PI / 2.0 # Facing +X
	defender.position = Vector3(0.8, 0, 0) # Directly in front of rotated attacker!
	defender.vitality = defender.max_vitality
	attacker._start_strike()
	attacker.state_timer = 0.15
	attacker._handle_strike_active_window()
	assert_true(attacker.attack_has_damaged, "Strike Cone [Rotated Attacker Facing +X]: Attack hits defender at +X")
	assert_true(defender.vitality < defender.max_vitality, "Strike Cone [Rotated Attacker Facing +X]: Defender at +X takes damage")
	
	attacker.free()
	defender.free()

func test_pass_a_grapple_startup_and_interruption() -> void:
	# Test 1: Grapple startup initiation and facing alignment
	var atk: Fighter = Fighter.new()
	var def: Fighter = Fighter.new()
	atk.character_id = "tophiachu"
	def.character_id = "cyraxx"
	atk.load_character_data()
	def.load_character_data()
	atk.opponent = def
	def.opponent = atk
	
	atk.position = Vector3(-0.5, 0, 0)
	def.position = Vector3(0.5, 0, 0)
	def._set_state(Fighter.State.IDLE)
	
	atk._attempt_grapple(false)
	assert_true(atk.current_state == Fighter.State.GRAPPLE_STARTUP, "Grapple Startup: Attacker enters GRAPPLE_STARTUP")
	assert_true(atk.grapple_target == def, "Grapple Startup: Attacker locks target reference")
	assert_true(atk.state_timer == 0.0, "Grapple Startup: State timer initialized to 0.0")
	
	# Test 2: Clean uninterrupted grapple transitions to throw at GRAPPLE_STARTUP_DURATION
	for frame in range(12): # ~0.20s > 0.18s
		atk._physics_process(1.0 / 60.0)
		def._physics_process(1.0 / 60.0)
		
	assert_true(atk.current_state == Fighter.State.GRAPPLING_ATTACKER, "Grapple Startup: Clean startup transitions to GRAPPLING_ATTACKER")
	assert_true(def.current_state == Fighter.State.GRAPPLING_DEFENDER, "Grapple Startup: Defender transitions to GRAPPLING_DEFENDER")
	
	atk.free()
	def.free()
	
	# Test 3: Strike interruption during grapple startup
	var atk2: Fighter = Fighter.new()
	var def2: Fighter = Fighter.new()
	atk2.character_id = "tophiachu"
	def2.character_id = "cyraxx"
	atk2.load_character_data()
	def2.load_character_data()
	atk2.opponent = def2
	def2.opponent = atk2
	
	atk2.position = Vector3(-0.5, 0, 0)
	def2.position = Vector3(0.5, 0, 0)
	def2._set_state(Fighter.State.IDLE)
	
	atk2._attempt_grapple(false)
	assert_true(atk2.current_state == Fighter.State.GRAPPLE_STARTUP, "Grapple Interrupt: Attacker starts in GRAPPLE_STARTUP")
	
	# Advance 3 frames into startup (0.05s < 0.18s)
	for frame in range(3):
		atk2._physics_process(1.0 / 60.0)
		def2._physics_process(1.0 / 60.0)
	
	# Defender strikes and interrupts attacker!
	atk2.receive_damage(35.0, def2, false)
	assert_true(atk2.current_state == Fighter.State.IDLE, "Grapple Interrupt: Attacker interrupted out of GRAPPLE_STARTUP back to IDLE")
	assert_true(atk2.grapple_target == null, "Grapple Interrupt: Grapple target cleared on interrupt")
	
	# Advance further past original startup duration: verify throw NEVER occurs
	for frame in range(15):
		atk2._physics_process(1.0 / 60.0)
		def2._physics_process(1.0 / 60.0)
		
	assert_true(atk2.current_state != Fighter.State.GRAPPLING_ATTACKER, "Grapple Interrupt: Attacker does NOT execute throw after interrupt")
	assert_true(def2.current_state != Fighter.State.GRAPPLING_DEFENDER, "Grapple Interrupt: Defender was NOT thrown")
	
	atk2.free()
	def2.free()
	
	# Test 4: Reversal countering grapple startup
	var atk3: Fighter = Fighter.new()
	var def3: Fighter = Fighter.new()
	atk3.character_id = "tophiachu"
	def3.character_id = "cyraxx"
	atk3.load_character_data()
	def3.load_character_data()
	atk3.opponent = def3
	def3.opponent = atk3
	
	atk3.position = Vector3(-0.5, 0, 0)
	def3.position = Vector3(0.5, 0, 0)
	def3._set_state(Fighter.State.IDLE)
	
	atk3._attempt_grapple(false)
	assert_true(atk3.current_state == Fighter.State.GRAPPLE_STARTUP, "Grapple Reversal: Attacker enters GRAPPLE_STARTUP")
	
	# Defender inputs reversal stance during startup
	def3._set_state(Fighter.State.REVERSAL_STANCE)
	
	# Tick past startup duration (0.18s)
	for frame in range(12):
		atk3._physics_process(1.0 / 60.0)
		def3._physics_process(1.0 / 60.0)
		
	assert_true(atk3.current_state == Fighter.State.KNOCKED_DOWN, "Grapple Reversal: Attacker countered and knocked down")
	assert_true(def3.hype > 0.0, "Grapple Reversal: Defender awarded counter hype")
	
	atk3.free()
	def3.free()

func test_pass_a_simultaneous_submission_ordering() -> void:
	# Test simultaneous submission resolution across slot inversions and tree processing orders
	for invert_slots in [false, true]:
		for invert_tree in [false, true]:
			var tag: String = "[Slot%s/Tree%s]" % ["Inv" if invert_slots else "Norm", "Inv" if invert_tree else "Norm"]
			
			var manager: MatchManager = MatchManager.new()
			var p1: Fighter = Fighter.new()
			var p2: Fighter = Fighter.new()
			p1.character_id = "tophiachu"
			p2.character_id = "cyraxx"
			p1.player_index = 1
			p2.player_index = 2
			p1.load_character_data()
			p2.load_character_data()
			
			# Scene tree insertion order
			if invert_tree:
				root.add_child(p2)
				root.add_child(p1)
			else:
				root.add_child(p1)
				root.add_child(p2)
			root.add_child(manager)
			
			manager.fighter_1 = p1
			manager.fighter_2 = p2
			manager._setup_match()
			
			var atk: Fighter = p2 if invert_slots else p1
			var def: Fighter = p1 if invert_slots else p2
			
			def.current_state = Fighter.State.KNOCKED_DOWN
			atk.position = Vector3(0, 0, 0)
			def.position = Vector3(0, 0, 0.5)
			
			atk._attempt_submission(false)
			assert_true(manager.current_state == MatchManager.MatchState.SUBMISSION_ATTEMPT, "Simultaneous Submission: In SUBMISSION_ATTEMPT (%s)" % tag)
			
			# Connect match_ended monitor
			var match_ended_called: Array = [false]
			manager.match_ended.connect(func(_w, _m): match_ended_called[0] = true)
			
			# Seed legitimate below-threshold resources: vitality > 0, escape progress < 100, pressure tick due
			def.vitality = 5.0
			def.pin_escape_progress = 95.0
			atk.submission_tick_timer = 0.49 # Tick occurs at 0.50 (due on 1/60s frame)
			def.input_pin = true # Valid mash input adding 15.0 to escape progress
			
			# Process frame according to tree order
			if invert_tree:
				p2._physics_process(1.0 / 60.0)
				p1._physics_process(1.0 / 60.0)
			else:
				p1._physics_process(1.0 / 60.0)
				p2._physics_process(1.0 / 60.0)
			manager._physics_process(1.0 / 60.0)
			
			# Under ESCAPE_BREAKS policy: escape waives off tap-out, match continues
			assert_true(not match_ended_called[0], "Simultaneous Submission: match_ended NOT emitted on simultaneous escape (%s)" % tag)
			assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Simultaneous Submission: Match returns to IN_PROGRESS (%s)" % tag)
			assert_true(atk.current_state == Fighter.State.IDLE, "Simultaneous Submission: Attacker returns to IDLE (%s)" % tag)
			assert_true(def.current_state == Fighter.State.GETTING_UP, "Simultaneous Submission: Defender enters GETTING_UP (%s)" % tag)
			assert_true(def.vitality == 1.0, "Simultaneous Submission: Defender granted 1.0 HP clutch survival (%s)" % tag)
			assert_true(atk.synchronized_partner == null, "Simultaneous Submission: Attacker synchronized_partner null (%s)" % tag)
			assert_true(def.synchronized_partner == null, "Simultaneous Submission: Defender synchronized_partner null (%s)" % tag)
			
			# Assert post-result stability across subsequent ticks
			for _f in range(10):
				p1._physics_process(1.0 / 60.0)
				p2._physics_process(1.0 / 60.0)
				manager._physics_process(1.0 / 60.0)
			assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Simultaneous Submission: Match remains IN_PROGRESS over later ticks (%s)" % tag)
			assert_true(atk.current_state == Fighter.State.IDLE, "Simultaneous Submission: Attacker remains IDLE (%s)" % tag)
			assert_true(def.current_state in [Fighter.State.GETTING_UP, Fighter.State.IDLE], "Simultaneous Submission: Defender remains in legal state (%s)" % tag)
			assert_true(atk.synchronized_partner == null and def.synchronized_partner == null, "Simultaneous Submission: Pairing remains null over later ticks (%s)" % tag)
			
			manager.free()
			p1.free()
			p2.free()

	# Test alternate policy: TAPOUT_WINS with legitimate below-threshold crossing
	MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.TAPOUT_WINS
	var man_tap: MatchManager = MatchManager.new()
	var f1: Fighter = Fighter.new()
	var f2: Fighter = Fighter.new()
	f1.character_id = "tophiachu"
	f2.character_id = "cyraxx"
	f1.player_index = 1
	f2.player_index = 2
	f1.load_character_data()
	f2.load_character_data()
	root.add_child(f1)
	root.add_child(f2)
	root.add_child(man_tap)
	man_tap.fighter_1 = f1
	man_tap.fighter_2 = f2
	man_tap._setup_match()
	
	f2.current_state = Fighter.State.KNOCKED_DOWN
	f1.position = Vector3(0, 0, 0)
	f2.position = Vector3(0, 0, 0.5)
	f1._attempt_submission(false)
	
	var tapout_winner: Array = [null]
	man_tap.match_ended.connect(func(w, _m): tapout_winner[0] = w)
	
	f2.vitality = 5.0
	f2.pin_escape_progress = 95.0
	f1.submission_tick_timer = 0.49
	f2.input_pin = true
	
	f1._physics_process(1.0 / 60.0)
	f2._physics_process(1.0 / 60.0)
	man_tap._physics_process(1.0 / 60.0)
	
	assert_true(tapout_winner[0] == f1, "Simultaneous Submission [TAPOUT_WINS]: Attacker declared winner on simultaneous frame")
	assert_true(man_tap.current_state == MatchManager.MatchState.MATCH_OVER, "Simultaneous Submission [TAPOUT_WINS]: Match state is MATCH_OVER")
	assert_true(f1.current_state == Fighter.State.VICTORY, "Simultaneous Submission [TAPOUT_WINS]: Winner in VICTORY state")
	assert_true(f2.current_state == Fighter.State.DEFEATED, "Simultaneous Submission [TAPOUT_WINS]: Loser in DEFEATED state")
	assert_true(f1.synchronized_partner == null and f2.synchronized_partner == null, "Simultaneous Submission [TAPOUT_WINS]: Hold pointers cleared symmetrically")
	
	# Advance 10 ticks: assert winner and loser remain in terminal states and NEVER get up
	for _f in range(10):
		f1._physics_process(1.0 / 60.0)
		f2._physics_process(1.0 / 60.0)
		man_tap._physics_process(1.0 / 60.0)
	assert_true(man_tap.current_state == MatchManager.MatchState.MATCH_OVER, "Simultaneous Submission [TAPOUT_WINS]: Match remains MATCH_OVER over later ticks")
	assert_true(f1.current_state == Fighter.State.VICTORY, "Simultaneous Submission [TAPOUT_WINS]: Winner remains in VICTORY over later ticks")
	assert_true(f2.current_state == Fighter.State.DEFEATED, "Simultaneous Submission [TAPOUT_WINS]: Loser strictly remains in DEFEATED over later ticks (never revives)")
	assert_true(f1.synchronized_partner == null and f2.synchronized_partner == null, "Simultaneous Submission [TAPOUT_WINS]: Pairing remains null over later ticks")
	
	man_tap.free()
	f1.free()
	f2.free()
	
	# Restore default policy
	MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.ESCAPE_BREAKS

func test_pass_a_callback_state_overwrite_resilience() -> void:
	# Test Case 1: TAPOUT_WINS policy exercised through defender._execute_submission_escape() emission path
	MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.TAPOUT_WINS
	var m1: MatchManager = MatchManager.new()
	var a1: Fighter = Fighter.new()
	var d1: Fighter = Fighter.new()
	a1.character_id = "tophiachu"
	d1.character_id = "cyraxx"
	a1.load_character_data()
	d1.load_character_data()
	root.add_child(a1)
	root.add_child(d1)
	root.add_child(m1)
	m1.fighter_1 = a1
	m1.fighter_2 = d1
	m1._setup_match()
	
	d1.current_state = Fighter.State.KNOCKED_DOWN
	a1.position = Vector3(0, 0, 0)
	d1.position = Vector3(0, 0, 0.5)
	a1._attempt_submission(false)
	
	# Both conditions met on callback execution
	d1.vitality = 0.0
	d1.pin_escape_progress = 100.0
	
	# Directly invoke defender escape emission
	d1._execute_submission_escape()
	
	# Assert manager and participants immediately after callback returns
	assert_true(m1.current_state == MatchManager.MatchState.MATCH_OVER, "Callback Overwrite [TAPOUT_WINS]: Match is MATCH_OVER")
	assert_true(a1.current_state == Fighter.State.VICTORY, "Callback Overwrite [TAPOUT_WINS]: Attacker is in VICTORY")
	assert_true(d1.current_state == Fighter.State.DEFEATED, "Callback Overwrite [TAPOUT_WINS]: Defender is DEFEATED (not overwritten with GETTING_UP)")
	assert_true(a1.synchronized_partner == null and d1.synchronized_partner == null, "Callback Overwrite [TAPOUT_WINS]: Partners cleared")
	
	# Step 10 ticks: ensure defender NEVER transitions out of DEFEATED
	for _f in range(10):
		a1._physics_process(1.0 / 60.0)
		d1._physics_process(1.0 / 60.0)
		m1._physics_process(1.0 / 60.0)
	assert_true(d1.current_state == Fighter.State.DEFEATED, "Callback Overwrite [TAPOUT_WINS]: Defender remains strictly DEFEATED over later ticks")
	assert_true(m1.current_state == MatchManager.MatchState.MATCH_OVER, "Callback Overwrite [TAPOUT_WINS]: Match state remains MATCH_OVER")
	
	m1.free()
	a1.free()
	d1.free()
	
	# Test Case 2: ESCAPE_BREAKS policy exercised through defender.on_tap_out() emission path
	MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.ESCAPE_BREAKS
	var m2: MatchManager = MatchManager.new()
	var a2: Fighter = Fighter.new()
	var d2: Fighter = Fighter.new()
	a2.character_id = "tophiachu"
	d2.character_id = "cyraxx"
	a2.load_character_data()
	d2.load_character_data()
	root.add_child(a2)
	root.add_child(d2)
	root.add_child(m2)
	m2.fighter_1 = a2
	m2.fighter_2 = d2
	m2._setup_match()
	
	d2.current_state = Fighter.State.KNOCKED_DOWN
	a2.position = Vector3(0, 0, 0)
	d2.position = Vector3(0, 0, 0.5)
	a2._attempt_submission(false)
	
	# Both conditions met on callback execution
	d2.vitality = 0.0
	d2.pin_escape_progress = 100.0
	
	# Directly invoke defender tap-out emission
	d2.on_tap_out()
	
	# Assert manager and participants immediately after callback returns
	assert_true(m2.current_state == MatchManager.MatchState.IN_PROGRESS, "Callback Overwrite [ESCAPE_BREAKS]: Match remains IN_PROGRESS")
	assert_true(a2.current_state == Fighter.State.IDLE, "Callback Overwrite [ESCAPE_BREAKS]: Attacker is in IDLE")
	assert_true(d2.current_state == Fighter.State.GETTING_UP, "Callback Overwrite [ESCAPE_BREAKS]: Defender is in GETTING_UP (not overwritten with DEFEATED)")
	assert_true(d2.vitality == 1.0, "Callback Overwrite [ESCAPE_BREAKS]: Defender granted 1.0 HP clutch survival")
	assert_true(a2.synchronized_partner == null and d2.synchronized_partner == null, "Callback Overwrite [ESCAPE_BREAKS]: Partners cleared")
	
	# Step 10 ticks: ensure match remains in progress and defender recovers cleanly
	for _f in range(10):
		a2._physics_process(1.0 / 60.0)
		d2._physics_process(1.0 / 60.0)
		m2._physics_process(1.0 / 60.0)
	assert_true(m2.current_state == MatchManager.MatchState.IN_PROGRESS, "Callback Overwrite [ESCAPE_BREAKS]: Match remains IN_PROGRESS over later ticks")
	assert_true(d2.current_state in [Fighter.State.GETTING_UP, Fighter.State.IDLE], "Callback Overwrite [ESCAPE_BREAKS]: Defender in legal recovery state")
	
	m2.free()
	a2.free()
	d2.free()

func test_pass_a_final_count_escape_crossing() -> void:
	# Test real 99 -> 100+ escape threshold crossing on tick 198 (3.30s)
	# Check both manager-first and defender-first scene arrangements
	for manager_first in [true, false]:
		var tag: String = "[%s]" % ["ManagerFirst" if manager_first else "DefenderFirst"]
		
		var manager: MatchManager = MatchManager.new()
		var pinner: Fighter = Fighter.new()
		var pinned: Fighter = Fighter.new()
		pinner.character_id = "tophiachu"
		pinned.character_id = "cyraxx"
		pinner.load_character_data()
		pinned.load_character_data()
		
		if manager_first:
			root.add_child(manager)
			root.add_child(pinner)
			root.add_child(pinned)
		else:
			root.add_child(pinned)
			root.add_child(pinner)
			root.add_child(manager)
			
		manager.fighter_1 = pinner
		manager.fighter_2 = pinned
		manager._setup_match()
		
		pinned.current_state = Fighter.State.KNOCKED_DOWN
		pinner.position = Vector3(0, 0, 0)
		pinned.position = Vector3(0, 0, 0.5)
		pinner._attempt_pin()
		
		# Seed exact state at count 2, timer 3.29s (tick 197 at 60Hz), progress 99.0
		manager.current_count = 2
		manager.pin_timer = 3.29
		pinned.pin_escape_progress = 99.0
		
		var match_ended_called: Array = [false]
		manager.match_ended.connect(func(_w, _m): match_ended_called[0] = true)
		
		# Valid mash command that adds ~10.0 progress across the tick
		pinned.input_pin = true
		
		# Execute tick with priority order (pinned at priority 0 processes before manager at priority 10)
		pinned._physics_process(1.0 / 60.0)
		pinner._physics_process(1.0 / 60.0)
		manager._physics_process(1.0 / 60.0)
		
		assert_true(pinned.pin_escape_progress >= 100.0, "Final-Count Escape Crossing: Progress crossed 100 on tick (%s)" % tag)
		assert_true(not match_ended_called[0], "Final-Count Escape Crossing: match_ended was NOT emitted (%s)" % tag)
		assert_true(manager.current_count == 2, "Final-Count Escape Crossing: Count remained 2 (preempted count 3) (%s)" % tag)
		assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Final-Count Escape Crossing: Match returned to IN_PROGRESS (%s)" % tag)
		assert_true(pinned.current_state == Fighter.State.GETTING_UP, "Final-Count Escape Crossing: Defender entered GETTING_UP (%s)" % tag)
		assert_true(pinner.current_state == Fighter.State.IDLE, "Final-Count Escape Crossing: Pinner entered IDLE (%s)" % tag)
		assert_true(pinned.synchronized_partner == null and pinner.synchronized_partner == null, "Final-Count Escape Crossing: Hold cleared (%s)" % tag)
		
		# Step 10 ticks: ensure match remains in progress
		for _f in range(10):
			pinned._physics_process(1.0 / 60.0)
			pinner._physics_process(1.0 / 60.0)
			manager._physics_process(1.0 / 60.0)
		assert_true(manager.current_state == MatchManager.MatchState.IN_PROGRESS, "Final-Count Escape Crossing: Match remains IN_PROGRESS (%s)" % tag)
		
		manager.free()
		pinner.free()
		pinned.free()

func test_visual_presentation_and_skeletal_rig() -> void:
	var fighter_scene = load("res://scenes/fighter/fighter.tscn")
	assert_true(fighter_scene != null, "Presentation Test: fighter.tscn loaded")
	
	var fighter = fighter_scene.instantiate()
	root.add_child(fighter)
	fighter.load_character_data("tophiachu")
	
	assert_true(fighter.presentation != null, "Presentation Test: FighterPresentation instantiated")
	assert_true(fighter.presentation.has_skeletal_rig == true, "Presentation Test: Tophiachu has_skeletal_rig is true")
	assert_true(fighter.is_rigged() == true, "Presentation Test: Tophiachu is_rigged() reports true")
	assert_true(is_instance_valid(fighter.presentation.skeleton), "Presentation Test: Skeleton3D valid")
	assert_true(is_instance_valid(fighter.presentation.anim_player), "Presentation Test: AnimationPlayer valid")
	
	var skel: Skeleton3D = fighter.presentation.skeleton
	var expected_bones = [
		"Root", "Hips", "Spine", "Chest", "Neck", "Head",
		"Clavicle.L", "Clavicle.R", "UpperArm.L", "UpperArm.R",
		"Forearm.L", "Forearm.R", "Hand.L", "Hand.R",
		"Thigh.L", "Thigh.R", "Shin.L", "Shin.R",
		"Foot.L", "Foot.R", "Toe.L", "Toe.R"
	]
	var all_bones: bool = true
	for b in expected_bones:
		if skel.find_bone(b) == -1:
			all_bones = false
	assert_true(all_bones, "Presentation Test: All 22 canonical humanoid bones verified")
	
	var ap: AnimationPlayer = fighter.presentation.anim_player
	var expected_anims = [
		"idle", "walk", "strike", "knockdown", "getup",
		"block", "reversal", "grapple", "throw_attacker", "throw_defender",
		"pinning", "pinned", "submission_attacker", "submission_defender",
		"victory", "defeated"
	]
	var all_anims: bool = true
	for a in expected_anims:
		if not ap.has_animation(a):
			all_anims = false
	assert_true(all_anims, "Presentation Test: All 16 keyframed clips present in AnimationPlayer")
	
	# Verify looping
	assert_true(ap.get_animation("idle").loop_mode == Animation.LOOP_LINEAR, "Presentation Test: 'idle' loops linearly")
	assert_true(ap.get_animation("walk").loop_mode == Animation.LOOP_LINEAR, "Presentation Test: 'walk' loops linearly")
	
	# Verify canonical timing synchronization
	assert_true(abs(ap.get_animation("strike").length - 0.45) < 0.01, "Presentation Test: 'strike' length is 0.45s")
	assert_true(abs(ap.get_animation("getup").length - 0.60) < 0.01, "Presentation Test: 'getup' length is 0.60s")
	assert_true(abs(ap.get_animation("grapple").length - 0.183) < 0.01, "Presentation Test: 'grapple' length is ~0.183s")
	
	# Verify ground contact height (Hips on mat Y <= 0.20m, not floating 1.68m)
	ap.play("knockdown")
	ap.seek(1.0, true)
	var hips_idx = skel.find_bone("Hips")
	var kd_hips = skel.get_bone_pose_position(hips_idx)
	assert_true(kd_hips.y < 0.20, "Presentation Test: Knockdown settled hips height is on canvas (Y: %.2fm)" % kd_hips.y)
	
	# Verify visual_root guard
	fighter.current_state = Fighter.State.KNOCKED_DOWN
	fighter._play_state_animation(Fighter.State.KNOCKED_DOWN)
	assert_true(fighter.visual_root.rotation.x == 0.0, "Presentation Test: visual_root.rotation.x remains 0 on rigged fighter")
	
	# Verify unmigrated fallback
	var unmigrated = fighter_scene.instantiate()
	root.add_child(unmigrated)
	unmigrated.load_character_data("cyraxx")
	assert_true(unmigrated.presentation != null, "Presentation Test: Presentation exists for unmigrated fighter")
	assert_true(unmigrated.is_rigged() == false, "Presentation Test: Unmigrated fighter is_rigged() is false")
	
	fighter.queue_free()
	unmigrated.queue_free()




```

## File: tests/test_pin_balance_scene.gd

```gdscript
extends SceneTree

## Dedicated Scene Integration Test Suite for Pin-Balance Acceptance
## Executes actual PackedScenes (Fighter, Referee, MatchManager, CPUController)
## within real engine physics frames (await physics_frame).

var total_tests: int = 0
var passed_tests: int = 0
var failed_tests: int = 0

var fighter_scene: PackedScene = preload("res://scenes/fighter/fighter.tscn")
var referee_scene: PackedScene = preload("res://scenes/referee/referee.tscn")

func _init() -> void:
	print("==================================================")
	print("RUNNING PIN-BALANCE SCENE INTEGRATION SUITE (GODOT 4.7.2)")
	print("==================================================")
	_run_suite()

func assert_true(condition: bool, test_name: String) -> void:
	total_tests += 1
	if condition:
		passed_tests += 1
		print("[PASS] " + test_name)
	else:
		failed_tests += 1
		printerr("[FAIL] " + test_name)

func _run_suite() -> void:
	await physics_frame
	await physics_frame
	
	print("\n--- TEST GROUP 1: EMPIRICAL ORDINARY THROW -> PIN (FRESH CYRAXX) ---")
	await test_ordinary_throw_to_pin_cpu()
	await test_ordinary_throw_to_pin_mash()
	await test_ordinary_throw_to_pin_hold_entry()
	await test_ordinary_throw_to_pin_hold_preheld()
	
	print("\n--- TEST GROUP 2: GENUINE FINISHER -> PIN (WEAKENED CYRAXX) ---")
	await test_finisher_throw_to_pin_cpu_weakened()
	await test_finisher_throw_to_pin_mash_weakened()
	await test_finisher_throw_to_pin_hold_entry_weakened()
	await test_finisher_throw_to_pin_hold_preheld_weakened()
	
	print("\n--- TEST GROUP 3: FINAL-TICK (TICK 198 / 3.30s) PRIORITY RESOLUTION ---")
	await test_final_tick_kickout_priority(false, false) # P1 pinner, P2 pinned, Normal order
	await test_final_tick_kickout_priority(true, false)  # P2 pinner, P1 pinned, Normal order
	await test_final_tick_kickout_priority(false, true)  # P1 pinner, P2 pinned, Inverted tree order
	await test_final_tick_kickout_priority(true, true)   # P2 pinner, P1 pinned, Inverted tree order
	await test_final_tick_rope_break_priority(false, false)
	await test_final_tick_rope_break_priority(true, false)
	await test_final_tick_rope_break_priority(false, true)
	await test_final_tick_rope_break_priority(true, true)
	await test_duplicate_match_end_guard()
	
	print("\n--- TEST GROUP 4: REAL-SCENE SIMULTANEOUS SUBMISSION & CALLBACK OVERWRITE RESILIENCE ---")
	await test_scene_simultaneous_submission(false, false)
	await test_scene_simultaneous_submission(true, false)
	await test_scene_simultaneous_submission(false, true)
	await test_scene_simultaneous_submission(true, true)
	await test_scene_simultaneous_submission_tapout_wins()
	await test_scene_callback_overwrite_resilience()
	
	print("\n==================================================")
	print("SCENE INTEGRATION RESULTS: %d Passed, %d Failed, %d Total" % [passed_tests, failed_tests, total_tests])
	print("==================================================")
	
	quit(1 if failed_tests > 0 else 0)

# ==============================================================================
# Helper Setup
# ==============================================================================

func _setup_test_scene(p1_char: String = "tophiachu", p2_char: String = "cyraxx", invert_tree: bool = false) -> Dictionary:
	var container: Node3D = Node3D.new()
	container.name = "TestSceneContainer"
	root.add_child(container)
	
	var mm: MatchManager = MatchManager.new()
	var p1: Fighter = fighter_scene.instantiate() as Fighter
	var p2: Fighter = fighter_scene.instantiate() as Fighter
	var ref: Referee = referee_scene.instantiate() as Referee
	var cpu: CPUController = CPUController.new()
	
	p1.character_id = p1_char
	p1.player_index = 1
	p1.is_cpu = false
	p1.position = Vector3(-0.6, 0, 0)
	
	p2.character_id = p2_char
	p2.player_index = 2
	p2.is_cpu = false
	p2.position = Vector3(0.6, 0, 0)
	
	ref.position = Vector3(0, 0, -2.0)
	
	mm.fighter_1 = p1
	mm.fighter_2 = p2
	mm.referee = ref
	
	if invert_tree:
		container.add_child(mm)
		container.add_child(p2)
		container.add_child(p1)
		container.add_child(ref)
		container.add_child(cpu)
	else:
		container.add_child(p1)
		container.add_child(p2)
		container.add_child(ref)
		container.add_child(cpu)
		container.add_child(mm)
		
	p1.opponent = p2
	p2.opponent = p1
	cpu.fighter = p2
	
	mm._setup_match()
	
	return {
		"container": container,
		"mm": mm,
		"p1": p1,
		"p2": p2,
		"ref": ref,
		"cpu": cpu
	}

func _cleanup_scene(ctx: Dictionary) -> void:
	Input.action_release("p1_pin")
	Input.action_release("p2_pin")
	if ctx.has("container") and is_instance_valid(ctx["container"]):
		ctx["container"].queue_free()
	await physics_frame
	await physics_frame

# ==============================================================================
# Group 1: Ordinary Tophiachu Throw -> Center Pin on Fresh Cyraxx
# ==============================================================================

func test_ordinary_throw_to_pin_cpu() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p1._start_synchronized_throw(p2)
	assert_true(p1.current_state == Fighter.State.GRAPPLING_ATTACKER, "Ordinary Throw: Tophiachu enters GRAPPLING_ATTACKER")
	assert_true(p2.current_state == Fighter.State.GRAPPLING_DEFENDER, "Ordinary Throw: Cyraxx enters GRAPPLING_DEFENDER")
	
	for i in range(70):
		await physics_frame
		
	assert_true(p1.current_state == Fighter.State.IDLE, "Ordinary Throw: Tophiachu returns to IDLE after throw")
	assert_true(p2.current_state == Fighter.State.KNOCKED_DOWN, "Ordinary Throw: Cyraxx knocked down on canvas")
	
	assert_true(p2.vitality < 850.0 and p2.vitality >= 660.0, "Ordinary Throw: Cyraxx HP reduced by ~177 damage (Observed HP: %.1f/850)" % p2.vitality)
	assert_true(p2.recent_finisher_impact_timer == 0.0, "Ordinary Throw: Move metadata ensures finisher disorientation is strictly 0.0")
	assert_true(p2.recent_heavy_impact_timer > 0.0, "Ordinary Throw: Ordinary heavy impact timer active for 1.5s")
	
	p2.is_cpu = true
	var pin_outcome: Array = ["NONE"]
	var recorded_count: Array = [0]
	mm.pin_broken.connect(func(r): pin_outcome[0] = r)
	mm.pin_count_ticked.connect(func(c): recorded_count[0] = c)
	
	p1._start_pin(p2)
	assert_true(mm.current_state == MatchManager.MatchState.PIN_ATTEMPT, "Ordinary Throw -> Pin: Match state is PIN_ATTEMPT")
	
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		await physics_frame
		frame_count += 1
		
	assert_true(pin_outcome[0] == "KICKOUT", "Ordinary Throw -> Pin [Mode 1 CPU]: Fresh Cyraxx kicks out via CPU commands")
	assert_true(recorded_count[0] <= 1, "Ordinary Throw -> Pin [Mode 1 CPU]: Kickout occurs before Count 2 (Count reached: %d, time: %.2fs)" % [recorded_count[0], frame_count / 60.0])
	
	await _cleanup_scene(ctx)

func test_ordinary_throw_to_pin_mash() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p1._start_synchronized_throw(p2)
	for i in range(70):
		await physics_frame
		
	p2.is_cpu = false
	var pin_outcome: Array = ["NONE"]
	var recorded_count: Array = [0]
	mm.pin_broken.connect(func(r): pin_outcome[0] = r)
	mm.pin_count_ticked.connect(func(c): recorded_count[0] = c)
	
	p1._start_pin(p2)
	
	# Simulate human 10 Hz mashing via Godot input action system
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		if frame_count % 6 == 0:
			Input.action_press("p2_pin")
		else:
			Input.action_release("p2_pin")
		await physics_frame
		frame_count += 1
	Input.action_release("p2_pin")
		
	assert_true(pin_outcome[0] == "KICKOUT", "Ordinary Throw -> Pin [Mode 2 Mash]: Fresh Cyraxx kicks out via 10 Hz mashing")
	assert_true(recorded_count[0] <= 1, "Ordinary Throw -> Pin [Mode 2 Mash]: Kickout occurs before Count 2 (Count reached: %d, time: %.2fs)" % [recorded_count[0], frame_count / 60.0])
	
	await _cleanup_scene(ctx)

func test_ordinary_throw_to_pin_hold_entry() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p1._start_synchronized_throw(p2)
	for i in range(70):
		await physics_frame
		
	p2.is_cpu = false
	var pin_outcome: Array = ["NONE"]
	var recorded_count: Array = [0]
	mm.pin_broken.connect(func(r): pin_outcome[0] = r)
	mm.pin_count_ticked.connect(func(c): recorded_count[0] = c)
	
	p1._start_pin(p2)
	
	# Hold-to-resist pressed right on pin entry
	Input.action_press("p2_pin")
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		await physics_frame
		frame_count += 1
	Input.action_release("p2_pin")
		
	assert_true(pin_outcome[0] == "KICKOUT", "Ordinary Throw -> Pin [Mode 3 Hold On Entry]: Fresh Cyraxx kicks out via hold-to-resist")
	assert_true(recorded_count[0] <= 1, "Ordinary Throw -> Pin [Mode 3 Hold On Entry]: Kickout occurs before Count 2 (Count reached: %d, time: %.2fs)" % [recorded_count[0], frame_count / 60.0])
	
	await _cleanup_scene(ctx)

func test_ordinary_throw_to_pin_hold_preheld() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p1._start_synchronized_throw(p2)
	for i in range(70):
		await physics_frame
		
	p2.is_cpu = false
	var pin_outcome: Array = ["NONE"]
	var recorded_count: Array = [0]
	mm.pin_broken.connect(func(r): pin_outcome[0] = r)
	mm.pin_count_ticked.connect(func(c): recorded_count[0] = c)
	
	# Button already held BEFORE pin begins
	Input.action_press("p2_pin")
	await physics_frame
	
	p1._start_pin(p2)
	
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		await physics_frame
		frame_count += 1
	Input.action_release("p2_pin")
		
	assert_true(pin_outcome[0] == "KICKOUT", "Ordinary Throw -> Pin [Mode 4 Pre-Held]: Fresh Cyraxx kicks out via pre-held hold-to-resist")
	assert_true(recorded_count[0] <= 1, "Ordinary Throw -> Pin [Mode 4 Pre-Held]: Kickout occurs before Count 2 (Count reached: %d, time: %.2fs)" % [recorded_count[0], frame_count / 60.0])
	
	await _cleanup_scene(ctx)

# ==============================================================================
# Group 2: Genuine Finisher -> Center Pin on Weakened Defender
# ==============================================================================

func test_finisher_throw_to_pin_cpu_weakened() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p2.vitality = 150.0
	p2.stamina = 12.0
	p1.hype = 100.0
	
	p1._attempt_grapple(true)
	assert_true(p1.is_finisher_attack, "Genuine Finisher: is_finisher_attack flag is true")
	
	for i in range(85):
		await physics_frame
		
	assert_true(p2.recent_finisher_impact_timer > 0.0, "Genuine Finisher: Cyraxx has active 4.5s finisher disorientation (%.2fs)" % p2.recent_finisher_impact_timer)
	
	p2.is_cpu = true
	var match_outcome: Array = ["NONE"]
	mm.match_ended.connect(func(_w, m): match_outcome[0] = m)
	
	p1._start_pin(p2)
	
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		await physics_frame
		frame_count += 1
		
	assert_true(match_outcome[0] == "PINFALL (3-COUNT)", "Finisher -> Pin [Mode 1 CPU]: Weakened Cyraxx loses by 3-count pinfall")
	await _cleanup_scene(ctx)

func test_finisher_throw_to_pin_mash_weakened() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p2.vitality = 150.0
	p2.stamina = 12.0
	p1.hype = 100.0
	p1._attempt_grapple(true)
	
	for i in range(85):
		await physics_frame
		
	p2.is_cpu = false
	var match_outcome: Array = ["NONE"]
	mm.match_ended.connect(func(_w, m): match_outcome[0] = m)
	
	p1._start_pin(p2)
	
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		if frame_count % 6 == 0:
			Input.action_press("p2_pin")
		else:
			Input.action_release("p2_pin")
		await physics_frame
		frame_count += 1
	Input.action_release("p2_pin")
		
	assert_true(match_outcome[0] == "PINFALL (3-COUNT)", "Finisher -> Pin [Mode 2 Mash]: Weakened Cyraxx loses by 3-count pinfall despite 10 Hz mashing")
	await _cleanup_scene(ctx)

func test_finisher_throw_to_pin_hold_entry_weakened() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p2.vitality = 150.0
	p2.stamina = 12.0
	p1.hype = 100.0
	p1._attempt_grapple(true)
	
	for i in range(85):
		await physics_frame
		
	p2.is_cpu = false
	var match_outcome: Array = ["NONE"]
	mm.match_ended.connect(func(_w, m): match_outcome[0] = m)
	
	p1._start_pin(p2)
	
	Input.action_press("p2_pin")
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		await physics_frame
		frame_count += 1
	Input.action_release("p2_pin")
		
	assert_true(match_outcome[0] == "PINFALL (3-COUNT)", "Finisher -> Pin [Mode 3 Hold Entry]: Weakened Cyraxx loses by 3-count pinfall")
	await _cleanup_scene(ctx)

func test_finisher_throw_to_pin_hold_preheld_weakened() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	p2.vitality = 150.0
	p2.stamina = 12.0
	p1.hype = 100.0
	p1._attempt_grapple(true)
	
	for i in range(85):
		await physics_frame
		
	p2.is_cpu = false
	Input.action_press("p2_pin")
	await physics_frame
	
	var match_outcome: Array = ["NONE"]
	mm.match_ended.connect(func(_w, m): match_outcome[0] = m)
	
	p1._start_pin(p2)
	
	var frame_count: int = 0
	while mm.current_state == MatchManager.MatchState.PIN_ATTEMPT and frame_count < 240:
		await physics_frame
		frame_count += 1
	Input.action_release("p2_pin")
		
	assert_true(match_outcome[0] == "PINFALL (3-COUNT)", "Finisher -> Pin [Mode 4 Pre-Held]: Weakened Cyraxx loses by 3-count pinfall")
	await _cleanup_scene(ctx)

# ==============================================================================
# Group 3: Final-Tick (Tick 198 / 3.30s) Priority Fixtures
# ==============================================================================

func test_final_tick_kickout_priority(invert_slots: bool, invert_tree: bool) -> void:
	var ctx: Dictionary = _setup_test_scene("tophiachu", "cyraxx", invert_tree)
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	var pinner: Fighter = p2 if invert_slots else p1
	var pinned: Fighter = p1 if invert_slots else p2
	var pinned_action: String = "p1_pin" if invert_slots else "p2_pin"
	
	await physics_frame
	
	pinned.vitality = 300.0
	pinned.stamina = 20.0
	pinned.is_cpu = false
	
	pinner._start_pin(pinned)
	
	var broken_reason: Array = ["NONE"]
	var match_ended_called: Array = [false]
	mm.pin_broken.connect(func(r): broken_reason[0] = r)
	mm.match_ended.connect(func(_w, _m): match_ended_called[0] = true)
	
	# Advance precisely to tick 197 (Count is 2)
	for frame in range(197):
		await physics_frame
		
	assert_true(mm.current_count == 2, "Final-Tick Kickout [%s/%s]: Count is 2 before tick 198" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	
	# On tick 198, defender reaches kick-out threshold 100.0 with active input
	pinned.pin_escape_progress = 100.0
	Input.action_press(pinned_action)
	
	# Tick 198 (3.30s)
	await physics_frame
	Input.action_release(pinned_action)
	
	assert_true(broken_reason[0] == "KICKOUT", "Final-Tick Kickout [%s/%s]: Escape takes priority over 3-count" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	assert_true(not match_ended_called[0], "Final-Tick Kickout [%s/%s]: match_ended is NOT emitted" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	assert_true(mm.current_state == MatchManager.MatchState.IN_PROGRESS, "Final-Tick Kickout [%s/%s]: Match returns to IN_PROGRESS" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	
	await _cleanup_scene(ctx)

func test_final_tick_rope_break_priority(invert_slots: bool, invert_tree: bool) -> void:
	var ctx: Dictionary = _setup_test_scene("tophiachu", "cyraxx", invert_tree)
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	var pinner: Fighter = p2 if invert_slots else p1
	var pinned: Fighter = p1 if invert_slots else p2
	
	await physics_frame
	pinned.vitality = 0.0
	pinned.stamina = 0.0
	
	pinner._start_pin(pinned)
	
	var rope_break_called: Array = [false]
	var match_ended_called: Array = [false]
	mm.rope_break_called.connect(func(): rope_break_called[0] = true)
	mm.match_ended.connect(func(_w, _m): match_ended_called[0] = true)
	
	# Advance precisely to tick 197
	for frame in range(197):
		await physics_frame
		
	assert_true(mm.current_count == 2, "Final-Tick RopeBreak [%s/%s]: Count is 2 before tick 198" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	
	# On tick 198, pinned fighter touches rope threshold
	pinned.position = Vector3(3.25, 0, 0)
	
	# Tick 198 (3.30s)
	await physics_frame
	
	assert_true(rope_break_called[0], "Final-Tick RopeBreak [%s/%s]: Rope break takes priority over 3-count" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	assert_true(not match_ended_called[0], "Final-Tick RopeBreak [%s/%s]: match_ended is NOT emitted" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	assert_true(mm.current_state == MatchManager.MatchState.IN_PROGRESS, "Final-Tick RopeBreak [%s/%s]: Match returns to IN_PROGRESS" % [
		"SlotInv" if invert_slots else "SlotNorm",
		"TreeInv" if invert_tree else "TreeNorm"
	])
	
	await _cleanup_scene(ctx)

func test_duplicate_match_end_guard() -> void:
	var ctx: Dictionary = _setup_test_scene()
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	var call_count: Array = [0]
	mm.match_ended.connect(func(_w, _m): call_count[0] += 1)
	
	mm._end_match(p1, "PINFALL (3-COUNT)")
	mm._end_match(p2, "PINFALL (3-COUNT)")
	
	assert_true(call_count[0] == 1, "Duplicate Guard: match_ended signal emitted strictly once")
	assert_true(mm.current_state == MatchManager.MatchState.MATCH_OVER, "Duplicate Guard: MatchState remains MATCH_OVER")
	
	await _cleanup_scene(ctx)

# ==============================================================================
# Group 4: Real-Scene Simultaneous Submission & Callback Overwrite Resilience
# ==============================================================================

func test_scene_simultaneous_submission(invert_slots: bool, invert_tree: bool) -> void:
	var ctx: Dictionary = _setup_test_scene("tophiachu", "cyraxx", invert_tree)
	var p1: Fighter = ctx["p1"]
	var p2: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	var atk: Fighter = p2 if invert_slots else p1
	var def: Fighter = p1 if invert_slots else p2
	var def_action: String = "p1_pin" if invert_slots else "p2_pin"
	var tag: String = "[Slot%s/Tree%s]" % ["Inv" if invert_slots else "Norm", "Inv" if invert_tree else "Norm"]
	
	await physics_frame
	
	def.current_state = Fighter.State.KNOCKED_DOWN
	atk.position = Vector3(0, 0, 0)
	def.position = Vector3(0, 0, 0.5)
	
	atk._attempt_submission(false)
	assert_true(mm.current_state == MatchManager.MatchState.SUBMISSION_ATTEMPT, "Scene Simul Submission: Enters SUBMISSION_ATTEMPT (%s)" % tag)
	
	var match_ended_called: Array = [false]
	mm.match_ended.connect(func(_w, _m): match_ended_called[0] = true)
	
	# Seed legitimate below-threshold values
	def.vitality = 5.0
	def.pin_escape_progress = 95.0
	atk.submission_tick_timer = 0.49
	Input.action_press(def_action)
	
	await physics_frame
	Input.action_release(def_action)
	
	# Under ESCAPE_BREAKS: escape waives off tap-out
	assert_true(not match_ended_called[0], "Scene Simul Submission: match_ended NOT emitted (%s)" % tag)
	assert_true(mm.current_state == MatchManager.MatchState.IN_PROGRESS, "Scene Simul Submission: Match returns to IN_PROGRESS (%s)" % tag)
	assert_true(atk.current_state == Fighter.State.IDLE, "Scene Simul Submission: Attacker returns to IDLE (%s)" % tag)
	assert_true(def.current_state == Fighter.State.GETTING_UP, "Scene Simul Submission: Defender enters GETTING_UP (%s)" % tag)
	assert_true(def.vitality == 1.0, "Scene Simul Submission: Defender granted 1.0 HP clutch survival (%s)" % tag)
	assert_true(atk.synchronized_partner == null, "Scene Simul Submission: Attacker partner null (%s)" % tag)
	assert_true(def.synchronized_partner == null, "Scene Simul Submission: Defender partner null (%s)" % tag)
	
	# Advance 10 real physics frames to confirm state stability
	for frame in range(10):
		await physics_frame
	assert_true(mm.current_state == MatchManager.MatchState.IN_PROGRESS, "Scene Simul Submission: Remains IN_PROGRESS over later frames (%s)" % tag)
	assert_true(atk.current_state == Fighter.State.IDLE, "Scene Simul Submission: Attacker remains IDLE (%s)" % tag)
	assert_true(def.current_state in [Fighter.State.GETTING_UP, Fighter.State.IDLE], "Scene Simul Submission: Defender remains in legal state (%s)" % tag)
	assert_true(atk.synchronized_partner == null and def.synchronized_partner == null, "Scene Simul Submission: Pointers remain null (%s)" % tag)
	
	await _cleanup_scene(ctx)

func test_scene_simultaneous_submission_tapout_wins() -> void:
	MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.TAPOUT_WINS
	
	var ctx: Dictionary = _setup_test_scene("tophiachu", "cyraxx", false)
	var atk: Fighter = ctx["p1"]
	var def: Fighter = ctx["p2"]
	var mm: MatchManager = ctx["mm"]
	
	await physics_frame
	
	def.current_state = Fighter.State.KNOCKED_DOWN
	atk.position = Vector3(0, 0, 0)
	def.position = Vector3(0, 0, 0.5)
	
	atk._attempt_submission(false)
	
	var tapout_winner: Array = [null]
	mm.match_ended.connect(func(w, _m): tapout_winner[0] = w)
	
	def.vitality = 5.0
	def.pin_escape_progress = 95.0
	atk.submission_tick_timer = 0.49
	Input.action_press("p2_pin")
	
	await physics_frame
	Input.action_release("p2_pin")
	
	assert_true(tapout_winner[0] == atk, "Scene Simul Submission [TAPOUT_WINS]: Attacker declared winner")
	assert_true(mm.current_state == MatchManager.MatchState.MATCH_OVER, "Scene Simul Submission [TAPOUT_WINS]: Match is MATCH_OVER")
	assert_true(atk.current_state == Fighter.State.VICTORY, "Scene Simul Submission [TAPOUT_WINS]: Attacker is in VICTORY")
	assert_true(def.current_state == Fighter.State.DEFEATED, "Scene Simul Submission [TAPOUT_WINS]: Defender is DEFEATED")
	assert_true(atk.synchronized_partner == null and def.synchronized_partner == null, "Scene Simul Submission [TAPOUT_WINS]: Partners cleared")
	
	# Step 10 frames: ensure defender NEVER gets up
	for frame in range(10):
		await physics_frame
	assert_true(mm.current_state == MatchManager.MatchState.MATCH_OVER, "Scene Simul Submission [TAPOUT_WINS]: Match remains MATCH_OVER")
	assert_true(atk.current_state == Fighter.State.VICTORY, "Scene Simul Submission [TAPOUT_WINS]: Winner remains in VICTORY")
	assert_true(def.current_state == Fighter.State.DEFEATED, "Scene Simul Submission [TAPOUT_WINS]: Loser strictly remains in DEFEATED")
	assert_true(atk.synchronized_partner == null and def.synchronized_partner == null, "Scene Simul Submission [TAPOUT_WINS]: Pairing remains null")
	
	await _cleanup_scene(ctx)
	MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.ESCAPE_BREAKS

func test_scene_callback_overwrite_resilience() -> void:
	# Part 1: TAPOUT_WINS with direct _execute_submission_escape() invocation
	MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.TAPOUT_WINS
	var ctx1: Dictionary = _setup_test_scene("tophiachu", "cyraxx", false)
	var a1: Fighter = ctx1["p1"]
	var d1: Fighter = ctx1["p2"]
	var m1: MatchManager = ctx1["mm"]
	
	await physics_frame
	d1.current_state = Fighter.State.KNOCKED_DOWN
	a1.position = Vector3(0, 0, 0)
	d1.position = Vector3(0, 0, 0.5)
	a1._attempt_submission(false)
	
	d1.vitality = 0.0
	d1.pin_escape_progress = 100.0
	d1._execute_submission_escape()
	
	assert_true(m1.current_state == MatchManager.MatchState.MATCH_OVER, "Scene Callback Overwrite [TAPOUT_WINS]: Match is MATCH_OVER")
	assert_true(a1.current_state == Fighter.State.VICTORY, "Scene Callback Overwrite [TAPOUT_WINS]: Attacker is in VICTORY")
	assert_true(d1.current_state == Fighter.State.DEFEATED, "Scene Callback Overwrite [TAPOUT_WINS]: Defender is DEFEATED")
	assert_true(a1.synchronized_partner == null and d1.synchronized_partner == null, "Scene Callback Overwrite [TAPOUT_WINS]: Partners cleared")
	
	for frame in range(10):
		await physics_frame
	assert_true(d1.current_state == Fighter.State.DEFEATED, "Scene Callback Overwrite [TAPOUT_WINS]: Defender strictly remains DEFEATED over later frames")
	assert_true(m1.current_state == MatchManager.MatchState.MATCH_OVER, "Scene Callback Overwrite [TAPOUT_WINS]: Match remains MATCH_OVER")
	
	await _cleanup_scene(ctx1)
	
	# Part 2: ESCAPE_BREAKS with direct on_tap_out() invocation
	MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.ESCAPE_BREAKS
	var ctx2: Dictionary = _setup_test_scene("tophiachu", "cyraxx", false)
	var a2: Fighter = ctx2["p1"]
	var d2: Fighter = ctx2["p2"]
	var m2: MatchManager = ctx2["mm"]
	
	await physics_frame
	d2.current_state = Fighter.State.KNOCKED_DOWN
	a2.position = Vector3(0, 0, 0)
	d2.position = Vector3(0, 0, 0.5)
	a2._attempt_submission(false)
	
	d2.vitality = 0.0
	d2.pin_escape_progress = 100.0
	d2.on_tap_out()
	
	assert_true(m2.current_state == MatchManager.MatchState.IN_PROGRESS, "Scene Callback Overwrite [ESCAPE_BREAKS]: Match remains IN_PROGRESS")
	assert_true(a2.current_state == Fighter.State.IDLE, "Scene Callback Overwrite [ESCAPE_BREAKS]: Attacker is IDLE")
	assert_true(d2.current_state == Fighter.State.GETTING_UP, "Scene Callback Overwrite [ESCAPE_BREAKS]: Defender is GETTING_UP")
	assert_true(d2.vitality == 1.0, "Scene Callback Overwrite [ESCAPE_BREAKS]: Defender clutch 1.0 HP survival")
	assert_true(a2.synchronized_partner == null and d2.synchronized_partner == null, "Scene Callback Overwrite [ESCAPE_BREAKS]: Partners cleared")
	
	for frame in range(10):
		await physics_frame
	assert_true(m2.current_state == MatchManager.MatchState.IN_PROGRESS, "Scene Callback Overwrite [ESCAPE_BREAKS]: Remains IN_PROGRESS over later frames")
	assert_true(d2.current_state in [Fighter.State.GETTING_UP, Fighter.State.IDLE], "Scene Callback Overwrite [ESCAPE_BREAKS]: Legal recovery state")
	
	await _cleanup_scene(ctx2)

```

## File: blender/build_skinned_character.py

```python
# Blender 5.0 Skinned Character & Animation Generator for Tophiachu
# Specialized production script for LOLCOW WRESTLING: OFFLINE MAYHEM
import bpy
import bmesh
import math
from mathutils import Vector, Euler

def clear_scene():
    bpy.ops.wm.read_factory_settings(use_empty=True)

def create_material(name, diffuse_color, roughness=0.5, metallic=0.0):
    mat = bpy.data.materials.new(name=name)
    mat.use_nodes = True
    nodes = mat.node_tree.nodes
    bsdf = nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs['Base Color'].default_value = diffuse_color
        bsdf.inputs['Roughness'].default_value = roughness
        bsdf.inputs['Metallic'].default_value = metallic
    return mat

def build_humanoid_armature():
    arm_data = bpy.data.armatures.new("TophiachuArmature")
    arm_obj = bpy.data.objects.new("TophiachuArmature", arm_data)
    bpy.context.collection.objects.link(arm_obj)
    bpy.context.view_layer.objects.active = arm_obj
    
    bpy.ops.object.mode_set(mode='EDIT')
    eb = arm_data.edit_bones
    
    # Floor Root
    root = eb.new("Root")
    root.head = (0, 0, 0)
    root.tail = (0, 0, 0.1)
    
    # Pelvis / Hips
    hips = eb.new("Hips")
    hips.head = (0, 0, 0.88)
    hips.tail = (0, 0, 1.04)
    hips.parent = root
    
    # Spine & Torso
    spine = eb.new("Spine")
    spine.head = (0, 0, 1.04)
    spine.tail = (0, 0, 1.24)
    spine.parent = hips
    
    chest = eb.new("Chest")
    chest.head = (0, 0, 1.24)
    chest.tail = (0, 0, 1.46)
    chest.parent = spine
    
    # Neck & Head
    neck = eb.new("Neck")
    neck.head = (0, 0, 1.46)
    neck.tail = (0, 0, 1.56)
    neck.parent = chest
    
    head = eb.new("Head")
    head.head = (0, 0, 1.56)
    head.tail = (0, 0, 1.82)
    head.parent = neck
    
    # Shoulders & Arms
    for side, sign in [("L", 1.0), ("R", -1.0)]:
        clav = eb.new(f"Clavicle.{side}")
        clav.head = (sign * 0.05, 0, 1.42)
        clav.tail = (sign * 0.22, 0, 1.40)
        clav.parent = chest
        
        upper_arm = eb.new(f"UpperArm.{side}")
        upper_arm.head = (sign * 0.24, 0, 1.38)
        upper_arm.tail = (sign * 0.44, 0, 1.14)
        upper_arm.parent = clav
        
        forearm = eb.new(f"Forearm.{side}")
        forearm.head = (sign * 0.44, 0, 1.14)
        forearm.tail = (sign * 0.54, 0, 0.88)
        forearm.parent = upper_arm
        
        hand = eb.new(f"Hand.{side}")
        hand.head = (sign * 0.54, 0, 0.88)
        hand.tail = (sign * 0.58, 0, 0.74)
        hand.parent = forearm
        
    # Legs & Feet
    for side, sign in [("L", 1.0), ("R", -1.0)]:
        thigh = eb.new(f"Thigh.{side}")
        thigh.head = (sign * 0.18, 0, 0.88)
        thigh.tail = (sign * 0.18, 0, 0.50)
        thigh.parent = hips
        
        shin = eb.new(f"Shin.{side}")
        shin.head = (sign * 0.18, 0, 0.50)
        shin.tail = (sign * 0.18, 0, 0.12)
        shin.parent = thigh
        
        foot = eb.new(f"Foot.{side}")
        foot.head = (sign * 0.18, 0, 0.12)
        foot.tail = (sign * 0.18, -0.16, 0.03)
        foot.parent = shin
        
        toe = eb.new(f"Toe.{side}")
        toe.head = (sign * 0.18, -0.16, 0.03)
        toe.tail = (sign * 0.18, -0.24, 0.01)
        toe.parent = foot

    bpy.ops.object.mode_set(mode='OBJECT')
    return arm_obj

def build_character_mesh(arm_obj):
    # Materials
    mat_skin = create_material("SkinTophiachu", (0.58, 0.40, 0.30, 1.0), roughness=0.65)
    mat_hair = create_material("HairTophiachu", (0.14, 0.09, 0.06, 1.0), roughness=0.85)
    mat_outfit = create_material("OutfitTophiachu", (0.38, 0.16, 0.48, 1.0), roughness=0.45)
    mat_trim = create_material("TrimTophiachu", (0.08, 0.08, 0.10, 1.0), roughness=0.50)
    mat_boots = create_material("BootsTophiachu", (0.08, 0.08, 0.09, 1.0), roughness=0.35)
    mat_wraps = create_material("WrapsTophiachu", (0.88, 0.88, 0.90, 1.0), roughness=0.80)
    mat_eyes = create_material("EyesTophiachu", (0.95, 0.95, 0.95, 1.0), roughness=0.20)
    
    mesh_data = bpy.data.meshes.new("TophiachuMesh")
    mesh_obj = bpy.data.objects.new("TophiachuMesh", mesh_data)
    bpy.context.collection.objects.link(mesh_obj)
    
    mesh_obj.data.materials.append(mat_skin)    # 0
    mesh_obj.data.materials.append(mat_outfit)  # 1
    mesh_obj.data.materials.append(mat_trim)    # 2
    mesh_obj.data.materials.append(mat_hair)    # 3
    mesh_obj.data.materials.append(mat_boots)   # 4
    mesh_obj.data.materials.append(mat_wraps)   # 5
    mesh_obj.data.materials.append(mat_eyes)    # 6
    
    bm = bmesh.new()
    
    # 1. Heavyweight Torso (Hips to Shoulders)
    torso_slices = [
        (0.86, 0.36, 0.28, 1), # lower hips
        (0.96, 0.40, 0.30, 1), # hips peak
        (1.08, 0.38, 0.29, 1), # lower waist
        (1.18, 0.36, 0.28, 1), # mid waist
        (1.28, 0.39, 0.30, 1), # lower chest
        (1.38, 0.42, 0.31, 1), # chest peak
        (1.46, 0.35, 0.25, 2), # upper chest / neckline trim
    ]
    num_seg = 16
    torso_rings = []
    prev_ring = None
    
    for z, rx, ry, m_idx in torso_slices:
        current_ring = []
        for i in range(num_seg):
            angle = 2.0 * math.pi * i / num_seg
            vx = math.cos(angle) * rx
            vy = math.sin(angle) * ry
            vert = bm.verts.new((vx, vy, z))
            current_ring.append(vert)
        if prev_ring:
            for i in range(num_seg):
                ni = (i + 1) % num_seg
                f = bm.faces.new([prev_ring[i], prev_ring[ni], current_ring[ni], current_ring[i]])
                f.material_index = m_idx
        prev_ring = current_ring
        torso_rings.append(current_ring)
        
    # Cap bottom of hips
    bottom_center = bm.verts.new((0, 0, 0.86))
    first_ring = torso_rings[0]
    for i in range(num_seg):
        ni = (i + 1) % num_seg
        f = bm.faces.new([bottom_center, first_ring[ni], first_ring[i]])
        f.material_index = 1
        
    # 2. Neck
    neck_slices = [
        (1.46, 0.16, 0.15, 0),
        (1.52, 0.14, 0.13, 0),
        (1.58, 0.15, 0.14, 0),
    ]
    prev_neck = None
    for z, rx, ry, m_idx in neck_slices:
        current_ring = []
        for i in range(12):
            angle = 2.0 * math.pi * i / 12
            vx = math.cos(angle) * rx
            vy = math.sin(angle) * ry
            vert = bm.verts.new((vx, vy, z))
            current_ring.append(vert)
        if prev_neck:
            for i in range(12):
                ni = (i + 1) % 12
                f = bm.faces.new([prev_neck[i], prev_neck[ni], current_ring[ni], current_ring[i]])
                f.material_index = m_idx
        prev_neck = current_ring
        
    # 3. Head with Facial Structure
    head_slices = [
        (1.58, 0.17, 0.16, 0), # Jawline / Chin
        (1.64, 0.22, 0.21, 0), # Mouth & Cheeks
        (1.70, 0.23, 0.22, 0), # Nose bridge & Eyes
        (1.76, 0.22, 0.21, 0), # Brow & Forehead
        (1.82, 0.18, 0.18, 0), # Cranium top
        (1.86, 0.08, 0.08, 0), # Crown
    ]
    prev_head = None
    head_rings = []
    for z, rx, ry, m_idx in head_slices:
        current_ring = []
        for i in range(16):
            angle = 2.0 * math.pi * i / 16
            vx = math.cos(angle) * rx
            vy = math.sin(angle) * ry
            # Forward protrusion for nose / chin at front (negative Y)
            if angle > math.pi * 1.25 and angle < math.pi * 1.75:
                if 1.62 <= z <= 1.72:
                    vy -= 0.04 # Nose protrusion
                elif z < 1.62:
                    vy -= 0.025 # Chin protrusion
            vert = bm.verts.new((vx, vy, z))
            current_ring.append(vert)
        if prev_head:
            for i in range(16):
                ni = (i + 1) % 16
                f = bm.faces.new([prev_head[i], prev_head[ni], current_ring[ni], current_ring[i]])
                f.material_index = m_idx
        prev_head = current_ring
        head_rings.append(current_ring)
        
    # Top head cap
    top_center = bm.verts.new((0, 0, 1.88))
    last_head_ring = head_rings[-1]
    for i in range(len(last_head_ring)):
        ni = (i + 1) % len(last_head_ring)
        f = bm.faces.new([last_head_ring[i], last_head_ring[ni], top_center])
        f.material_index = 0
        
    # 4. Voluminous Curly Hair Mass
    hair_slices = [
        (1.72, 0.26, 0.25, 3),
        (1.78, 0.29, 0.28, 3),
        (1.84, 0.30, 0.29, 3),
        (1.90, 0.26, 0.25, 3),
        (1.94, 0.14, 0.14, 3),
    ]
    prev_hair = None
    hair_rings = []
    for z, rx, ry, m_idx in hair_slices:
        current_ring = []
        for i in range(16):
            angle = 2.0 * math.pi * i / 16
            vx = math.cos(angle) * rx
            vy = math.sin(angle) * ry + 0.05
            if angle < math.pi * 1.2 or angle > math.pi * 1.8:
                vx *= 1.15
                vy *= 1.20
            vert = bm.verts.new((vx, vy, z))
            current_ring.append(vert)
        if prev_hair:
            for i in range(16):
                ni = (i + 1) % 16
                f = bm.faces.new([prev_hair[i], prev_hair[ni], current_ring[ni], current_ring[i]])
                f.material_index = m_idx
        prev_hair = current_ring
        hair_rings.append(current_ring)
        
    hair_top = bm.verts.new((0, 0.05, 1.96))
    last_hair_ring = hair_rings[-1]
    for i in range(len(last_hair_ring)):
        ni = (i + 1) % len(last_hair_ring)
        f = bm.faces.new([last_hair_ring[i], last_hair_ring[ni], hair_top])
        f.material_index = 3
        
    # 5. Arms & Hands
    for side, sign in [("L", 1.0), ("R", -1.0)]:
        arm_segments = [
            (sign * 0.24, 0, 1.38, 0.13, 0), # Shoulder / Clavicle joint
            (sign * 0.34, 0, 1.26, 0.12, 0), # Bicep
            (sign * 0.44, 0, 1.14, 0.10, 0), # Elbow
            (sign * 0.49, 0, 1.01, 0.09, 5), # Forearm / Wrap start
            (sign * 0.54, 0, 0.88, 0.08, 5), # Wrist wrap
            (sign * 0.56, 0, 0.80, 0.07, 0), # Knuckles / Palm
            (sign * 0.58, 0, 0.74, 0.04, 0), # Finger tips
        ]
        prev_arm = None
        arm_rings = []
        for ax, ay, az, rad, m_idx in arm_segments:
            current_ring = []
            for i in range(8):
                angle = 2.0 * math.pi * i / 8
                vx = ax + math.sin(angle) * rad * 0.7
                vy = ay + math.cos(angle) * rad
                vz = az + math.sin(angle) * rad * 0.7
                vert = bm.verts.new((vx, vy, vz))
                current_ring.append(vert)
            if prev_arm:
                for i in range(8):
                    ni = (i + 1) % 8
                    f = bm.faces.new([prev_arm[i], prev_arm[ni], current_ring[ni], current_ring[i]])
                    f.material_index = m_idx
            prev_arm = current_ring
            arm_rings.append(current_ring)
            
        hand_tip = bm.verts.new((sign * 0.58, 0, 0.72))
        last_arm_ring = arm_rings[-1]
        for i in range(len(last_arm_ring)):
            ni = (i + 1) % len(last_arm_ring)
            f = bm.faces.new([last_arm_ring[i], last_arm_ring[ni], hand_tip])
            f.material_index = 0

    # 6. Legs & Boots
    for side, sign in [("L", 1.0), ("R", -1.0)]:
        leg_segments = [
            (sign * 0.18, 0, 0.86, 0.16, 1), # Upper thigh (singlet leg)
            (sign * 0.18, 0, 0.72, 0.15, 1), # Mid thigh
            (sign * 0.18, 0, 0.58, 0.14, 0), # Lower thigh (skin)
            (sign * 0.18, 0, 0.50, 0.13, 0), # Knee
            (sign * 0.18, 0, 0.38, 0.12, 0), # Upper calf (skin)
            (sign * 0.18, 0, 0.30, 0.13, 4), # Boot collar
            (sign * 0.18, 0, 0.16, 0.11, 4), # Ankle
            (sign * 0.18, -0.04, 0.06, 0.11, 4), # Heel / Instep
        ]
        prev_leg = None
        leg_rings = []
        for lx, ly, lz, rad, m_idx in leg_segments:
            current_ring = []
            for i in range(10):
                angle = 2.0 * math.pi * i / 10
                vx = lx + math.cos(angle) * rad
                vy = ly + math.sin(angle) * rad
                vz = lz
                vert = bm.verts.new((vx, vy, vz))
                current_ring.append(vert)
            if prev_leg:
                for i in range(10):
                    ni = (i + 1) % 10
                    f = bm.faces.new([prev_leg[i], prev_leg[ni], current_ring[ni], current_ring[i]])
                    f.material_index = m_idx
            prev_leg = current_ring
            leg_rings.append(current_ring)
            
        # Sole bottom cap
        sole_center = bm.verts.new((sign * 0.18, -0.04, 0.02))
        last_leg_ring = leg_rings[-1]
        for i in range(len(last_leg_ring)):
            ni = (i + 1) % len(last_leg_ring)
            f = bm.faces.new([sole_center, last_leg_ring[ni], last_leg_ring[i]])
            f.material_index = 4

    bm.to_mesh(mesh_data)
    bm.free()
    
    # Setup Vertex Groups & Assign Skin Weights
    vg_map = {}
    for bone_name in [
        "Root", "Hips", "Spine", "Chest", "Neck", "Head",
        "Clavicle.L", "Clavicle.R", "UpperArm.L", "UpperArm.R",
        "Forearm.L", "Forearm.R", "Hand.L", "Hand.R",
        "Thigh.L", "Thigh.R", "Shin.L", "Shin.R",
        "Foot.L", "Foot.R", "Toe.L", "Toe.R"
    ]:
        vg_map[bone_name] = mesh_obj.vertex_groups.new(name=bone_name)
        
    for v in mesh_obj.data.vertices:
        x, y, z = v.co.x, v.co.y, v.co.z
        
        # Head & Neck
        if z >= 1.54:
            vg_map["Head"].add([v.index], 1.0, 'REPLACE')
        elif z >= 1.45:
            t = (z - 1.45) / (1.54 - 1.45)
            vg_map["Neck"].add([v.index], 1.0 - t, 'REPLACE')
            vg_map["Head"].add([v.index], t, 'REPLACE')
        # Arms
        elif abs(x) >= 0.22 and z >= 0.70:
            side = "L" if x > 0 else "R"
            dist_along_arm = (abs(x) - 0.22) / 0.36
            if dist_along_arm < 0.25:
                vg_map[f"Clavicle.{side}"].add([v.index], 0.7, 'REPLACE')
                vg_map[f"UpperArm.{side}"].add([v.index], 0.3, 'REPLACE')
            elif dist_along_arm < 0.60:
                vg_map[f"UpperArm.{side}"].add([v.index], 0.8, 'REPLACE')
                vg_map[f"Forearm.{side}"].add([v.index], 0.2, 'REPLACE')
            elif dist_along_arm < 0.85:
                vg_map[f"Forearm.{side}"].add([v.index], 0.8, 'REPLACE')
                vg_map[f"Hand.{side}"].add([v.index], 0.2, 'REPLACE')
            else:
                vg_map[f"Hand.{side}"].add([v.index], 1.0, 'REPLACE')
        # Torso
        elif z >= 1.24:
            vg_map["Chest"].add([v.index], 1.0, 'REPLACE')
        elif z >= 1.04:
            t = (z - 1.04) / (1.24 - 1.04)
            vg_map["Spine"].add([v.index], 1.0 - t, 'REPLACE')
            vg_map["Chest"].add([v.index], t, 'REPLACE')
        elif z >= 0.86:
            t = (z - 0.86) / (1.04 - 0.86)
            vg_map["Hips"].add([v.index], 1.0 - t, 'REPLACE')
            vg_map["Spine"].add([v.index], t, 'REPLACE')
        # Legs
        else:
            side = "L" if x > 0 else "R"
            if z >= 0.50:
                vg_map[f"Thigh.{side}"].add([v.index], 1.0, 'REPLACE')
            elif z >= 0.16:
                t = (z - 0.16) / (0.50 - 0.16)
                vg_map[f"Shin.{side}"].add([v.index], 1.0 - t, 'REPLACE')
                vg_map[f"Thigh.{side}"].add([v.index], t, 'REPLACE')
            elif z >= 0.05:
                vg_map[f"Foot.{side}"].add([v.index], 1.0, 'REPLACE')
            else:
                vg_map[f"Toe.{side}"].add([v.index], 1.0, 'REPLACE')

    # Armature modifier
    mod = mesh_obj.modifiers.new("Armature", 'ARMATURE')
    mod.object = arm_obj
    mesh_obj.parent = arm_obj
    
    return mesh_obj

def add_bone_keyframe(arm_obj, bone_name, prop, value, frame):
    pb = arm_obj.pose.bones[bone_name]
    pb.rotation_mode = 'XYZ'
    setattr(pb, prop, value)
    pb.keyframe_insert(data_path=prop, frame=frame)

def author_animations(arm_obj):
    bpy.context.scene.render.fps = 60
    if not arm_obj.animation_data:
        arm_obj.animation_data_create()
        
    def create_clip(name):
        act = bpy.data.actions.new(name=name)
        arm_obj.animation_data.action = act
        return act
        
    def push_to_nla(act, name):
        track = arm_obj.animation_data.nla_tracks.new()
        track.name = name
        track.strips.new(name, 1, act)

    # -------------------------------------------------------------
    # 1. IDLE (60f loop, 1.0s): Heavyweight ready stance with weight shift
    # -------------------------------------------------------------
    act_idle = create_clip("idle")
    for f, hip_rot_y, hip_pos_y, chest_rot_x in [
        (1, 0.0, 0.0, 0.05),
        (15, 0.03, -0.01, 0.02),
        (30, 0.0, 0.0, 0.06),
        (45, -0.03, -0.01, 0.02),
        (60, 0.0, 0.0, 0.05)
    ]:
        add_bone_keyframe(arm_obj, "Hips", "location", (0, hip_pos_y, 0), f)
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0.05, hip_rot_y, 0), f)
        add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (chest_rot_x, 0, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0.5, 0.2, 0.3), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.5, -0.2, -0.3), f)
        add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-0.9, 0, 0), f)
        add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.9, 0, 0), f)
        add_bone_keyframe(arm_obj, "Thigh.L", "rotation_euler", (-0.15, 0, 0.05), f)
        add_bone_keyframe(arm_obj, "Thigh.R", "rotation_euler", (-0.15, 0, -0.05), f)
        add_bone_keyframe(arm_obj, "Shin.L", "rotation_euler", (0.25, 0, 0), f)
        add_bone_keyframe(arm_obj, "Shin.R", "rotation_euler", (0.25, 0, 0), f)
    push_to_nla(act_idle, "idle")

    # -------------------------------------------------------------
    # 2. WALK (60f loop, 1.0s): Grounded heavyweight stride
    # -------------------------------------------------------------
    act_walk = create_clip("walk")
    for f, r_leg, l_leg, r_arm, l_arm in [
        (1, -0.35, 0.25, 0.4, -0.4),
        (15, -0.10, -0.10, 0.0, 0.0),
        (30, 0.25, -0.35, -0.4, 0.4),
        (45, -0.10, -0.10, 0.0, 0.0),
        (60, -0.35, 0.25, 0.4, -0.4)
    ]:
        add_bone_keyframe(arm_obj, "Thigh.R", "rotation_euler", (r_leg, 0, 0), f)
        add_bone_keyframe(arm_obj, "Thigh.L", "rotation_euler", (l_leg, 0, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (r_arm, 0, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (l_arm, 0, 0), f)
        add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.5, 0, 0), f)
        add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-0.5, 0, 0), f)
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0.05, 0.05 if r_leg > 0 else -0.05, 0), f)
    push_to_nla(act_walk, "walk")

    # -------------------------------------------------------------
    # 3. STRIKE (27f, 0.45s): Synchronized with Godot attack_total_time = 0.45s
    # Active window [0.12s, 0.32s] -> delivery impact at F14 (0.23s)
    # -------------------------------------------------------------
    act_strike = create_clip("strike")
    # F1 (0.00s): Stance
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0, 0, 0), 1)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0, 0, 0), 1)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.4, 0, 0), 1)
    add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.8, 0, 0), 1)
    # F7 (0.11s): Windup / Cocking back
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0, -0.25, 0), 7)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0, -0.30, 0), 7)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.7, 0.4, -0.5), 7)
    add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-1.4, 0, 0), 7)
    # F14 (0.23s): Explosive Overhand Delivery (Peak extension during active window)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0.15, 0.50, 0), 14)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0.20, 0.55, 0), 14)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (1.3, -0.4, 0.2), 14)
    add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.2, 0, 0), 14)
    # F20 (0.33s): Follow-through
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0.10, 0.35, 0), 20)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0.15, 0.40, 0), 20)
    # F27 (0.45s): Recovery to stance
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0, 0, 0), 27)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0, 0, 0), 27)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.5, -0.2, -0.3), 27)
    add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.9, 0, 0), 27)
    push_to_nla(act_strike, "strike")

    # -------------------------------------------------------------
    # 4. KNOCKDOWN (60f, 1.0s impact & settle flat on canvas)
    # -------------------------------------------------------------
    act_kd = create_clip("knockdown")
    # F1 (0.00s): Impact reel
    add_bone_keyframe(arm_obj, "Hips", "location", (0, 0, 0), 1)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0, 0, 0), 1)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (-0.3, 0, 0), 1)
    add_bone_keyframe(arm_obj, "Head", "rotation_euler", (-0.5, 0, 0), 1)
    # F15 (0.25s): Falling backward
    add_bone_keyframe(arm_obj, "Hips", "location", (0, -0.30, 0), 15)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-0.7, 0, 0), 15)
    # F30 (0.50s): Canvas mat impact flat at mat level (-0.75m local Y)
    add_bone_keyframe(arm_obj, "Hips", "location", (0, -0.75, 0), 30)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-math.pi / 2.0, 0, 0), 30)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0, 0, 0), 30)
    add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0, 0, 1.2), 30)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0, 0, -1.2), 30)
    add_bone_keyframe(arm_obj, "Thigh.L", "rotation_euler", (0.2, 0, 0), 30)
    add_bone_keyframe(arm_obj, "Thigh.R", "rotation_euler", (0.2, 0, 0), 30)
    # F60 (1.00s): Settle flat on canvas
    add_bone_keyframe(arm_obj, "Hips", "location", (0, -0.75, 0), 60)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-math.pi / 2.0, 0, 0), 60)
    push_to_nla(act_kd, "knockdown")

    # -------------------------------------------------------------
    # 5. GETUP (36f, 0.60s): Synchronized with Godot getup timer (0.60s)
    # -------------------------------------------------------------
    act_gu = create_clip("getup")
    # F1 (0.00s): Flat on back on canvas
    add_bone_keyframe(arm_obj, "Hips", "location", (0, -0.75, 0), 1)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-math.pi / 2.0, 0, 0), 1)
    # F9 (0.15s): Roll to left hip, plant left elbow & right foot
    add_bone_keyframe(arm_obj, "Hips", "location", (0, -0.55, 0), 9)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-1.1, 0, 0.5), 9)
    add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0.4, 0, 0.8), 9)
    add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-1.2, 0, 0), 9)
    add_bone_keyframe(arm_obj, "Thigh.R", "rotation_euler", (0.8, 0, 0), 9)
    add_bone_keyframe(arm_obj, "Shin.R", "rotation_euler", (1.2, 0, 0), 9)
    # F18 (0.30s): Push up onto left hand, rise onto left knee
    add_bone_keyframe(arm_obj, "Hips", "location", (0, -0.35, 0), 18)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-0.4, 0, 0.2), 18)
    add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0.2, 0, 0.4), 18)
    add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-0.3, 0, 0), 18)
    # F27 (0.45s): Bring right leg forward, push off thighs
    add_bone_keyframe(arm_obj, "Hips", "location", (0, -0.15, 0), 27)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-0.1, 0, 0), 27)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0.1, 0, 0), 27)
    # F36 (0.60s): Fully upright in ready stance right as Godot returns to IDLE
    add_bone_keyframe(arm_obj, "Hips", "location", (0, 0, 0), 36)
    add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0.05, 0, 0), 36)
    add_bone_keyframe(arm_obj, "Chest", "rotation_euler", (0.05, 0, 0), 36)
    add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0.5, 0.2, 0.3), 36)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.5, -0.2, -0.3), 36)
    push_to_nla(act_gu, "getup")

    # -------------------------------------------------------------
    # 6. Safety & Baseline Gameplay Clips
    # -------------------------------------------------------------
    # Block (30f, 0.50s)
    act_blk = create_clip("block")
    for f in [1, 30]:
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (1.2, 0.3, -0.3), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (1.2, -0.3, 0.3), f)
        add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-1.5, 0, 0), f)
        add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-1.5, 0, 0), f)
    push_to_nla(act_blk, "block")

    # Reversal (30f, 0.50s)
    act_rev = create_clip("reversal")
    for f in [1, 30]:
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0.8, 0.5, 0.2), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.8, -0.5, -0.2), f)
    push_to_nla(act_rev, "reversal")

    # Grapple Startup (11f, 0.18s! Synchronized with MatchRules.GRAPPLE_STARTUP_DURATION = 0.18s)
    act_grp = create_clip("grapple")
    add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (0.5, 0.2, 0.3), 1)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (0.5, -0.2, -0.3), 1)
    add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-0.9, 0, 0), 1)
    add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.9, 0, 0), 1)
    # Fully reaching forward at F11
    add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (1.4, 0.1, 0.1), 11)
    add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (1.4, -0.1, -0.1), 11)
    add_bone_keyframe(arm_obj, "Forearm.L", "rotation_euler", (-0.2, 0, 0), 11)
    add_bone_keyframe(arm_obj, "Forearm.R", "rotation_euler", (-0.2, 0, 0), 11)
    push_to_nla(act_grp, "grapple")

    # Throw Attacker (60f, 1.0s! Synchronized with throw_duration = 1.0s, impact at 0.55s / F33)
    act_ta = create_clip("throw_attacker")
    for f, arm_x in [(1, 0.5), (20, 1.8), (33, 0.2), (60, 0.5)]:
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (arm_x, 0.2, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (arm_x, -0.2, 0), f)
    push_to_nla(act_ta, "throw_attacker")

    # Throw Defender (60f, 1.0s! Synchronized with throw_duration = 1.0s, impact at 0.55s / F33)
    act_td = create_clip("throw_defender")
    for f, rot_x, loc_y in [(1, 0, 0), (20, -1.5, 0.6), (33, -3.14, -0.75), (60, -3.14, -0.75)]:
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (rot_x, 0, 0), f)
        add_bone_keyframe(arm_obj, "Hips", "location", (0, loc_y, 0), f)
    push_to_nla(act_td, "throw_defender")

    # Pinning (Cover) (60f, 1.0s)
    act_pinn = create_clip("pinning")
    for f in [1, 60]:
        add_bone_keyframe(arm_obj, "Hips", "location", (0, -0.45, 0), f)
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (0.8, 0, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (1.2, 0, 0), f)
    push_to_nla(act_pinn, "pinning")

    # Pinned (Grounded Struggle) (60f, 1.0s)
    act_pind = create_clip("pinned")
    for f in [1, 30, 60]:
        add_bone_keyframe(arm_obj, "Hips", "location", (0, -0.75, 0), f)
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-math.pi / 2.0, 0, 0), f)
        add_bone_keyframe(arm_obj, "Thigh.L", "rotation_euler", (0.4 if f == 30 else 0.1, 0, 0), f)
    push_to_nla(act_pind, "pinned")

    # Submission Attacker (60f, 1.0s)
    act_sa = create_clip("submission_attacker")
    for f in [1, 60]:
        add_bone_keyframe(arm_obj, "Hips", "location", (0, -0.45, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (1.1, 0.2, 0), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (1.1, -0.2, 0), f)
    push_to_nla(act_sa, "submission_attacker")

    # Submission Defender (60f, 1.0s)
    act_sd = create_clip("submission_defender")
    for f in [1, 60]:
        add_bone_keyframe(arm_obj, "Hips", "location", (0, -0.75, 0), f)
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-1.2, 0, 0), f)
    push_to_nla(act_sd, "submission_defender")

    # Victory (60f, 1.0s)
    act_vic = create_clip("victory")
    for f, arm_z in [(1, 0.5), (30, 2.2), (60, 2.0)]:
        add_bone_keyframe(arm_obj, "UpperArm.L", "rotation_euler", (arm_z, 0, 0.6), f)
        add_bone_keyframe(arm_obj, "UpperArm.R", "rotation_euler", (arm_z, 0, -0.6), f)
    push_to_nla(act_vic, "victory")

    # Defeated (60f, 1.0s)
    act_def = create_clip("defeated")
    for f in [1, 60]:
        add_bone_keyframe(arm_obj, "Hips", "location", (0, -0.75, 0), f)
        add_bone_keyframe(arm_obj, "Hips", "rotation_euler", (-math.pi / 2.0, 0, 0), f)
    push_to_nla(act_def, "defeated")

def main():
    clear_scene()
    print("Building Tophiachu Armature...")
    arm_obj = build_humanoid_armature()
    print("Building Tophiachu Skinned Mesh...")
    mesh_obj = build_character_mesh(arm_obj)
    print("Authoring Tophiachu Animations...")
    author_animations(arm_obj)
    
    output_path = "assets/models/tophiachu.glb"
    print(f"Exporting Tophiachu to {output_path}...")
    bpy.ops.export_scene.gltf(
        filepath=output_path,
        export_format='GLB',
        export_animations=True,
        export_skins=True,
        export_morph=False
    )
    print("Export Complete!")

if __name__ == "__main__":
    main()

```

