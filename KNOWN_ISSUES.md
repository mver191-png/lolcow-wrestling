## Active Open Issues & Defects Under Repair

1. **Boundary Safety During Throws (High Priority - Open)**:
   - `_clamp_within_ring()` skips clamping during `GRAPPLING_DEFENDER` to allow vertical lifting without clipping to the floor. However, an attacker facing outward near the ropes (e.g. $x = 3.0\text{m}$, defender at $x = 3.6\text{m}$) can slam the defender outside the physical ring bounds ($x = 4.1\text{m}$ vs $3.65\text{m}$ ring limit).
   - *Required Fix*: Implement pre-throw spatial boundary validation that repositions the pair inwards, reorients the throw, or breaks/deflects off ropes rather than placing the defender outside before snap-back.

2. **Directional Attack Contact & Grapple Startup (High Priority - Open)**:
   - `_handle_strike_active_window()` evaluates distance between fighter origins without verifying a forward directional cone, allowing strikes to hit opponents behind the attacker.
   - `_attempt_grapple()` immediately initiates the throw rather than pausing in `GRAPPLE_STARTUP` for a measurable vulnerability/counter window.
   - *Required Fix*: Add forward directional dot-product gating to strike resolution and enforce a distinct startup window on grapples allowing interruptions and reversals.

3. **Simultaneous Submission Outcome Ordering (Medium Priority - Open)**:
   - While partner references are now cleared on both sides during escapes, a frame in which vitality depletes to 0 simultaneously with escape progress reaching 100 depends on node processing order (attacker update vs defender update).
   - *Required Fix*: Establish an explicit authoritative priority policy in `MatchManager` for simultaneous tap-out vs escape frames.

4. **Skeletal Animation Pipeline & Unique Moveset Data (Open)**:
   - 3D character models are composed of procedural primitive geometries without bones or skeletal clips. Throws and strikes utilize parameterized programmatic tweening rather than distinct motion-captured or keyframed animation clips.

---

## Resolved in Pass A & Prior Milestones

1. **Pin-Balance Acceptance & Empirical Sequence Validation (Resolved in Pass A Pinfall Balance)**:
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

