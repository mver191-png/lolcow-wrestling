# Project State: LOLCOW WRESTLING: OFFLINE MAYHEM

## Current Milestone: M0 -> M1 (First Session)
- **Engine**: Godot 4.7.2 (stable official, Windows x64)
- **3D DCC**: Blender 5.0.1 (verified headless Python automation)
- **Target**: 1080p, 60 FPS, Windows standalone
- **Cast Definition**: Complete 8-character roster defined with canonical 42-pt stats in `roster_data.gd`.
- **M1 Pair**: Tophiachu (Heavyweight Counter-Brawler) vs Cyraxx (Lightweight Burst Striker).
- **Referee**: KingCobraJFS (Neutral, untargetable, permanent visible pulsing halo).

## Implementation Status
- [x] Project workspace initialized & Git repository created.
- [x] Godot 4.7.2 installed and verified.
- [x] Blender 5.0.1 verified for automated asset export.
- [x] `project.godot` configured with full two-player arcade input map and physics tick rate (60 Hz).
- [ ] Roster data resource with exact specifications.
- [ ] Ring & Arena environment.
- [ ] KingCobraJFS referee controller with 3-count logic, rope break signaling, halo pulse.
- [ ] Fighter state machine with authoritative movement lock, single-hit damage, synchronized grapples.
- [ ] Tophiachu & Cyraxx distinct 3D visual models and rigs.
- [ ] Match Manager & Rules.
- [ ] Broadcast HUD (vitality, stamina, hype, referee count, kick-out escape, rope break, victory).
- [ ] Automated headless test suite.
