# Project State: LOLCOW WRESTLING: OFFLINE MAYHEM

## Milestone Status: M0 (Complete) -> M1 (Complete) -> M2 & M3 (Complete & Verified)
- **Engine**: Godot 4.7.2 (stable official, Windows x64) - Installed & Verified.
- **3D DCC Pipeline**: Blender 5.0.1 (headless Python automation) - Verified.
- **Target**: 1080p @ 60 FPS, Windows standalone.
- **Authoritative Combat Loop**: Verified with 112 automated headless unit tests (0 failures, 0 warnings).

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
