# LOLCOW WRESTLING: OFFLINE MAYHEM - COMPLETE CODEBASE DIGEST FOR GPT PRO

## File: project.godot

`ini
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

`

---

## File: README.md

`md
# LOLCOW WRESTLING: OFFLINE MAYHEM

> A stylized 3D arcade wrestling game built in Godot 4.7.2 Forward+ with Blender 5.0 DCC procedural assets, targeting 1080p @ 60 FPS on Windows standalone.

---

## 1. Project Overview

*LOLCOW WRESTLING: OFFLINE MAYHEM* is an arcade-style 3D professional wrestling title featuring 8 distinct fighters, synchronized grapple and throw sequences, continuous submission holds, dynamic referee officiating, and an integrated Character Selection system.

### In Memoriam: KingCobraJFS (1991–2025)
Reporting confirms that KingCobraJFS passed away on 21 August 2025. Throughout the entire game across all game modes, KingCobraJFS serves as the neutral, untargetable official referee. He features a permanently visible, pulsing emissive gold halo hovering above his gothic cap as an enduring memorial tribute.

---

## 2. The 8-Character Canonical Roster

Every fighter has an authoritative, canonical 42-point attribute distribution across 7 stats (Power, Mobility, Grappling, Stamina, Durability, Reversal, Showmanship; all rated 1–10).

| ID | Name | Archetype | Style Summary | Signature Finisher |
| :--- | :--- | :--- | :--- | :--- |
| tophiachu | Tophiachu | Heavyweight Counter-Brawler | Slow heavy tank, devastating strikes & high powerslams | *Live-Stream Shutdown* |
| novaonline | NovaOnline | Momentum Heavyweight | Balanced heavyweight with forward burst | *Going Offline* |
| cyraxx | Cyraxx | Lightweight Burst Striker | Compact, lightning strikes, low leverage throws | *Raxx and Ruin* |
| candy_rooks | Candy Rooks | Combination Grappler | High power and durability combination brawler | *Ribs & Kidney Beans* |
| andy_ditch | Andy Ditch | Territory Anchor Grappler | Anchor wrestler with high grappling defense | *Case Closed* |
| jupiter_the_hybrid | Jupiter the Hybrid | Stance-Shift Grappler | Agile kicks, swift escapes, aerial offense | *Eclipse Driver* |
| anacondasin | AnacondaSin | Positional Submission Specialist | Dangerous lock specialist, rapid tap-out inducer | *Anaconda Lock* |
| daniel_larson | Daniel Larson | Mobile Opportunist | Unpredictable, fast scrambler and reversal threat | *Final Encore* |

---

## 3. Core Mechanics & Architecture

1. **Deterministic Combat State Machine**:
   - Strictly authoritative state gating on Fighter (IDLE, WALK, STRIKE, BLOCK, REVERSAL, GRAPPLE_INIT, GRAPPLE_LIFT, THROW_ATTACKER, THROW_DEFENDER, KNOCKDOWN, GETUP, PINNING, PINNED, SUBMISSION_ATTACKER, SUBMISSION_DEFENDER, VICTORY, DEFEATED).
   - Zero sliding or desynchronization during mutual grapple locks.
   - Attacker and defender trajectories are mutually locked and frame-synchronized.

2. **Leverage & Weight-Class Throw Scaling**:
   - Grapples dynamically evaluate the attacker-to-defender weight/power ratio.
   - Heavyweights lifting lighter opponents execute high overhead powerslams (1.55m vertical peak).
   - Lightweight strikers throwing heavyweights route to low-angle leverage trips (0.38m vertical peak), ensuring believable physical interactions.

3. **Submissions & Pinning**:
   - **Continuous Submissions**: Lock holds drain defender vitality and stamina continuously. Defender can mash kick-out keys to escape; if vitality drops to zero during a hold, a tap-out victory is declared.
   - **Pinning & 3-Count**: Pin attempts alert referee KingCobraJFS to drop into position and begin 1-2-3 counts. A kick-out meter allows escapes before count 3.
   - **Rope Break Priority**: Being within 0.8m of the ring ropes immediately breaks pins and submissions.

4. **16-Bit PCM Procedural Audio Synthesizer (scripts/core/audio_manager.gd)**:
   - Zero external WAV dependencies; all sounds synthesized in real time via 16-bit PCM waveforms:
     - Mat slam impacts, canvas slaps, clean strike snaps, blocked thuds.
     - Ring bell chimes and elastic rope twangs.
     - Referee count tone accents (Count 1: 350 Hz, Count 2: 440 Hz, Count 3: 530 Hz).
     - Rope break alert buzzer.
     - Rising finisher power chord stinger.
     - Triumphant 4-note brass victory fanfare.

5. **Broadcast Presentation**:
   - Dynamic 3D arena with canvas, apron, steel corner posts, and 3-tier ropes.
   - Broadcast camera with zoom framing and trauma-based screen shake.
   - Full arcade Character Select menu with dual navigation (WASD for P1, Arrows for P2), stat radars, CPU toggle, and match persistence.

---

## 4. Default Input Controls

### Character Select
- **P1 Selection**: W / A / S / D
- **P2 Selection**: Up / Left / Down / Right
- **Toggle P2 CPU/Human**: C key
- **Confirm / Start Match**: Space or Enter

### In-Ring Combat
| Action | Player 1 | Player 2 (If Human) |
| :--- | :--- | :--- |
| **Move Up / Down / Left / Right** | W / S / A / D | Up / Down / Left / Right |
| **Strike** | J | Numpad 1 |
| **Grapple / Throw** | K | Numpad 2 |
| **Block / Submission** | L | Numpad 3 |
| **Reversal** | U | Numpad 4 |
| **Pin / Kick-out** | Space | Numpad 0 |
| **Signature Finisher** | I | Numpad 5 |
| **Return to Menu** | Escape | Escape |

---

## 5. Verification & Test Suite

The project includes an automated headless verification suite testing the combat state machine, 3D model geometry, audio synthesis, and all 64 attacker-defender matchups ( \times 8$).

Run tests headlessly:
`ash
godot_console --headless -s tests/test_suite.gd
`
**Current Status**: 150 / 150 Passed (100% Pass, 0 Failures, 0 Warnings).

---

## 6. Directory Layout

```
.
├── assets/models/         # Compiled GLB 3D assets (all 8 fighters + ring + referee)
├── blender/               # Blender 5.0 automated generation pipeline (generate_assets.py)
├── scenes/
│   ├── arena/             # 3D Ring arena scene
│   ├── fighter/           # Instantiable 3D fighter entity
│   ├── referee/           # KingCobraJFS referee entity
│   └── ui/                # Character select and broadcast match HUD
├── scripts/
│   ├── ai/                # Autonomous CPU combat controller
│   ├── core/              # RosterData, MatchRules, MatchManager, AudioManager, MatchConfig
│   ├── fighter/           # State machine, movement, grapple sync, combat logic
│   ├── referee/           # KingCobraJFS ring positioning and 3-count officiating
│   ├── ring/              # Ring boundary and broadcast camera shake
│   └── ui/                # UI controllers
├── tests/                 # 150-case headless automated test suite
├── project.godot          # Engine configuration & input mappings
└── START_GAME.bat         # Direct Windows standalone launcher
```

`

---

## File: STATE.md

`md
# Project State: LOLCOW WRESTLING: OFFLINE MAYHEM

## Milestone Status: M0-M1 Functional -> Pass A Repairs (Directional Contact & Grapple Startup Complete)
- **Engine**: Godot 4.7.2 (stable official, Windows x64) - Installed & Verified.
- **3D DCC Pipeline**: Blender 5.0.1 (headless Python automation) - Verified.
- **Target**: 1080p @ 60 FPS, Windows standalone.
- **Authoritative Combat Loop & Integration**: Verified with 361 automated headless tests (305 focused unit tests + 56 full scene physics integration tests, 0 failures, 0 warnings).
- **M2/M3 Status**: Functional baseline established. Skeletal animation rigging, authored unique animation clips, and manual visual inspections remain **NOT RUN / PENDING** per code review requirements.

### Pass A Codebase Repairs & Verifications:
1. **Pin-Balance Acceptance & Empirical Sequence Validation (Verified & Accepted)**:
   - Evaluated actual gameplay throw-to-pin sequences in Godot scene physics (`scenes/fighter/fighter.tscn`, `MatchManager`, `Referee`, `CPUController` using engine `await physics_frame` steps).
   - Verified that fresh Cyraxx taking an ordinary Tophiachu throw (177 damage, HP 663/850, 100% stamina) kicks out before Count 2 (~1.5s–1.6s) across all 4 modes:
     - Mode 1 (CPU commands): Count 1, 1.62s KICKOUT.
     - Mode 2 (Human 10 Hz mash): Count 1, 1.52s KICKOUT.
     - Mode 3 (Hold-to-resist on entry): Count 1, 1.53s KICKOUT.
     - Mode 4 (Hold-to-resist pre-held): Count 1, 1.62s KICKOUT.
   - Verified that weakened Cyraxx taking a genuine finisher throw from Tophiachu suffers legitimate 3-count pinfall defeats across all 4 modes.
2. **Explicit Move-Metadata Impact Classification (Verified)**:
   - Repaired flaw where `amount >= 100.0` caused ordinary heavy throws (177 damage) to trigger 45% finisher escape penalties.
   - Decoupled move pressure:
     - Finisher pressure (`recent_finisher_impact_timer`): 4.5s duration, 0.55 multiplier, gated strictly by `is_finisher == true`.
     - Ordinary heavy impact pressure (`recent_heavy_impact_timer`): 1.5s duration, 0.85 multiplier, triggered on unblocked hits $\ge 80.0$ damage.
3. **Hold-to-Resist Accessibility Parity (Verified)**:
   - Tuned `PIN_ESCAPE_BASE_RATE = 85.0`/s and `PIN_ESCAPE_MASH_BASE = 10.0`/pulse (at 10 Hz = 100.0/s).
   - Proportional stamina consumption: hold drains 8.0/s; mash drains 0.8/pulse (8.0/s at 10 Hz).
4. **Deterministic Final-Tick Priority Resolution (Tick 198 / 3.30s) (Verified)**:
   - Fixed floating point epsilon (`+ 0.0005`) ensuring Count 3 resolves at tick 198 (3.30s).
   - Enforced strict preemptive priority: kick-out ($\ge 100.0$) and rope breaks immediately waive off 3-count and return match state to `IN_PROGRESS`.
   - Verified across both player slots (P1/P2 and P2/P1) and tree processing orders (Fighter before MatchManager and MatchManager before Fighter).
   - Guarded `_end_match` against repeat calls, ensuring `match_ended` is emitted strictly once.
5. **Unified Command Interface for Escapes (Verified in Pass A)**:
   - `Fighter` escape logic consumes command inputs (`input_pin`, `input_strike`, `input_grapple`, `input_block`, `input_hold_pin`) rather than polling `Input.is_action_*` during physics process.
6. **Throw Height Ownership (Verified in Center Ring)**:
   - Attacker retains sole vertical authority (1.55m peak verified in center ring).
7. **Standardized Forward-Axis Conventions (Verified in Pass A)**:
   - Synchronized throws and locomotion unified on standard Godot convention `atan2(-dx, -dz)`.
8. **Boundary-Safe Paired Throws with Pre-Throw Trajectory Validation (Verified in Pass A Priority 2)**:
   - Implemented `_validate_and_adjust_throw_boundaries()` in `Fighter._start_synchronized_throw()`.
   - Calculates predicted slam impact position $\vec{P}_{\text{slam}} = \vec{P}_{\text{atk}} + \vec{F} \times d_{\text{slam}}$ and shifts the grappling pair inward toward ring center such that both attacker, defender, and landing coordinates remain $\le 3.50\text{m}$ (inside $3.65\text{m}$ rope threshold).
   - Clamped intermediate synchronized lift (`hold_pos`) and landing (`slam_pos`) coordinates to `THROW_SAFE_RING_BOUND = 3.50m` to provide defense-in-depth during multi-frame execution.
   - Confirmed zero out-of-bounds trajectory and zero snap-back across all 4 ring edges (North, South, East, West) and all 4 corners (NE, NW, SE, SW) across slot inversions and tree processing orders (32 edge/corner/slot permutations, 128 boundary assertions).
9. **Directional Strike Cones & Measurable Grapple Startup (Verified in Pass A Priority 3)**:
   - Enforced 120-degree forward contact cone ($\cos(60^\circ) = 0.50$, `STRIKE_CONE_MIN_DOT = 0.50`) in `Fighter._handle_strike_active_window()`. Verified that strikes connect when defender is in front ($0^\circ$, dot = 1.0) or angled ($45^\circ$, dot = 0.707), but strictly miss defenders on side flanks ($90^\circ$, dot = 0.0) or behind ($180^\circ$, dot = -1.0).
   - Implemented measurable `GRAPPLE_STARTUP` window (`MatchRules.GRAPPLE_STARTUP_DURATION = 0.18s`, whiff recovery 0.25s) with procedural reaching arm animation.
   - Verified strike interruption: incoming unblocked strikes during `GRAPPLE_STARTUP` immediately interrupt attacker back to `IDLE`, clear target references, and prevent throw execution.
   - Verified reversal counters: defender inputting `REVERSAL_STANCE` during startup successfully counters the attacker upon startup completion, inflicting counter damage, knockdown, and awarding hype.
   - Upgraded `CPUController` to actively detect opponent `GRAPPLE_STARTUP` within range and retaliate with strike interruptions or reversal counters based on stats.

### Active Open Items from Code Review (In Priority Order):
1. **Submission Simultaneous Outcome Resolution (Pass A Priority 4 - Open)**: Formalize authoritative priority in `MatchManager` when tap-out and escape coincide on the same physics tick.
2. **Manual Visual Inspection & Skeletal Rigging**: Visual checks and authored animations remain **NOT RUN**.

## Verification Summary
- **M0 Foundation**:
  - Full 8-character roster defined with verified 42-point attribute allocations.
  - Complete two-player arcade input mapping configured in `project.godot`.
- **M1 Playable Match Loop**:
  - Playable arena with canvas, apron, turnbuckles, ropes, and bounds.
  - Neutral official referee KingCobraJFS (1991-2025) with permanently visible, pulsing gold memorial halo.
  - Rigid state machine with authoritative movement ownership (zero sliding during knockdowns or throws).
  - Single-hit active damage windows.
  - Synchronized grapple and throw sequence with mutual locking, lift, impact canvas slap, and clean release.
  - Pinning, 3-count progression, hold/mash kick-out escape, and rope break priority.
- **M2 Polished Slice**:
  - Asymmetric leverage-based throw routing: lighter attackers route to low-angle leverage trips (0.38m peak) while heavyweights execute overhead powerslams (1.55m peak).
  - Submissions system: continuous pressure damage, stamina drain, hold/mash escape, and tap-out victory condition.
  - Procedural 16-bit PCM (22050 Hz) audio synthesis: ring bell, deep mat slam thud, clean/blocked strike snaps, canvas palm slaps, elastic rope twangs, crowd cheers, and crowd gasps.
  - Dynamic announcer audio stingers: rising finisher power chord, triumphant brass victory fanfare, count voice accents (1, 2, 3), and rope break buzzer alert.
  - Dynamic broadcast camera trauma shake with quadratic decay and accessibility scaling.
  - Animation architecture: `Fighter` supports `AnimationPlayer` bindings to state transitions with procedural visual deformation fallback.
- **M3 Full 8-Character Roster & Match Setup**:
  - All 8 distinct 3D fighter models authored and exported to GLB in Blender 5.0:
    - `tophiachu`: Heavyweight brawler, purple gear, curly silhouette.
    - `novaonline`: Athletic heavyweight, fiery red/gold attire, high boots.
    - `cyraxx`: Compact burst striker, olive gear, black beanie.
    - `candy_rooks`: Kitchen-sink powerhouse brute, pink apron aesthetic, forearm tape.
    - `andy_ditch`: Territory anchor grappler, padded denim blue wrestling singlet.
    - `jupiter_the_hybrid`: Celestial martial artist, deep violet and silver split design.
    - `anacondasin`: Submission technician, serpentine emerald/gold tights.
    - `daniel_larson`: Erratic scrapper, lanky silhouette, bright orange jacket.
  - KingCobraJFS (1991-2025) referee model with glowing golden halo.
  - Complete Character Selection UI (`scenes/ui/character_select.tscn`) with 8-character roster grid, stat radars, signature move displays, P1/P2 navigation, CPU toggles, and seamless transition to match arena.
  - `MatchConfig` persistent state tracking selected fighters and CPU flags between menus and gameplay.
  - 100% test pass rate across all 64 attacker-defender pairings.

`

---

## File: KNOWN_ISSUES.md

`md
## Active Open Issues & Defects Under Repair

1. **Simultaneous Submission Outcome Ordering (High Priority - Open)**:
   - While partner references are now cleared on both sides during escapes, a frame in which vitality depletes to 0 simultaneously with escape progress reaching 100 depends on node processing order (attacker update vs defender update).
   - *Required Fix*: Establish an explicit authoritative priority policy in `MatchManager` for simultaneous tap-out vs escape frames.

2. **Skeletal Animation Pipeline & Unique Moveset Data (Open)**:
   - 3D character models are composed of procedural primitive geometries without bones or skeletal clips. Throws and strikes utilize parameterized programmatic tweening rather than distinct motion-captured or keyframed animation clips.

---

## Resolved in Pass A & Prior Milestones

1. **Directional Attack Contact & Grapple Startup (Resolved in Pass A Priority 3)**:
   - Added forward directional dot-product gating (`STRIKE_CONE_MIN_DOT = 0.50`, 120-degree cone) to `_handle_strike_active_window()`, preventing strikes from connecting with targets on flanks or behind the attacker.
   - Enforced measurable `GRAPPLE_STARTUP` window (`GRAPPLE_STARTUP_DURATION = 0.18s`, whiff recovery 0.25s) in `_attempt_grapple()` and `_process_grapple_startup()`.
   - Verified that unblocked incoming strikes interrupt attacker out of `GRAPPLE_STARTUP` and clear target reference, preventing throw execution.
   - Verified that defender reversal stance during startup successfully counters the attacker.
   - Upgraded `CPUController` to retaliate against opponent `GRAPPLE_STARTUP` via strike interruption or reversal counter.
2. **Boundary Safety During Throws (Resolved in Pass A Priority 2)**:
   - Added `_validate_and_adjust_throw_boundaries()` before locking synchronized throws. Evaluates predicted slam target $\vec{P}_{\text{slam}} = \vec{P}_{\text{atk}} + \vec{F} \times d_{\text{slam}}$ and shifts both attacker and defender inward toward center ring so landing coordinates and hold coordinates remain $\le 3.50\text{m}$ (inside the $3.65\text{m}$ ring limit).
   - Added secondary clamping in `_process_synchronized_attacker()` for `hold_pos` and `slam_pos`.
   - Verified across 32 edge, corner, slot, and tree permutations (128 assertions) with zero out-of-bounds trajectory and zero ground release snap-back.
2. **Pin-Balance Acceptance & Empirical Sequence Validation (Resolved in Pass A Pinfall Balance)**:
   - Replaced flat-rate escape formula with an authoritative resource-aware model factoring in quadratic vitality, remaining stamina, reversal stats, and explicit move-metadata impact disorientation.
   - Eliminated the bug where ordinary heavy throws ($\ge 100$ damage) inflicted finisher disorientation; ordinary heavy throws (177 dmg) now trigger a mild 1.5s heavy impact timer (0.85 mult) allowing healthy defenders to kick out swiftly, while genuine finishers inflict a 4.5s disorientation (0.55 mult).
   - Balanced hold-to-resist as an accessibility alternative at 85.0 base/sec with proportional 8.0/s stamina drain (~85% of 10 Hz mashing speed).
   - Resolved tick 198 (3.30s) floating point boundary precision (`+ 0.0005`) and made kickout ($\ge 100.0$) and rope break strictly preempt the 3-count pinfall across all slot inversions and tree processing orders.
   - Empirically validated across 56 real engine physics tests (`tests/test_pin_balance_scene.gd`) that fresh Cyraxx kicks out at Count 1 (~1.5s–1.6s) across all 4 modes (CPU, 10 Hz mash, hold-on-entry, pre-held), and weakened Cyraxx loses by 3-count pinfall across all 4 modes.
2. **CPU Pin & Submission Escape Command Disconnection (Resolved in Pass A Baseline)**:
   - Unified all escape checks to consume the `Fighter` command interface (`input_pin`, `input_hold_pin`, `input_strike`, `input_grapple`, `input_block`) rather than polling global hardware keys during combat physics.
3. **Conflicting Throw Height Ownership (Resolved in Pass A Baseline)**:
   - Removed canvas grounding conflicts in central ring throws so overhead powerslams reach full 1.55m vertical peak before canvas impact.
4. **Forward-Axis Facing Vector Standardization (Resolved in Pass A Baseline)**:
   - Standardized all locomotion, stationary facing, and synchronized throw vectors to Godot's `-basis.z` forward convention (`atan2(-dx, -dz)`).
5. **Canonical Finisher Names Alignment (Resolved in Pass A Baseline)**:
   - Synchronized `README.md` to canonical names in `scripts/core/roster_data.gd`.
6. **Desktop Launcher Script Trailing Quote Bug (Resolved in M3 Polish)**:
   - Fixed `%~dp0` trailing backslash CRT escaping issue in `START_GAME.bat`.


`

---

## File: NEXT_TASK.md

`md
# Next Implementation Task: Pass A Priority 4 (Simultaneous Submission Outcome Ordering)

## Immediate Next Task
**Priority 4: Simultaneous Submission Outcome Ordering**:
1. Implement authoritative simultaneous outcome resolution policy in `MatchManager` when submission vitality depletion (tap-out condition) and escape progress (break condition) reach their thresholds on the exact same physics frame.
2. Ensure centralized hold cleanup:
   - Clear synchronized partner pointers symmetrically on both attacker and defender.
   - Prevent conflicting multi-frame state transitions or dangling references.
3. Validate across both player slot orders (P1 Attacker / P2 Defender vs P2 Attacker / P1 Defender) and scene tree iteration orders (Attacker before Defender vs Defender before Attacker).

## Subsequent Backlog (In Strict Priority Order)
- **Priority 5**: Scene integration and visual verification across all 64 matchups.
- **Priority 6**: Skeletal animation rigging and authored animation pipeline.

`

---

## File: scripts/core/match_rules.gd

`gdscript
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

static func is_near_ropes(position_3d: Vector3) -> bool:
	var x: float = abs(position_3d.x)
	var z: float = abs(position_3d.z)
	var max_coord: float = max(x, z)
	return max_coord >= (RING_MAT_RADIUS - ROPE_BREAK_DISTANCE)

`

---

## File: scripts/core/roster_data.gd

`gdscript
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

`

---

## File: scripts/core/match_config.gd

`gdscript
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

`

---

## File: scripts/core/match_manager.gd

`gdscript
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
		
	# Check if fighters moved near ropes during pin struggle
	if MatchRules.is_near_ropes(get_fighter_pos(current_pinned)) or MatchRules.is_near_ropes(get_fighter_pos(current_pinner)):
		_call_rope_break()
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
				current_pinned._execute_kick_out()
				return
			_end_match(current_pinner, "PINFALL (3-COUNT)")

func _on_kick_out_succeeded(fighter: Fighter) -> void:
	if current_state == MatchState.PIN_ATTEMPT and fighter == current_pinned:
		pin_broken.emit("KICKOUT")
		if referee:
			referee.on_pin_broken()
		if AudioManager.instance:
			AudioManager.instance.play_crowd_gasp()
			
		current_pinner = null
		current_pinned = null
		current_state = MatchState.IN_PROGRESS

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
		
	if MatchRules.is_near_ropes(get_fighter_pos(current_pinned)) or MatchRules.is_near_ropes(get_fighter_pos(current_pinner)):
		_call_rope_break()
		return

func _on_submission_escaped(_fighter: Fighter) -> void:
	if current_state == MatchState.SUBMISSION_ATTEMPT:
		submission_escaped.emit()
		if referee:
			referee.on_pin_broken()
		current_pinner = null
		current_pinned = null
		current_state = MatchState.IN_PROGRESS

func _on_tap_out_submitted(loser: Fighter) -> void:
	var winner: Fighter = fighter_2 if loser == fighter_1 else fighter_1
	_end_match(winner, "SUBMISSION (TAP OUT)")

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
		current_pinner.break_pin_rope_break()
		current_pinner.break_submission_rope_break()
	if is_instance_valid(current_pinned):
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

`

---

## File: scripts/core/audio_manager.gd

`gdscript
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

`

---

## File: scripts/core/main_scene.gd

`gdscript
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

`

---

## File: scripts/fighter/fighter.gd

`gdscript
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
@export var body_mesh: MeshInstance3D
@export var left_arm: Node3D
@export var right_arm: Node3D
var anim_player: AnimationPlayer = null

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

func _ready() -> void:
	load_character_data()

func load_character_data() -> void:
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
		for child in visual_root.get_children():
			child.queue_free()
		anim_player = null
		var model_path: String = "res://assets/models/" + character_id + ".glb"
		if ResourceLoader.exists(model_path):
			var model_res = load(model_path)
			if model_res is PackedScene:
				var inst: Node = model_res.instantiate()
				visual_root.add_child(inst)
				anim_player = inst.find_child("AnimationPlayer", true, false) as AnimationPlayer
				_play_state_animation(current_state)
	
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
	_clamp_within_ring()
	_clear_consumed_pulse_inputs()

func _gather_player_inputs() -> void:
	var prefix: String = "p" + str(player_index) + "_"
	
	input_dir = Vector2.ZERO
	if Input.is_action_pressed(prefix + "up"):
		input_dir.y -= 1.0
	if Input.is_action_pressed(prefix + "down"):
		input_dir.y += 1.0
	if Input.is_action_pressed(prefix + "left"):
		input_dir.x -= 1.0
	if Input.is_action_pressed(prefix + "right"):
		input_dir.x += 1.0
	input_dir = input_dir.normalized()
	
	input_strike = Input.is_action_just_pressed(prefix + "strike")
	input_grapple = Input.is_action_just_pressed(prefix + "grapple")
	input_block = Input.is_action_pressed(prefix + "block")
	input_reversal = Input.is_action_just_pressed(prefix + "reversal")
	var pin_down: bool = Input.is_action_pressed(prefix + "pin")
	input_pin = pin_down and not prev_pin_held
	input_hold_pin = pin_down and prev_pin_held
	prev_pin_held = pin_down
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
			if visual_root:
				visual_root.rotation.x = deg_to_rad(-90.0)
				visual_root.position.y = 0.15
			if state_timer >= knockdown_duration:
				_set_state(State.GETTING_UP)
				
		State.GETTING_UP:
			velocity = Vector3.ZERO
			if visual_root:
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
			if visual_root:
				visual_root.position.y = -0.3
				
		State.PINNED:
			velocity = Vector3.ZERO
			if visual_root:
				visual_root.rotation.x = deg_to_rad(-90.0)
				visual_root.position.y = 0.1
			_process_pin_escape(delta)
			
		State.SUBMISSION_ATTACKER:
			velocity = Vector3.ZERO
			if visual_root:
				visual_root.position.y = -0.25
			_process_submission_attacker(delta)
			
		State.SUBMISSION_DEFENDER:
			velocity = Vector3.ZERO
			if visual_root:
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
			if visual_root:
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
	if right_arm:
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
	if left_arm and right_arm:
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
				
				if left_arm and right_arm:
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
			if left_arm and right_arm:
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
	
	if pin_escape_progress >= 100.0:
		_execute_submission_escape()

func _execute_submission_escape() -> void:
	submission_escaped.emit(self)
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
	tap_out_submitted.emit(self)
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
	
	if pin_escape_progress >= 100.0:
		_execute_kick_out()

func _execute_kick_out() -> void:
	if current_state != State.PINNED:
		return
	kick_out_succeeded.emit(self)
	if visual_root:
		visual_root.rotation = Vector3.ZERO
		visual_root.position = Vector3.ZERO
	_set_state(State.GETTING_UP)
	
	# Push pinning opponent away
	if is_instance_valid(opponent) and opponent.current_state == State.PINNING:
		opponent.on_kick_out_received()

func on_kick_out_received() -> void:
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
	
	# Knockdown on heavy damage or low health
	if not was_blocked and vitality <= 0.0 and current_state != State.KNOCKED_DOWN and current_state != State.PINNED:
		_set_state(State.KNOCKED_DOWN)

func gain_hype(amount: float) -> void:
	var bonus: float = 1.0 + (stat_showmanship * 0.08)
	hype = min(MatchRules.MAX_HYPE, hype + (amount * bonus))
	hype_changed.emit(hype, MatchRules.MAX_HYPE)

func _set_state(new_state: State) -> void:
	if current_state == new_state:
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
	if not is_instance_valid(anim_player):
		return
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
	_set_state(State.VICTORY)

func set_defeated() -> void:
	_set_state(State.DEFEATED)

`

---

## File: scripts/ai/cpu_controller.gd

`gdscript
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

`

---

## File: scripts/ring/broadcast_camera.gd

`gdscript
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

`

---

## File: scripts/ui/character_select.gd

`gdscript
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

`

---

## File: scripts/ui/match_hud.gd

`gdscript
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

`

---

## File: scenes/main.tscn

`ini
[gd_scene format=3 uid="uid://dmainscene01"]

[ext_resource type="Script" path="res://scripts/core/main_scene.gd" id="1_main"]
[ext_resource type="PackedScene" path="res://scenes/arena/ring_arena.tscn" id="2_arena"]
[ext_resource type="PackedScene" path="res://scenes/fighter/fighter.tscn" id="3_fighter"]
[ext_resource type="PackedScene" path="res://scenes/referee/referee.tscn" id="4_referee"]
[ext_resource type="Script" path="res://scripts/core/match_manager.gd" id="5_match"]
[ext_resource type="Script" path="res://scripts/ring/broadcast_camera.gd" id="6_cam"]
[ext_resource type="Script" path="res://scripts/ai/cpu_controller.gd" id="7_cpu"]
[ext_resource type="PackedScene" path="res://scenes/ui/match_hud.tscn" id="8_hud"]
[ext_resource type="Script" path="res://scripts/core/audio_manager.gd" id="9_audio"]

[sub_resource type="Environment" id="Environment_arena"]
background_mode = 1
background_color = Color(0.04, 0.04, 0.05, 1)
ambient_light_source = 2
ambient_light_color = Color(0.25, 0.25, 0.3, 1)
tonemap_mode = 2
glow_enabled = true
glow_intensity = 0.8
glow_bloom = 0.25

[node name="Main" type="Node3D" node_paths=PackedStringArray("fighter_1", "fighter_2", "cpu_controller_p2", "match_manager")]
script = ExtResource("1_main")
fighter_1 = NodePath("Tophiachu")
fighter_2 = NodePath("Cyraxx")
cpu_controller_p2 = NodePath("CPUController_P2")
match_manager = NodePath("MatchManager")

[node name="AudioManager" type="Node" parent="."]
script = ExtResource("9_audio")

[node name="WorldEnvironment" type="WorldEnvironment" parent="."]
environment = SubResource("Environment_arena")

[node name="SpotLight_Center" type="SpotLight3D" parent="."]
transform = Transform3D(1, 0, 0, 0, -4.37114e-08, 1, 0, -1, -4.37114e-08, 0, 9, 0)
light_color = Color(1, 0.98, 0.9, 1)
light_energy = 8.0
spot_range = 16.0
spot_angle = 45.0

[node name="DirectionalLight3D" type="DirectionalLight3D" parent="."]
transform = Transform3D(0.866025, -0.353553, 0.353553, 0, 0.707107, 0.707107, -0.5, -0.612372, 0.612372, 5, 8, 5)
light_color = Color(0.9, 0.9, 0.95, 1)
light_energy = 1.2
shadow_enabled = true

[node name="RingArena" parent="." instance=ExtResource("2_arena")]

[node name="Tophiachu" parent="." instance=ExtResource("3_fighter")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -1.8, 0, 0)
character_id = "tophiachu"
player_index = 1
is_cpu = false

[node name="Cyraxx" parent="." instance=ExtResource("3_fighter")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 1.8, 0, 0)
character_id = "cyraxx"
player_index = 2
is_cpu = true

[node name="CPUController_P2" type="Node" parent="." node_paths=PackedStringArray("fighter")]
script = ExtResource("7_cpu")
fighter = NodePath("../Cyraxx")

[node name="Referee" parent="." instance=ExtResource("4_referee")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, -2.4)

[node name="MatchManager" type="Node" parent="." node_paths=PackedStringArray("fighter_1", "fighter_2", "referee", "hud")]
script = ExtResource("5_match")
fighter_1 = NodePath("../Tophiachu")
fighter_2 = NodePath("../Cyraxx")
referee = NodePath("../Referee")
hud = NodePath("../CanvasLayer/MatchHUD")

[node name="BroadcastCamera" type="Camera3D" parent="." node_paths=PackedStringArray("target_1", "target_2")]
transform = Transform3D(1, 0, 0, 0, 0.866025, 0.5, 0, -0.5, 0.866025, 0, 4.8, 9)
current = true
fov = 55.0
script = ExtResource("6_cam")
target_1 = NodePath("../Tophiachu")
target_2 = NodePath("../Cyraxx")

[node name="CanvasLayer" type="CanvasLayer" parent="."]

[node name="MatchHUD" parent="CanvasLayer" node_paths=PackedStringArray("match_manager") instance=ExtResource("8_hud")]
match_manager = NodePath("../../MatchManager")

`

---

## File: scenes/fighter/fighter.tscn

`ini
[gd_scene format=3 uid="uid://dfighter001"]

[ext_resource type="Script" path="res://scripts/fighter/fighter.gd" id="1_script"]

[sub_resource type="CapsuleShape3D" id="CapsuleShape3D_root"]
radius = 0.45
height = 1.8

[node name="Fighter" type="CharacterBody3D" node_paths=PackedStringArray("visual_root")]
collision_layer = 2
collision_mask = 3
script = ExtResource("1_script")
visual_root = NodePath("VisualRoot")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.9, 0)
shape = SubResource("CapsuleShape3D_root")

[node name="VisualRoot" type="Node3D" parent="."]

`

---

## File: scenes/referee/referee.tscn

`ini
[gd_scene format=3 uid="uid://b23k1v4j7m9n"]

[ext_resource type="Script" path="res://scripts/referee/referee.gd" id="1_script"]
[ext_resource type="PackedScene" path="res://assets/models/referee_cobra.glb" id="2_model"]

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_halo"]
albedo_color = Color(1, 0.85, 0.2, 1)
metallic = 0.2
roughness = 0.1
emission_enabled = true
emission = Color(1, 0.85, 0.2, 1)
emission_energy_multiplier = 3.0

[sub_resource type="TorusMesh" id="TorusMesh_halo"]
material = SubResource("StandardMaterial3D_halo")
inner_radius = 0.3
outer_radius = 0.38
rings = 24
ring_segments = 16

[node name="Referee" type="Node3D" node_paths=PackedStringArray("halo_node", "mesh_instance", "count_label_3d")]
script = ExtResource("1_script")
halo_node = NodePath("HaloAnchor")
mesh_instance = NodePath("ModelAnchor")
count_label_3d = NodePath("CountLabel3D")

[node name="ModelAnchor" type="Node3D" parent="."]

[node name="Model" parent="ModelAnchor" instance=ExtResource("2_model")]

[node name="HaloAnchor" type="Node3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2.3, 0)

[node name="HaloMesh" type="MeshInstance3D" parent="HaloAnchor"]
mesh = SubResource("TorusMesh_halo")
surface_material_override/0 = SubResource("StandardMaterial3D_halo")

[node name="CountLabel3D" type="Label3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 2.7, 0)
billboard = 1
font_size = 64
outline_size = 16
text = "1!"

`

---

## File: scenes/arena/ring_arena.tscn

`ini
[gd_scene format=3 uid="uid://dpw54n6g87v8"]

[ext_resource type="PackedScene" path="res://assets/models/ring_arena.glb" id="1_arena"]

[sub_resource type="BoxShape3D" id="BoxShape3D_mat"]
size = Vector3(8, 0.4, 8)

[sub_resource type="BoxShape3D" id="BoxShape3D_rope_ns"]
size = Vector3(8, 2, 0.2)

[sub_resource type="BoxShape3D" id="BoxShape3D_rope_ew"]
size = Vector3(0.2, 2, 8)

[node name="RingArena" type="Node3D"]

[node name="Model" parent="." instance=ExtResource("1_arena")]

[node name="RingFloorCollision" type="StaticBody3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.2, 0)
collision_layer = 1
collision_mask = 3

[node name="CollisionShape3D" type="CollisionShape3D" parent="RingFloorCollision"]
shape = SubResource("BoxShape3D_mat")

[node name="RopeNorth" type="StaticBody3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 3.85)
collision_layer = 1
collision_mask = 2

[node name="CollisionShape3D" type="CollisionShape3D" parent="RopeNorth"]
shape = SubResource("BoxShape3D_rope_ns")

[node name="RopeSouth" type="StaticBody3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, -3.85)
collision_layer = 1
collision_mask = 2

[node name="CollisionShape3D" type="CollisionShape3D" parent="RopeSouth"]
shape = SubResource("BoxShape3D_rope_ns")

[node name="RopeEast" type="StaticBody3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 3.85, 1, 0)
collision_layer = 1
collision_mask = 2

[node name="CollisionShape3D" type="CollisionShape3D" parent="RopeEast"]
shape = SubResource("BoxShape3D_rope_ew")

[node name="RopeWest" type="StaticBody3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, -3.85, 1, 0)
collision_layer = 1
collision_mask = 2

[node name="CollisionShape3D" type="CollisionShape3D" parent="RopeWest"]
shape = SubResource("BoxShape3D_rope_ew")

`

---

## File: scenes/ui/character_select.tscn

`ini
[gd_scene format=3 uid="uid://dcharselect01"]

[ext_resource type="Script" path="res://scripts/ui/character_select.gd" id="1_script"]
[ext_resource type="Script" path="res://scripts/core/audio_manager.gd" id="2_audio"]

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_bg"]
bg_color = Color(0.06, 0.06, 0.08, 1)

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_card_p1"]
bg_color = Color(0.08, 0.12, 0.16, 0.9)
border_width_left = 3
border_width_top = 3
border_width_right = 3
border_width_bottom = 3
border_color = Color(0.2, 0.7, 0.9, 0.8)
corner_radius_top_left = 8
corner_radius_top_right = 8
corner_radius_bottom_right = 8
corner_radius_bottom_left = 8

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_card_p2"]
bg_color = Color(0.16, 0.08, 0.08, 0.9)
border_width_left = 3
border_width_top = 3
border_width_right = 3
border_width_bottom = 3
border_color = Color(0.9, 0.3, 0.3, 0.8)
corner_radius_top_left = 8
corner_radius_top_right = 8
corner_radius_bottom_right = 8
corner_radius_bottom_left = 8

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_grid"]
bg_color = Color(0.1, 0.1, 0.12, 0.85)
corner_radius_top_left = 8
corner_radius_top_right = 8
corner_radius_bottom_right = 8
corner_radius_bottom_left = 8

[node name="CharacterSelect" type="Control" node_paths=PackedStringArray("grid_container", "p1_name_label", "p1_title_label", "p1_archetype_label", "p1_stats_container", "p1_finisher_label", "p1_trait_label", "p2_name_label", "p2_title_label", "p2_archetype_label", "p2_stats_container", "p2_finisher_label", "p2_trait_label", "cpu_toggle_button", "start_match_button")]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1_script")
grid_container = NodePath("CenterPanel/GridContainer")
p1_name_label = NodePath("P1_Card/VBox/Name")
p1_title_label = NodePath("P1_Card/VBox/Title")
p1_archetype_label = NodePath("P1_Card/VBox/Archetype")
p1_stats_container = NodePath("P1_Card/VBox/Stats")
p1_finisher_label = NodePath("P1_Card/VBox/Finisher")
p1_trait_label = NodePath("P1_Card/VBox/Trait")
p2_name_label = NodePath("P2_Card/VBox/Name")
p2_title_label = NodePath("P2_Card/VBox/Title")
p2_archetype_label = NodePath("P2_Card/VBox/Archetype")
p2_stats_container = NodePath("P2_Card/VBox/Stats")
p2_finisher_label = NodePath("P2_Card/VBox/Finisher")
p2_trait_label = NodePath("P2_Card/VBox/Trait")
cpu_toggle_button = NodePath("CenterPanel/VBoxActions/CPUToggleBtn")
start_match_button = NodePath("CenterPanel/VBoxActions/StartMatchBtn")

[node name="AudioManager" type="Node" parent="."]
script = ExtResource("2_audio")

[node name="Background" type="Panel" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
theme_override_styles/panel = SubResource("StyleBoxFlat_bg")

[node name="Header" type="VBoxContainer" parent="."]
layout_mode = 1
anchors_preset = 10
anchor_right = 1.0
offset_top = 25.0
offset_bottom = 105.0
grow_horizontal = 2
theme_override_constants/separation = 4

[node name="Title" type="Label" parent="Header"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 0.85, 0.25, 1)
theme_override_font_sizes/font_size = 36
text = "LOLCOW WRESTLING: OFFLINE MAYHEM"
horizontal_alignment = 1

[node name="Subtitle" type="Label" parent="Header"]
layout_mode = 2
theme_override_colors/font_color = Color(0.7, 0.7, 0.75, 1)
theme_override_font_sizes/font_size = 18
text = "CHOOSE YOUR FIGHTER"
horizontal_alignment = 1

[node name="P1_Card" type="PanelContainer" parent="."]
layout_mode = 1
anchors_preset = 9
anchor_bottom = 1.0
offset_left = 40.0
offset_top = 130.0
offset_right = 380.0
offset_bottom = -70.0
grow_vertical = 2
theme_override_styles/panel = SubResource("StyleBoxFlat_card_p1")

[node name="VBox" type="VBoxContainer" parent="P1_Card"]
layout_mode = 2
offset_left = 15.0
offset_top = 15.0
offset_right = 325.0
offset_bottom = 865.0
theme_override_constants/separation = 10

[node name="Tag" type="Label" parent="P1_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(0.2, 0.8, 1, 1)
theme_override_font_sizes/font_size = 20
text = "PLAYER 1"

[node name="Name" type="Label" parent="P1_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 1, 1, 1)
theme_override_font_sizes/font_size = 26
text = "TOPHIACHU"

[node name="Title" type="Label" parent="P1_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(0.8, 0.8, 0.5, 1)
theme_override_font_sizes/font_size = 14
text = "\"Live & Unfiltered\""

[node name="Archetype" type="Label" parent="P1_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(0.65, 0.85, 0.65, 1)
theme_override_font_sizes/font_size = 15
text = "Heavyweight Counter-Brawler"

[node name="HSeparator1" type="HSeparator" parent="P1_Card/VBox"]
layout_mode = 2

[node name="Stats" type="VBoxContainer" parent="P1_Card/VBox"]
layout_mode = 2
theme_override_constants/separation = 6

[node name="HSeparator2" type="HSeparator" parent="P1_Card/VBox"]
layout_mode = 2

[node name="Finisher" type="Label" parent="P1_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 0.6, 0.3, 1)
theme_override_font_sizes/font_size = 15
text = "FINISHER: Live-Stream Shutdown"
autowrap_mode = 2

[node name="Trait" type="Label" parent="P1_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(0.9, 0.9, 0.5, 1)
theme_override_font_sizes/font_size = 14
text = "TRAIT: Last Word"
autowrap_mode = 2

[node name="Prompt" type="Label" parent="P1_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(0.5, 0.7, 0.8, 1)
theme_override_font_sizes/font_size = 13
text = "\n[W/A/S/D] Navigate P1"

[node name="P2_Card" type="PanelContainer" parent="."]
layout_mode = 1
anchors_preset = 11
anchor_left = 1.0
anchor_right = 1.0
anchor_bottom = 1.0
offset_left = -380.0
offset_top = 130.0
offset_right = -40.0
offset_bottom = -70.0
grow_horizontal = 0
grow_vertical = 2
theme_override_styles/panel = SubResource("StyleBoxFlat_card_p2")

[node name="VBox" type="VBoxContainer" parent="P2_Card"]
layout_mode = 2
offset_left = 15.0
offset_top = 15.0
offset_right = 325.0
offset_bottom = 865.0
theme_override_constants/separation = 10

[node name="Tag" type="Label" parent="P2_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 0.3, 0.3, 1)
theme_override_font_sizes/font_size = 20
text = "PLAYER 2"

[node name="Name" type="Label" parent="P2_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 1, 1, 1)
theme_override_font_sizes/font_size = 26
text = "CYRAXX"

[node name="Title" type="Label" parent="P2_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(0.8, 0.8, 0.5, 1)
theme_override_font_sizes/font_size = 14
text = "\"Feedback Frenzy\""

[node name="Archetype" type="Label" parent="P2_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(0.65, 0.85, 0.65, 1)
theme_override_font_sizes/font_size = 15
text = "Lightweight Burst Striker"

[node name="HSeparator1" type="HSeparator" parent="P2_Card/VBox"]
layout_mode = 2

[node name="Stats" type="VBoxContainer" parent="P2_Card/VBox"]
layout_mode = 2
theme_override_constants/separation = 6

[node name="HSeparator2" type="HSeparator" parent="P2_Card/VBox"]
layout_mode = 2

[node name="Finisher" type="Label" parent="P2_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 0.6, 0.3, 1)
theme_override_font_sizes/font_size = 15
text = "FINISHER: Raxx and Ruin"
autowrap_mode = 2

[node name="Trait" type="Label" parent="P2_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(0.9, 0.9, 0.5, 1)
theme_override_font_sizes/font_size = 14
text = "TRAIT: Overdrive"
autowrap_mode = 2

[node name="Prompt" type="Label" parent="P2_Card/VBox"]
layout_mode = 2
theme_override_colors/font_color = Color(0.8, 0.5, 0.5, 1)
theme_override_font_sizes/font_size = 13
text = "\n[Arrows] Navigate P2"

[node name="CenterPanel" type="Panel" parent="."]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -540.0
offset_top = -410.0
offset_right = 540.0
offset_bottom = 470.0
grow_horizontal = 2
grow_vertical = 2
theme_override_styles/panel = SubResource("StyleBoxFlat_grid")

[node name="GridContainer" type="GridContainer" parent="CenterPanel"]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -380.0
offset_top = -180.0
offset_right = 380.0
offset_bottom = 60.0
grow_horizontal = 2
grow_vertical = 2
theme_override_constants/h_separation = 20
theme_override_constants/v_separation = 20
columns = 4

[node name="VBoxActions" type="VBoxContainer" parent="CenterPanel"]
layout_mode = 1
anchors_preset = 7
anchor_left = 0.5
anchor_top = 1.0
anchor_right = 0.5
anchor_bottom = 1.0
offset_left = -220.0
offset_top = -340.0
offset_right = 220.0
offset_bottom = -200.0
grow_horizontal = 2
grow_vertical = 0
theme_override_constants/separation = 16

[node name="CPUToggleBtn" type="Button" parent="CenterPanel/VBoxActions"]
custom_minimum_size = Vector2(0, 48)
layout_mode = 2
theme_override_font_sizes/font_size = 18
text = "P2 MODE: [CPU]"

[node name="StartMatchBtn" type="Button" parent="CenterPanel/VBoxActions"]
custom_minimum_size = Vector2(0, 56)
layout_mode = 2
theme_override_colors/font_color = Color(1, 0.9, 0.2, 1)
theme_override_font_sizes/font_size = 22
text = "FIGHT! [SPACE / ENTER]"

[node name="Footer" type="VBoxContainer" parent="."]
layout_mode = 1
anchors_preset = 12
anchor_top = 1.0
anchor_right = 1.0
anchor_bottom = 1.0
offset_top = -65.0
offset_bottom = -15.0
grow_horizontal = 2
grow_vertical = 0
theme_override_constants/separation = 4

[node name="Instructions" type="Label" parent="Footer"]
layout_mode = 2
theme_override_colors/font_color = Color(0.7, 0.7, 0.75, 1)
theme_override_font_sizes/font_size = 15
text = "[W/A/S/D] P1 Select  |  [Arrows] P2 Select  |  [C] Toggle P2 CPU  |  [SPACE / ENTER] Start Match"
horizontal_alignment = 1

[node name="RefereeMemorial" type="Label" parent="Footer"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 0.85, 0.3, 0.9)
theme_override_font_sizes/font_size = 14
text = "Official Referee: KingCobraJFS (1991–2025) presiding over all bouts with pulsing golden halo."
horizontal_alignment = 1

`

---

## File: scenes/ui/match_hud.tscn

`ini
[gd_scene format=3 uid="uid://dmhud001"]

[ext_resource type="Script" path="res://scripts/ui/match_hud.gd" id="1_script"]

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_p1_hp"]
bg_color = Color(0.85, 0.15, 0.2, 1)
corner_radius_top_left = 4
corner_radius_top_right = 4
corner_radius_bottom_right = 4
corner_radius_bottom_left = 4

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_p1_sta"]
bg_color = Color(0.2, 0.75, 0.35, 1)
corner_radius_top_left = 2
corner_radius_top_right = 2
corner_radius_bottom_right = 2
corner_radius_bottom_left = 2

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_hype"]
bg_color = Color(0.85, 0.65, 0.1, 1)
corner_radius_top_left = 2
corner_radius_top_right = 2
corner_radius_bottom_right = 2
corner_radius_bottom_left = 2

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_bg"]
bg_color = Color(0.1, 0.1, 0.12, 0.8)
corner_radius_top_left = 4
corner_radius_top_right = 4
corner_radius_bottom_right = 4
corner_radius_bottom_left = 4

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_panel"]
bg_color = Color(0.05, 0.05, 0.07, 0.88)
border_width_left = 2
border_width_top = 2
border_width_right = 2
border_width_bottom = 2
border_color = Color(0.9, 0.75, 0.2, 1)
corner_radius_top_left = 8
corner_radius_top_right = 8
corner_radius_bottom_right = 8
corner_radius_bottom_left = 8

[node name="MatchHUD" type="Control" node_paths=PackedStringArray("p1_name_label", "p1_title_label", "p1_vitality_bar", "p1_stamina_bar", "p1_hype_bar", "p1_state_label", "p2_name_label", "p2_title_label", "p2_vitality_bar", "p2_stamina_bar", "p2_hype_bar", "p2_state_label", "center_announcement", "pin_escape_container", "pin_escape_bar", "victory_panel", "victory_label")]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1_script")
p1_name_label = NodePath("P1_Container/Name")
p1_title_label = NodePath("P1_Container/Title")
p1_vitality_bar = NodePath("P1_Container/VitalityBar")
p1_stamina_bar = NodePath("P1_Container/StaminaBar")
p1_hype_bar = NodePath("P1_Container/HypeBar")
p1_state_label = NodePath("P1_Container/State")
p2_name_label = NodePath("P2_Container/Name")
p2_title_label = NodePath("P2_Container/Title")
p2_vitality_bar = NodePath("P2_Container/VitalityBar")
p2_stamina_bar = NodePath("P2_Container/StaminaBar")
p2_hype_bar = NodePath("P2_Container/HypeBar")
p2_state_label = NodePath("P2_Container/State")
center_announcement = NodePath("CenterAnnouncement")
pin_escape_container = NodePath("PinEscapeContainer")
pin_escape_bar = NodePath("PinEscapeContainer/ProgressBar")
victory_panel = NodePath("VictoryPanel")
victory_label = NodePath("VictoryPanel/Label")

[node name="P1_Container" type="VBoxContainer" parent="."]
layout_mode = 0
offset_left = 40.0
offset_top = 30.0
offset_right = 460.0
offset_bottom = 160.0

[node name="Name" type="Label" parent="P1_Container"]
layout_mode = 2
theme_override_font_sizes/font_size = 26
text = "TOPHIACHU"

[node name="Title" type="Label" parent="P1_Container"]
layout_mode = 2
theme_override_colors/font_color = Color(0.8, 0.8, 0.8, 1)
theme_override_font_sizes/font_size = 14
text = "Live & Unfiltered"

[node name="VitalityBar" type="ProgressBar" parent="P1_Container"]
custom_minimum_size = Vector2(0, 24)
layout_mode = 2
theme_override_styles/background = SubResource("StyleBoxFlat_bg")
theme_override_styles/fill = SubResource("StyleBoxFlat_p1_hp")
value = 100.0
show_percentage = false

[node name="StaminaBar" type="ProgressBar" parent="P1_Container"]
custom_minimum_size = Vector2(0, 10)
layout_mode = 2
theme_override_styles/background = SubResource("StyleBoxFlat_bg")
theme_override_styles/fill = SubResource("StyleBoxFlat_p1_sta")
value = 100.0
show_percentage = false

[node name="HypeBar" type="ProgressBar" parent="P1_Container"]
custom_minimum_size = Vector2(0, 8)
layout_mode = 2
theme_override_styles/background = SubResource("StyleBoxFlat_bg")
theme_override_styles/fill = SubResource("StyleBoxFlat_hype")
value = 0.0
show_percentage = false

[node name="State" type="Label" parent="P1_Container"]
layout_mode = 2
theme_override_colors/font_color = Color(0.9, 0.7, 0.2, 1)
theme_override_font_sizes/font_size = 14
text = "IDLE"

[node name="P2_Container" type="VBoxContainer" parent="."]
layout_mode = 1
anchors_preset = 1
anchor_left = 1.0
anchor_right = 1.0
offset_left = -460.0
offset_top = 30.0
offset_right = -40.0
offset_bottom = 160.0
grow_horizontal = 0

[node name="Name" type="Label" parent="P2_Container"]
layout_mode = 2
theme_override_font_sizes/font_size = 26
text = "CYRAXX"
horizontal_alignment = 2

[node name="Title" type="Label" parent="P2_Container"]
layout_mode = 2
theme_override_colors/font_color = Color(0.8, 0.8, 0.8, 1)
theme_override_font_sizes/font_size = 14
text = "Feedback Frenzy"
horizontal_alignment = 2

[node name="VitalityBar" type="ProgressBar" parent="P2_Container"]
custom_minimum_size = Vector2(0, 24)
layout_mode = 2
theme_override_styles/background = SubResource("StyleBoxFlat_bg")
theme_override_styles/fill = SubResource("StyleBoxFlat_p1_hp")
value = 100.0
fill_mode = 1
show_percentage = false

[node name="StaminaBar" type="ProgressBar" parent="P2_Container"]
custom_minimum_size = Vector2(0, 10)
layout_mode = 2
theme_override_styles/background = SubResource("StyleBoxFlat_bg")
theme_override_styles/fill = SubResource("StyleBoxFlat_p1_sta")
value = 100.0
fill_mode = 1
show_percentage = false

[node name="HypeBar" type="ProgressBar" parent="P2_Container"]
custom_minimum_size = Vector2(0, 8)
layout_mode = 2
theme_override_styles/background = SubResource("StyleBoxFlat_bg")
theme_override_styles/fill = SubResource("StyleBoxFlat_hype")
value = 0.0
fill_mode = 1
show_percentage = false

[node name="State" type="Label" parent="P2_Container"]
layout_mode = 2
theme_override_colors/font_color = Color(0.9, 0.7, 0.2, 1)
theme_override_font_sizes/font_size = 14
text = "IDLE"
horizontal_alignment = 2

[node name="CenterAnnouncement" type="Label" parent="."]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -300.0
offset_top = -120.0
offset_right = 300.0
offset_bottom = -40.0
grow_horizontal = 2
grow_vertical = 2
theme_override_colors/font_color = Color(1, 0.9, 0.2, 1)
theme_override_colors/font_outline_color = Color(0, 0, 0, 1)
theme_override_constants/outline_size = 12
theme_override_font_sizes/font_size = 48
text = "COUNT: 1!"
horizontal_alignment = 1
vertical_alignment = 1

[node name="PinEscapeContainer" type="VBoxContainer" parent="."]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -250.0
offset_top = 20.0
offset_right = 250.0
offset_bottom = 90.0
grow_horizontal = 2
grow_vertical = 2

[node name="Label" type="Label" parent="PinEscapeContainer"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 1, 1, 1)
theme_override_colors/font_outline_color = Color(0, 0, 0, 1)
theme_override_constants/outline_size = 8
theme_override_font_sizes/font_size = 20
text = "TAP [SPACE] / [NUM0] TO KICK OUT!"
horizontal_alignment = 1

[node name="ProgressBar" type="ProgressBar" parent="PinEscapeContainer"]
custom_minimum_size = Vector2(0, 22)
layout_mode = 2
theme_override_styles/background = SubResource("StyleBoxFlat_bg")
theme_override_styles/fill = SubResource("StyleBoxFlat_p1_sta")
value = 0.0
show_percentage = true

[node name="ControlsReminder" type="Label" parent="."]
layout_mode = 1
anchors_preset = 12
anchor_top = 1.0
anchor_right = 1.0
anchor_bottom = 1.0
offset_top = -45.0
grow_horizontal = 2
grow_vertical = 0
theme_override_colors/font_color = Color(0.85, 0.85, 0.9, 0.9)
theme_override_colors/font_outline_color = Color(0, 0, 0, 1)
theme_override_constants/outline_size = 6
theme_override_font_sizes/font_size = 14
text = "P1: WASD=Move | J=Strike | K=Grapple | L=Block | U=Reversal | SPACE=Pin  ||  P2: Arrows=Move | Num1=Strike | Num2=Grapple | Num3=Block | Num4=Reversal | Num0=Pin  ||  [R] Restart"
horizontal_alignment = 1
vertical_alignment = 1

[node name="VictoryPanel" type="PanelContainer" parent="."]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -350.0
offset_top = -140.0
offset_right = 350.0
offset_bottom = 140.0
grow_horizontal = 2
grow_vertical = 2
theme_override_styles/panel = SubResource("StyleBoxFlat_panel")

[node name="Label" type="Label" parent="VictoryPanel"]
layout_mode = 2
theme_override_colors/font_color = Color(1, 0.88, 0.3, 1)
theme_override_colors/font_outline_color = Color(0, 0, 0, 1)
theme_override_constants/outline_size = 10
theme_override_font_sizes/font_size = 36
text = "TOPHIACHU WINS!
[PINFALL 3-COUNT]

Press [R] to Restart Match"
horizontal_alignment = 1
vertical_alignment = 1

`

---

## File: tests/test_suite.gd

`gdscript
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
	
	manager.queue_free()
	f1.queue_free()
	f2.queue_free()

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
	assert_true(tap_out_called[0], "Depleting vitality during submission results in SUBMISSION (TAP OUT) victory")
	assert_true(manager.current_state == MatchManager.MatchState.MATCH_OVER, "Match terminates with MATCH_OVER on tap-out")
	
	manager.queue_free()
	f1.queue_free()
	f2.queue_free()

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



`

---

## File: tests/test_pin_balance_scene.gd

`gdscript
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

`

---

