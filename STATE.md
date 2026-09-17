# Project State: LOLCOW WRESTLING: OFFLINE MAYHEM

## Milestone Status: M0-M1 Functional -> Pass A Repairs (In Progress - Pinfall Balance Verified)
- **Engine**: Godot 4.7.2 (stable official, Windows x64) - Installed & Verified.
- **3D DCC Pipeline**: Blender 5.0.1 (headless Python automation) - Verified.
- **Target**: 1080p @ 60 FPS, Windows standalone.
- **Authoritative Combat Loop**: Verified with 150 automated headless unit tests (0 failures, 0 warnings).
- **M2/M3 Status**: Functional baseline established (Character Select, 16-bit procedural audio synthesis, 8-character 3D meshes, parameterized weight scaling). Skeletal animation rigging and authored unique animation clips remain pending/unverified per code review.

### Pass A Codebase Repairs & Verifications:
1. **Resource-Aware Pin Escape & CPU Pinfall Balance (Verified)**:
   - Repaired critical defect where CPU escaped all pins in 1.28s regardless of vitality.
   - Built a unified, resource-aware escape model scaling with quadratic vitality, remaining stamina, reversal rating, and recent finisher impact penalties.
   - Verified that fresh CPU/human defenders kick out cleanly (< Count 2) while exhausted/weakened defenders legitimately lose by 3-count pinfall.
   - Tested across both player slots (P1/P2), tree processing orders, active mashing, hold-to-resist, and rope breaks (150 tests passing).
2. **Unified Command Interface for Escapes (Verified)**:
   - `Fighter` escape logic consumes command inputs (`input_pin`, `input_strike`, `input_grapple`, `input_block`, `input_hold_pin`) rather than polling `Input.is_action_*` during physics process.
   - CPU controller pulses escape inputs at cadenced intervals based on `stat_reversal` and physical fatigue.
3. **Throw Height Ownership (Verified in Center Ring)**:
   - `_clamp_within_ring` skips vertical clamping during `GRAPPLING_DEFENDER`, granting attacker sole authority over lift height (1.55m peak verified in center).
   - Canvas grounding enforced at `y = 0.0` on transition to `KNOCKED_DOWN`.
4. **Standardized Forward-Axis Conventions (Verified)**:
   - Synchronized throws and locomotion unified on standard Godot convention `atan2(-dx, -dz)`.
   - Verified attacker `-basis.z` strictly faces defender and defender faces attacker (dot product = 1.000) across all slot inversions (P1/P2) and cardinal directions.
5. **Documentation Alignment (Verified)**:
   - `README.md` canonical move names and archetypes synced with `scripts/core/roster_data.gd`.

### Active Open Items from Code Review (In Priority Order):
1. **Boundary-Safe Throws**: Prevent attacker throws near ropes from placing defender out of ring bounds ($x > 3.65\text{m}$) before snap-back.
2. **Directional Contact & Grapple Startup**: Replace omnidirectional distance strike checks with forward cone checks; enforce a real startup window on grapples.
3. **Submission Simultaneous Outcome Resolution**: Formalize authoritative priority in `MatchManager` when tap-out and escape coincide on the same physics tick.

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
