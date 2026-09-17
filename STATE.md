# Project State: LOLCOW WRESTLING: OFFLINE MAYHEM

## Milestone Status: M0-M1 Functional -> Pass A Repairs (Exclusive Terminal Outcome Ownership & Priority Scheduling Complete)
- **Engine**: Godot 4.7.2 (stable official, Windows x64) - Installed & Verified.
- **3D DCC Pipeline**: Blender 5.0.1 (headless Python automation) - Verified.
- **Target**: 1080p @ 60 FPS, Windows standalone.
- **Authoritative Combat Loop & Integration**: Verified with 517 automated headless tests (391 focused unit/mechanics tests + 126 full scene physics integration tests, 0 failures, 0 warnings, 0 ObjectDB leaks).
- **M2/M3 Status**: Functional baseline established. Skeletal animation rigging, authored unique animation clips, and manual visual inspections remain **NOT RUN / PENDING** per code review requirements.

### Pass A Codebase Repairs & Verifications:
1. **Exclusive Terminal Outcome Ownership & Priority Scheduling (Verified & Accepted)**:
   - Eliminated competing outcome resolution between `Fighter` and `MatchManager`. `MatchManager` holds exclusive authority over terminal match outcomes (`_process_submission_watch`, `_process_pin_countdown`, `_resolve_pin_kick_out`, `_resolve_submission_escape`, `_resolve_submission_tap_out`).
   - Enforced deterministic engine scheduling via `process_physics_priority`: `Fighter` = 0 (ticks movement, resistance inputs, damage, and escape progress) and `MatchManager` = 10 (authoritatively evaluates rules, counts, rope breaks, and outcomes after all participants finish their physics tick).
   - In active matches, fighter callbacks (`_process_submission_attacker`, `_process_submission_defender`, `_process_pin_escape`) update resource values without executing fighter-level match endings.
   - Guarded terminal states against callback overwrite: `_set_state()` strictly blocks transitions out of `VICTORY` or `DEFEATED` to gameplay states (`GETTING_UP`, `IDLE`). `_execute_submission_escape()`, `on_tap_out()`, `_execute_kick_out()`, and `on_kick_out_received()` guard against overwriting manager decisions.
   - Symmetrically cleared paired pointers (`synchronized_partner = null`) on both participants across all breakout, rope break, pinfall, and tap-out pathways.
   - Tested and verified:
     - Real simultaneous submission threshold crossing from legitimate below-threshold values ($vit = 5.0$, $prog = 95.0$, $timer = 0.49$) across all 4 slot and tree permutations under both `ESCAPE_BREAKS` and `TAPOUT_WINS`.
     - Direct callback invocation resilience preventing post-manager state corruption.
     - Final-count kickout crossing ($99.0 \to 100+$) on tick 198 (3.30s) across manager-first and defender-first scene trees.
     - Real scene integration frames (`test_pin_balance_scene.gd`) with 126 passing tests.
2. **Pin-Balance Acceptance & Empirical Sequence Validation (Verified & Accepted)**:
   - Evaluated actual gameplay throw-to-pin sequences in Godot scene physics (`scenes/fighter/fighter.tscn`, `MatchManager`, `Referee`, `CPUController` using engine `await physics_frame` steps).
   - Verified that fresh Cyraxx taking an ordinary Tophiachu throw (177 damage, HP 663/850, 100% stamina) kicks out before Count 2 (~1.5s–1.6s) across all 4 modes:
     - Mode 1 (CPU commands): Count 1, 1.62s KICKOUT.
     - Mode 2 (Human 10 Hz mash): Count 1, 1.52s KICKOUT.
     - Mode 3 (Hold-to-resist on entry): Count 1, 1.53s KICKOUT.
     - Mode 4 (Hold-to-resist pre-held): Count 1, 1.62s KICKOUT.
   - Verified that weakened Cyraxx taking a genuine finisher throw from Tophiachu suffers legitimate 3-count pinfall defeats across all 4 modes.
3. **Explicit Move-Metadata Impact Classification (Verified)**:
   - Repaired flaw where `amount >= 100.0` caused ordinary heavy throws (177 damage) to trigger 45% finisher escape penalties.
   - Decoupled move pressure:
     - Finisher pressure (`recent_finisher_impact_timer`): 4.5s duration, 0.55 multiplier, gated strictly by `is_finisher == true`.
     - Ordinary heavy impact pressure (`recent_heavy_impact_timer`): 1.5s duration, 0.85 multiplier, triggered on unblocked hits $\ge 80.0$ damage.
4. **Hold-to-Resist Accessibility Parity (Verified)**:
   - Tuned `PIN_ESCAPE_BASE_RATE = 85.0`/s and `PIN_ESCAPE_MASH_BASE = 10.0`/pulse (at 10 Hz = 100.0/s).
   - Proportional stamina consumption: hold drains 8.0/s; mash drains 0.8/pulse (8.0/s at 10 Hz).
5. **Deterministic Final-Tick Priority Resolution (Tick 198 / 3.30s) (Verified)**:
   - Fixed floating point epsilon (`+ 0.0005`) ensuring Count 3 resolves at tick 198 (3.30s).
   - Enforced strict preemptive priority: kick-out ($\ge 100.0$) and rope breaks immediately waive off 3-count and return match state to `IN_PROGRESS`.
   - Verified across both player slots (P1/P2 and P2/P1) and tree processing orders (Fighter before MatchManager and MatchManager before Fighter).
   - Guarded `_end_match` against repeat calls, ensuring `match_ended` is emitted strictly once.
6. **Unified Command Interface for Escapes (Verified in Pass A)**:
   - `Fighter` escape logic consumes command inputs (`input_pin`, `input_strike`, `input_grapple`, `input_block`, `input_hold_pin`) without hardware polling overwriting programmatic commands.
7. **Throw Height Ownership (Verified in Center Ring)**:
   - Attacker retains sole vertical authority (1.55m peak verified in center ring).
8. **Standardized Forward-Axis Conventions (Verified in Pass A)**:
   - Synchronized throws and locomotion unified on standard Godot convention `atan2(-dx, -dz)`.
9. **Boundary-Safe Paired Throws with Pre-Throw Trajectory Validation (Verified in Pass A Priority 2)**:
   - Implemented `_validate_and_adjust_throw_boundaries()` in `Fighter._start_synchronized_throw()`.
   - Calculates predicted slam impact position $\vec{P}_{\text{slam}} = \vec{P}_{\text{atk}} + \vec{F} \times d_{\text{slam}}$ and shifts the grappling pair inward toward ring center such that both attacker, defender, and landing coordinates remain $\le 3.50\text{m}$ (inside $3.65\text{m}$ rope threshold).
   - Clamped intermediate synchronized lift (`hold_pos`) and landing (`slam_pos`) coordinates to `THROW_SAFE_RING_BOUND = 3.50m` to provide defense-in-depth during multi-frame execution.
   - Confirmed zero out-of-bounds trajectory and zero snap-back across all 4 ring edges (North, South, East, West) and all 4 corners (NE, NW, SE, SW) across slot inversions and tree processing orders (32 edge/corner/slot permutations, 128 boundary assertions).
10. **Directional Strike Cones & Measurable Grapple Startup (Verified in Pass A Priority 3)**:
    - Enforced 120-degree forward contact cone ($\cos(60^\circ) = 0.50$, `STRIKE_CONE_MIN_DOT = 0.50`) in `Fighter._handle_strike_active_window()`. Verified that strikes connect when defender is in front ($0^\circ$, dot = 1.0) or angled ($45^\circ$, dot = 0.707), but strictly miss defenders on side flanks ($90^\circ$, dot = 0.0) or behind ($180^\circ$, dot = -1.0).
    - Implemented measurable `GRAPPLE_STARTUP` window (`MatchRules.GRAPPLE_STARTUP_DURATION = 0.18s`, whiff recovery 0.25s) with procedural reaching arm animation.
    - Verified strike interruption: incoming unblocked strikes during `GRAPPLE_STARTUP` immediately interrupt attacker back to `IDLE`, clear target references, and prevent throw execution.
    - Verified reversal counters: defender inputting `REVERSAL_STANCE` during startup successfully counters the attacker upon startup completion, inflicting counter damage, knockdown, and awarding hype.
    - Upgraded `CPUController` to actively detect opponent `GRAPPLE_STARTUP` within range and retaliate with strike interruptions or reversal counters based on stats.

### Active Open Items from Code Review:
1. **Manual Visual Inspection & Skeletal Rigging**: Visual checks and authored animations remain **NOT RUN** per code review specification.

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
