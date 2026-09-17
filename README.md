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
**Current Status**: 136 / 136 Passed (100% Pass, 0 Failures, 0 Warnings).

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
├── tests/                 # 136-case headless automated test suite
├── project.godot          # Engine configuration & input mappings
└── START_GAME.bat         # Direct Windows standalone launcher
```
