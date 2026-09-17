## Active Open Issues & Defects Under Repair

1. **Skeletal Animation Pipeline & Unique Moveset Data (Open)**:
   - 3D character models are composed of procedural primitive geometries without bones or skeletal clips. Throws and strikes utilize parameterized programmatic tweening rather than distinct motion-captured or keyframed animation clips.
2. **Visual Checks & Authored Animations Status**:
   - Visual rendering inspections and authored skeletal animations remain **NOT RUN** per code review requirements.

---

## Resolved in Pass A & Prior Milestones

1. **Exclusive Terminal Outcome Ownership & Deterministic Scheduling (Resolved in Pass A Terminal Ownership)**:
   - Fixed competing ownership between `Fighter` and `MatchManager`: `MatchManager` has exclusive authority over terminal match outcome declarations (`_process_submission_watch()`, `_process_pin_countdown()`, `_resolve_pin_kick_out()`, `_resolve_submission_escape()`, `_resolve_submission_tap_out()`).
   - Assigned deterministic engine priorities: `Fighter.process_physics_priority = 0` and `MatchManager.process_physics_priority = 10`, ensuring fighters fully update resistance inputs, damage, and progress before `MatchManager` evaluates rules.
   - Symmetrically cleared `synchronized_partner = null` on both participants when entering terminal outcomes.
   - Guarded terminal states `VICTORY` and `DEFEATED` in `_set_state()` against being overwritten by gameplay callbacks (`GETTING_UP`, `IDLE`).
   - Guarded fighter callbacks (`_execute_submission_escape()`, `on_tap_out()`, `_execute_kick_out()`, `on_kick_out_received()`) against overwriting manager decisions.
   - Preserved programmatic pulse inputs in `_gather_player_inputs()` so injected test/AI commands are accurately consumed.
   - Fully tested across slot inversions and tree processing orders with real scene physics frames (126 scene tests, 391 unit tests, 0 failures).
2. **Simultaneous Submission Outcome Ordering & Centralized Hold Cleanup (Resolved in Pass A Priority 4)**:
   - Established explicit simultaneous priority policy in `MatchManager` (`MatchRules.SUBMISSION_SIMULTANEOUS_PRIORITY = MatchRules.SubmissionPriority.ESCAPE_BREAKS`).
   - Decoupled terminal submission resolution from individual fighter update frames into `MatchManager` resolvers: `_resolve_submission_escape()` and `_resolve_submission_tap_out()`.
   - Guaranteed identical, deterministic outcomes across all 4 permutations of slot orders (P1/P2 vs P2/P1) and tree processing orders (Attacker-first vs Defender-first).
   - Enforced centralized, symmetrical hold cleanup: `synchronized_partner = null` cleared on both sides during all breakout, rope break, and tap-out transitions with zero dangling references.
3. **Directional Attack Contact & Grapple Startup (Resolved in Pass A Priority 3)**:
   - Added forward directional dot-product gating (`STRIKE_CONE_MIN_DOT = 0.50`, 120-degree cone) to `_handle_strike_active_window()`, preventing strikes from connecting with targets on flanks or behind the attacker.
   - Enforced measurable `GRAPPLE_STARTUP` window (`GRAPPLE_STARTUP_DURATION = 0.18s`, whiff recovery 0.25s) in `_attempt_grapple()` and `_process_grapple_startup()`.
   - Verified that unblocked incoming strikes interrupt attacker out of `GRAPPLE_STARTUP` and clear target reference, preventing throw execution.
   - Verified that defender reversal stance during startup successfully counters the attacker.
   - Upgraded `CPUController` to retaliate against opponent `GRAPPLE_STARTUP` via strike interruption or reversal counter.
3. **Boundary Safety During Throws (Resolved in Pass A Priority 2)**:
   - Added `_validate_and_adjust_throw_boundaries()` before locking synchronized throws. Evaluates predicted slam target $\vec{P}_{\text{slam}} = \vec{P}_{\text{atk}} + \vec{F} \times d_{\text{slam}}$ and shifts both attacker and defender inward toward center ring so landing coordinates and hold coordinates remain $\le 3.50\text{m}$ (inside the $3.65\text{m}$ ring limit).
   - Added secondary clamping in `_process_synchronized_attacker()` for `hold_pos` and `slam_pos`.
   - Verified across 32 edge, corner, slot, and tree permutations (128 assertions) with zero out-of-bounds trajectory and zero ground release snap-back.
4. **Pin-Balance Acceptance & Empirical Sequence Validation (Resolved in Pass A Pinfall Balance)**:
   - Replaced flat-rate escape formula with an authoritative resource-aware model factoring in quadratic vitality, remaining stamina, reversal stats, and explicit move-metadata impact disorientation.
   - Eliminated the bug where ordinary heavy throws ($\ge 100$ damage) inflicted finisher disorientation; ordinary heavy throws (177 dmg) now trigger a mild 1.5s heavy impact timer (0.85 mult) allowing healthy defenders to kick out swiftly, while genuine finishers inflict a 4.5s disorientation (0.55 mult).
   - Balanced hold-to-resist as an accessibility alternative at 85.0 base/sec with proportional 8.0/s stamina drain (~85% of 10 Hz mashing speed).
   - Resolved tick 198 (3.30s) floating point boundary precision (`+ 0.0005`) and made kickout ($\ge 100.0$) and rope break strictly preempt the 3-count pinfall across all slot inversions and tree processing orders.
   - Empirically validated across 56 real engine physics tests (`tests/test_pin_balance_scene.gd`) that fresh Cyraxx kicks out at Count 1 (~1.5s–1.6s) across all 4 modes (CPU, 10 Hz mash, hold-on-entry, pre-held), and weakened Cyraxx loses by 3-count pinfall across all 4 modes.
5. **CPU Pin & Submission Escape Command Disconnection (Resolved in Pass A Baseline)**:
   - Unified all escape checks to consume the `Fighter` command interface (`input_pin`, `input_hold_pin`, `input_strike`, `input_grapple`, `input_block`) rather than polling global hardware keys during combat physics.
6. **Conflicting Throw Height Ownership (Resolved in Pass A Baseline)**:
   - Removed canvas grounding conflicts in central ring throws so overhead powerslams reach full 1.55m vertical peak before canvas impact.
7. **Forward-Axis Facing Vector Standardization (Resolved in Pass A Baseline)**:
   - Standardized all locomotion, stationary facing, and synchronized throw vectors to Godot's `-basis.z` forward convention (`atan2(-dx, -dz)`).
8. **Canonical Finisher Names Alignment (Resolved in Pass A Baseline)**:
   - Synchronized `README.md` to canonical names in `scripts/core/roster_data.gd`.
9. **Desktop Launcher Script Trailing Quote Bug (Resolved in M3 Polish)**:
   - Fixed `%~dp0` trailing backslash CRT escaping issue in `START_GAME.bat`.

