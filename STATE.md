# Project State: LOLCOW WRESTLING: OFFLINE MAYHEM

## Milestone Status: M0 (Complete) -> M1 (Complete & Verified)
- **Engine**: Godot 4.7.2 (stable official, Windows x64) - Installed & Verified.
- **3D DCC Pipeline**: Blender 5.0.1 (headless Python automation) - Verified.
- **Target**: 1080p @ 60 FPS, Windows standalone.
- **Authoritative Combat Loop**: Verified with 56 automated headless unit tests (0 failures).

## Verification Summary
- **M0 Foundation**:
  - Full 8-character roster defined with verified 42-point attribute allocations.
  - Complete two-player arcade input mapping configured in `project.godot`.
  - 3D asset generation pipeline built in `blender/generate_assets.py`.
- **M1 Playable Match Loop**:
  - Playable arena with canvas, apron, turnbuckles, ropes, and bounds.
  - Tophiachu (P1, Player-controlled) vs Cyraxx (P2, CPU-controlled by default, toggleable with `[C]`).
  - Neutral official referee KingCobraJFS (1991-2025) with permanently visible, pulsing gold memorial halo.
  - Rigid state machine with authoritative movement ownership (zero sliding during knockdowns or throws).
  - Single-hit active damage windows.
  - Synchronized grapple and throw sequence with mutual locking, lift, impact canvas slap, and clean release.
  - Pinning, 3-count progression, hold/mash kick-out escape, and rope break priority.
  - Broadcast HUD displaying health, stamina, hype, count alerts, kick-out meter, and victory screen.
  - Full restart loop via `[R]` key.
