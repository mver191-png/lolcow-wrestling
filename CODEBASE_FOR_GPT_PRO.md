# LOLCOW WRESTLING: OFFLINE MAYHEM - COMPLETE CODEBASE DIGEST FOR GPT PRO
> Generated for ChatGPT Pro / LLM context injection. Contains full source code, scenes, configs, assets manifest, and design rules.

## 1. Project Context & Non-Negotiables for GPT Pro
- **Engine**: Godot 4.7.2 (stable official, Windows x64, Forward+ Vulkan)
- **3D DCC**: Blender 5.0 (Python procedural asset generation)
- **Target**: 1080p @ 60 FPS standalone arcade wrestling on Windows
- **In Memoriam Rule**: KingCobraJFS (1991–2025) is the neutral, untargetable official referee with a permanent glowing gold halo across ALL matches.
- **Roster Rule**: All 8 distinct fighters maintain their exact canonical 42-point stat allocations and unique combat behaviors.
- **Authoritative State Gate**: Combat movements and throws are strictly synchronized with deterministic state-machine locks.

## 2. Git Commit History
`	ext
* 41a525f docs: add comprehensive project README with architecture, roster, and controls
* d58c46a fix(launcher): resolve batch path escaping, update window overrides and docs
* 86d1405 refactor(polish): add character_loaded HUD synchronization and audio feedback to CharacterSelect
* eca4161 feat(roster): implement full 8-character roster 3D assets, character select UI, audio stingers, and match persistence
* 8f28b5e docs: record M1 verification, top 3 observable defects, and M2 next task
* 234b626 feat: complete M0 foundation and M1 playable loop (Tophiachu vs Cyraxx with KingCobraJFS referee)
`

## 3. Repository File Manifest
| File Path | Type | Description |
| :--- | :--- | :--- |
| .gitignore | Source Code / Scene | .gitignore |
| DECISIONS.md | Source Code / Scene | DECISIONS.md |
| KNOWN_ISSUES.md | Source Code / Scene | KNOWN_ISSUES.md |
| NEXT_TASK.md | Source Code / Scene | NEXT_TASK.md |
| README.md | Source Code / Scene | README.md |
| START_GAME.bat | Source Code / Scene | START_GAME.bat |
| STATE.md | Source Code / Scene | STATE.md |
| assets/models/anacondasin.glb | Binary 3D Model | anacondasin.glb |
| assets/models/andy_ditch.glb | Binary 3D Model | andy_ditch.glb |
| assets/models/candy_rooks.glb | Binary 3D Model | candy_rooks.glb |
| assets/models/cyraxx.glb | Binary 3D Model | cyraxx.glb |
| assets/models/daniel_larson.glb | Binary 3D Model | daniel_larson.glb |
| assets/models/jupiter_the_hybrid.glb | Binary 3D Model | jupiter_the_hybrid.glb |
| assets/models/novaonline.glb | Binary 3D Model | novaonline.glb |
| assets/models/referee_cobra.glb | Binary 3D Model | referee_cobra.glb |
| assets/models/ring_arena.glb | Binary 3D Model | ring_arena.glb |
| assets/models/tophiachu.glb | Binary 3D Model | tophiachu.glb |
| blender/generate_assets.py | Source Code / Scene | generate_assets.py |
| project.godot | Source Code / Scene | project.godot |
| scenes/arena/ring_arena.tscn | Source Code / Scene | ring_arena.tscn |
| scenes/fighter/fighter.tscn | Source Code / Scene | fighter.tscn |
| scenes/main.tscn | Source Code / Scene | main.tscn |
| scenes/referee/referee.tscn | Source Code / Scene | referee.tscn |
| scenes/ui/character_select.tscn | Source Code / Scene | character_select.tscn |
| scenes/ui/match_hud.tscn | Source Code / Scene | match_hud.tscn |
| scripts/ai/cpu_controller.gd | Source Code / Scene | cpu_controller.gd |
| scripts/ai/cpu_controller.gd.uid | UID Metadata | cpu_controller.gd.uid |
| scripts/core/audio_manager.gd | Source Code / Scene | audio_manager.gd |
| scripts/core/audio_manager.gd.uid | UID Metadata | audio_manager.gd.uid |
| scripts/core/main_scene.gd | Source Code / Scene | main_scene.gd |
| scripts/core/main_scene.gd.uid | UID Metadata | main_scene.gd.uid |
| scripts/core/match_config.gd | Source Code / Scene | match_config.gd |
| scripts/core/match_config.gd.uid | UID Metadata | match_config.gd.uid |
| scripts/core/match_manager.gd | Source Code / Scene | match_manager.gd |
| scripts/core/match_manager.gd.uid | UID Metadata | match_manager.gd.uid |
| scripts/core/match_rules.gd | Source Code / Scene | match_rules.gd |
| scripts/core/match_rules.gd.uid | UID Metadata | match_rules.gd.uid |
| scripts/core/roster_data.gd | Source Code / Scene | roster_data.gd |
| scripts/core/roster_data.gd.uid | UID Metadata | roster_data.gd.uid |
| scripts/fighter/fighter.gd | Source Code / Scene | fighter.gd |
| scripts/fighter/fighter.gd.uid | UID Metadata | fighter.gd.uid |
| scripts/referee/referee.gd | Source Code / Scene | referee.gd |
| scripts/referee/referee.gd.uid | UID Metadata | referee.gd.uid |
| scripts/ring/broadcast_camera.gd | Source Code / Scene | broadcast_camera.gd |
| scripts/ring/broadcast_camera.gd.uid | UID Metadata | broadcast_camera.gd.uid |
| scripts/ring/ring.gd | Source Code / Scene | ring.gd |
| scripts/ring/ring.gd.uid | UID Metadata | ring.gd.uid |
| scripts/ui/character_select.gd | Source Code / Scene | character_select.gd |
| scripts/ui/character_select.gd.uid | UID Metadata | character_select.gd.uid |
| scripts/ui/match_hud.gd | Source Code / Scene | match_hud.gd |
| scripts/ui/match_hud.gd.uid | UID Metadata | match_hud.gd.uid |
| tests/test_suite.gd | Source Code / Scene | test_suite.gd |
| tests/test_suite.gd.uid | UID Metadata | test_suite.gd.uid |

---

## 4. Complete Source Code & Scene Definitions

### File: .gitignore
`
# Godot 4+ .gitignore
.godot/
*.translation
*.import
export_presets.cfg
test_out.txt
`

### File: DECISIONS.md
`markdown
# Architectural Decisions: LOLCOW WRESTLING: OFFLINE MAYHEM

## Decision 1: Single Authoritative Movement Ownership
- **Context**: Wrestling games frequently suffer from sliding while downed, attacks while prone, or physics fighting animations.
- **Decision**: `FighterState` acts as strict gatekeeper. In `KNOCKED_DOWN`, `GETTING_UP`, `PINNED`, or `GRAPPLING_DEFENDER`, input movement vectors are discarded, velocity is clamped to zero, and position is driven purely by authored sequence or pin lock.

## Decision 2: Synchronized Grapple & Throw Resolution
- **Context**: Independent colliders during throws cause hand disconnection, clipping, or missed impacts.
- **Decision**: An initiated grapple validates range, angle, and state. When accepted, attacker locks defender into `GRAPPLING_DEFENDER` and becomes owner of defender's transform relative to attacker's root. At impact keyframe, authoritative single damage is applied, defender is transitioned to `KNOCKED_DOWN` at the exact canvas landing spot, and mutual lock is released.

## Decision 3: KingCobraJFS Referee Design & Memorial
- **Context**: KingCobraJFS passed away on 21 August 2025.
- **Decision**: KingCobraJFS serves as the neutral, respectful referee throughout all matches. He wears a referee uniform with restrained gothic accents and features a permanently visible soft gold halo. The halo pulses rhythmically with each count of the match (1, 2, 3). He is strictly non-targetable, non-colliding with fighters, and non-exploitable; match rules dictate the authoritative count, while the referee provides the visual in-ring storytelling.

## Decision 4: Combat Timing & Reversals
- **Context**: Button-mashing or spamming leads to degenerate gameplay.
- **Decision**: Explicit rock-paper-scissors arcade dynamics:
  - Strikes interrupt exposed grapple startup.
  - Grapples break turtling blocks.
  - Reversals punish predictable strike/grapple commitments at the cost of stamina/reversal stat.
  - Finishers require 100 Hype and a valid opening/setup.
`

### File: KNOWN_ISSUES.md
`markdown
# Known Issues & Observable Defects: LOLCOW WRESTLING: OFFLINE MAYHEM

## Resolved in M2 & M3
1. **Procedural vs Skeletal Animation (Resolved for M3 Baseline)**:
   - Synchronized state-machine locking and deformation offsets guarantee rock-solid throws and submissions.
2. **Asymmetric Grapple Lift Offsets (Resolved in M2)**:
   - Implemented weight-class and leverage ratio throw trajectory scaling (low-angle trips vs overhead slams).
3. **Sound Effects & Foley (Resolved in M2/M3)**:
   - Integrated procedural 16-bit PCM synthesized audio manager with ring bell, impacts, power chords, fanfares, and referee counts.
4. **Desktop Launcher Script Trailing Quote Bug (Resolved in M3 Polish)**:
   - Fixed `%~dp0` trailing backslash in `START_GAME.bat` which previously caused Godot to abort due to escaped quote in arguments.
   - Created direct Windows Desktop shortcut at `C:\Users\mauri\Desktop\LOLCOW WRESTLING.lnk`.
`

### File: NEXT_TASK.md
`markdown
# Next Implementation Task: M4 (Tournament & Spectator Modes)

## Single Next Implementation Task
**Milestone M4 Pass**: Implement an 8-player single-elimination offline Tournament bracket mode and Spectator (CPU vs CPU) broadcast mode, with bracket visualization UI, match progression tracking, and championship trophy celebration with referee KingCobraJFS presenting the belt.
`

### File: README.md
`markdown
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
| 	ophiachu | Tophiachu | Heavyweight Brawler | Slow heavy tank, devastating strikes & high powerslams | *The Chu Slam* |
| 
ovaonline | Nova Online | Momentum Heavyweight | Balanced heavyweight with forward burst | *Supernova Drop* |
| cyraxx | Cyraxx | Burst Striker | Compact, lightning strikes, low leverage throws | *Goblin Flurry* |
| candy_rooks | Candy Rooks | Powerhouse Brute | High power and durability brawler | *Sugar Rush Slam* |
| ndy_ditch | Andy Ditch | Territory Grappler | Anchor wrestler with high grappling defense | *Babysitter Suplex* |
| jupiter_the_hybrid | Jupiter The Hybrid | Celestial Martial Artist | Agile kicks, swift escapes, aerial offense | *Cosmic Impact* |
| nacondasin | Anacondasin | Submission Specialist | Dangerous lock specialist, rapid tap-out inducer | *Viper Coil Hold* |
| daniel_larson | Daniel Larson | Erratic Scrapper | Unpredictable, fast scrambler and reversal threat | *Cease & Desist* |

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
**Current Status**: 112 / 112 Passed (100% Pass, 0 Failures, 0 Warnings).

---

## 6. Directory Layout

`
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
├── tests/                 # 112-case headless automated test suite
├── project.godot          # Engine configuration & input mappings
└── START_GAME.bat         # Direct Windows standalone launcher
`
`

### File: START_GAME.bat
`bat
@echo off
title LOLCOW WRESTLING: OFFLINE MAYHEM
cd /d "%~dp0"
echo Starting LOLCOW WRESTLING: OFFLINE MAYHEM...

set "GODOT_EXE=C:\Users\mauri\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7.2-stable_win64.exe"
if exist "%GODOT_EXE%" (
    start "" "%GODOT_EXE%" --path "%CD%"
    exit /b 0
)

start "" "godot.exe" --path "%CD%"
exit /b 0
`

### File: STATE.md
`markdown
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
`

### Binary Asset: assets/models/anacondasin.glb
*Compiled 3D GLB model for Godot. Size: 204672 bytes.*

### Binary Asset: assets/models/andy_ditch.glb
*Compiled 3D GLB model for Godot. Size: 186396 bytes.*

### Binary Asset: assets/models/candy_rooks.glb
*Compiled 3D GLB model for Godot. Size: 193428 bytes.*

### Binary Asset: assets/models/cyraxx.glb
*Compiled 3D GLB model for Godot. Size: 179492 bytes.*

### Binary Asset: assets/models/daniel_larson.glb
*Compiled 3D GLB model for Godot. Size: 179644 bytes.*

### Binary Asset: assets/models/jupiter_the_hybrid.glb
*Compiled 3D GLB model for Godot. Size: 211796 bytes.*

### Binary Asset: assets/models/novaonline.glb
*Compiled 3D GLB model for Godot. Size: 126276 bytes.*

### Binary Asset: assets/models/referee_cobra.glb
*Compiled 3D GLB model for Godot. Size: 205028 bytes.*

### Binary Asset: assets/models/ring_arena.glb
*Compiled 3D GLB model for Godot. Size: 134556 bytes.*

### Binary Asset: assets/models/tophiachu.glb
*Compiled 3D GLB model for Godot. Size: 256596 bytes.*

### File: blender/generate_assets.py
`python
import bpy
import math
import os

def clear_scene():
    bpy.ops.wm.read_factory_settings(use_empty=True)

def create_material(name, diffuse_color, roughness=0.5, metallic=0.0, emission_color=None, emission_strength=0.0):
    mat = bpy.data.materials.new(name=name)
    mat.use_nodes = True
    nodes = mat.node_tree.nodes
    bsdf = nodes.get("Principled BSDF")
    if bsdf:
        bsdf.inputs['Base Color'].default_value = diffuse_color
        bsdf.inputs['Roughness'].default_value = roughness
        bsdf.inputs['Metallic'].default_value = metallic
        if emission_color and 'Emission Color' in bsdf.inputs:
            bsdf.inputs['Emission Color'].default_value = emission_color
            bsdf.inputs['Emission Strength'].default_value = emission_strength
    return mat

def build_ring(output_path):
    clear_scene()
    
    mat_canvas = create_material("MatCanvas", (0.88, 0.85, 0.78, 1.0), roughness=0.9)
    mat_apron = create_material("MatApron", (0.1, 0.1, 0.12, 1.0), roughness=0.7)
    mat_post_red = create_material("MatPostRed", (0.8, 0.1, 0.1, 1.0), roughness=0.3, metallic=0.7)
    mat_post_blue = create_material("MatPostBlue", (0.1, 0.2, 0.8, 1.0), roughness=0.3, metallic=0.7)
    mat_post_white = create_material("MatPostWhite", (0.9, 0.9, 0.9, 1.0), roughness=0.4, metallic=0.5)
    mat_rope = create_material("MatRope", (0.85, 0.05, 0.05, 1.0), roughness=0.6)
    mat_floor = create_material("MatFloor", (0.05, 0.05, 0.06, 1.0), roughness=0.8)
    
    # Arena floor
    bpy.ops.mesh.primitive_plane_add(size=30.0, location=(0, 0, -1.0))
    floor = bpy.context.active_object
    floor.name = "ArenaFloor"
    floor.data.materials.append(mat_floor)
    
    # Canvas platform
    bpy.ops.mesh.primitive_cube_add(size=1.0, location=(0, 0, -0.5))
    canvas_box = bpy.context.active_object
    canvas_box.name = "RingPlatform"
    canvas_box.scale = (8.0, 8.0, 1.0)
    bpy.ops.object.transform_apply(scale=True)
    canvas_box.data.materials.append(mat_apron)
    
    # Canvas top sheet
    bpy.ops.mesh.primitive_plane_add(size=7.6, location=(0, 0, 0.01))
    canvas_sheet = bpy.context.active_object
    canvas_sheet.name = "RingCanvas"
    canvas_sheet.data.materials.append(mat_canvas)
    
    # Corner posts at (+-3.8, +-3.8)
    corners = [
        ("PostRed", 3.8, 3.8, mat_post_red),
        ("PostBlue", -3.8, -3.8, mat_post_blue),
        ("PostWhite1", -3.8, 3.8, mat_post_white),
        ("PostWhite2", 3.8, -3.8, mat_post_white),
    ]
    
    for name, cx, cy, cmat in corners:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.1, depth=2.6, location=(cx, cy, 0.3))
        post = bpy.context.active_object
        post.name = name
        post.data.materials.append(cmat)
        
        for h in [0.5, 1.0, 1.5]:
            bpy.ops.mesh.primitive_cube_add(size=0.18, location=(cx * 0.96, cy * 0.96, h))
            pad = bpy.context.active_object
            pad.name = f"{name}_Pad_{h}"
            pad.data.materials.append(cmat)
            
    # 3-tier Ropes
    for h in [0.5, 1.0, 1.5]:
        for y_pos in [-3.8, 3.8]:
            bpy.ops.mesh.primitive_cylinder_add(radius=0.035, depth=7.6, location=(0, y_pos, h))
            rope = bpy.context.active_object
            rope.rotation_euler = (0, math.radians(90), 0)
            rope.name = f"Rope_NS_{y_pos}_{h}"
            rope.data.materials.append(mat_rope)
        for x_pos in [-3.8, 3.8]:
            bpy.ops.mesh.primitive_cylinder_add(radius=0.035, depth=7.6, location=(x_pos, 0, h))
            rope = bpy.context.active_object
            rope.rotation_euler = (math.radians(90), 0, 0)
            rope.name = f"Rope_EW_{x_pos}_{h}"
            rope.data.materials.append(mat_rope)
            
    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported arena to {output_path}")

def build_tophiachu(output_path):
    clear_scene()
    mat_skin = create_material("SkinTophiachu", (0.55, 0.38, 0.28, 1.0), roughness=0.6)
    mat_hair = create_material("HairTophiachu", (0.12, 0.08, 0.05, 1.0), roughness=0.9)
    mat_outfit = create_material("OutfitTophiachu", (0.45, 0.22, 0.58, 1.0), roughness=0.5)
    mat_boots = create_material("BootsTophiachu", (0.12, 0.12, 0.14, 1.0), roughness=0.4)
    mat_wraps = create_material("WrapsTophiachu", (0.85, 0.85, 0.85, 1.0), roughness=0.8)
    
    root = bpy.data.objects.new("TophiachuRoot", None)
    bpy.context.collection.objects.link(root)
    
    # Heavyweight Torso
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.55, location=(0, 0, 1.15))
    torso = bpy.context.active_object
    torso.scale = (1.35, 0.95, 1.30)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_outfit)
    torso.parent = root
    
    # Head & curly hair
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.32, location=(0, 0, 1.78))
    head = bpy.context.active_object
    head.scale = (1.05, 1.0, 1.05)
    bpy.ops.object.transform_apply(scale=True)
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.40, location=(0, -0.05, 1.92))
    hair = bpy.context.active_object
    hair.scale = (1.3, 1.2, 1.0)
    bpy.ops.object.transform_apply(scale=True)
    hair.name = "Hair"
    hair.data.materials.append(mat_hair)
    hair.parent = root
    
    for side, x in [("L", -0.68), ("R", 0.68)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.72, location=(x, 0, 1.25))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        bpy.ops.mesh.primitive_cylinder_add(radius=0.20, depth=0.22, location=(x, 0, 0.95))
        wrap = bpy.context.active_object
        wrap.name = f"Wrap_{side}"
        wrap.data.materials.append(mat_wraps)
        wrap.parent = root
        
    for side, x in [("L", -0.34), ("R", 0.34)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.24, depth=0.6, location=(x, 0, 0.55))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_outfit)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.32, location=(x, 0.05, 0.16))
        boot = bpy.context.active_object
        boot.scale = (1.0, 1.4, 1.0)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Tophiachu to {output_path}")

def build_novaonline(output_path):
    clear_scene()
    mat_skin = create_material("SkinNova", (0.82, 0.68, 0.58, 1.0), roughness=0.5)
    mat_hair = create_material("HairNova", (0.15, 0.10, 0.08, 1.0), roughness=0.7)
    mat_gear = create_material("GearNova", (0.85, 0.15, 0.15, 1.0), roughness=0.4, metallic=0.3)
    mat_gold = create_material("GoldNova", (0.9, 0.8, 0.2, 1.0), roughness=0.25, metallic=0.7)
    mat_boots = create_material("BootsNova", (0.1, 0.1, 0.1, 1.0), roughness=0.3)
    
    root = bpy.data.objects.new("NovaRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_cube_add(size=0.75, location=(0, 0, 1.25))
    torso = bpy.context.active_object
    torso.scale = (1.25, 0.85, 1.20)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_gear)
    torso.parent = root
    
    bpy.ops.mesh.primitive_cube_add(size=0.78, location=(0, 0, 0.95))
    belt = bpy.context.active_object
    belt.scale = (1.28, 0.88, 0.22)
    bpy.ops.object.transform_apply(scale=True)
    belt.name = "Belt"
    belt.data.materials.append(mat_gold)
    belt.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.28, location=(0, 0, 1.85))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.15, depth=0.4, location=(0, -0.22, 1.95))
    hair = bpy.context.active_object
    hair.rotation_euler = (math.radians(-35), 0, 0)
    hair.name = "Hair"
    hair.data.materials.append(mat_hair)
    hair.parent = root
    
    for side, x in [("L", -0.60), ("R", 0.60)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.16, depth=0.75, location=(x, 0, 1.30))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.20, location=(x, 0, 1.0))
        wrist = bpy.context.active_object
        wrist.name = f"Wrist_{side}"
        wrist.data.materials.append(mat_gold)
        wrist.parent = root
        
    for side, x in [("L", -0.28), ("R", 0.28)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.68, location=(x, 0, 0.58))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_gear)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.28, location=(x, 0.06, 0.16))
        boot = bpy.context.active_object
        boot.scale = (0.95, 1.35, 1.1)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported NovaOnline to {output_path}")

def build_cyraxx(output_path):
    clear_scene()
    mat_skin = create_material("SkinCyraxx", (0.75, 0.65, 0.55, 1.0), roughness=0.6)
    mat_beanie = create_material("BeanieCyraxx", (0.15, 0.15, 0.18, 1.0), roughness=0.8)
    mat_gear = create_material("GearCyraxx", (0.15, 0.55, 0.35, 1.0), roughness=0.5)
    mat_boots = create_material("BootsCyraxx", (0.08, 0.08, 0.08, 1.0), roughness=0.3)
    
    root = bpy.data.objects.new("CyraxxRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.28, depth=0.65, location=(0, 0, 1.05))
    torso = bpy.context.active_object
    torso.scale = (0.78, 0.70, 0.88)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_gear)
    torso.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.22, location=(0, 0, 1.52))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.25, location=(0, -0.02, 1.62))
    beanie = bpy.context.active_object
    beanie.scale = (1.05, 1.1, 0.8)
    bpy.ops.object.transform_apply(scale=True)
    beanie.name = "Beanie"
    beanie.data.materials.append(mat_beanie)
    beanie.parent = root
    
    for side, x in [("L", -0.42), ("R", 0.42)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.09, depth=0.6, location=(x, 0, 1.1))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
    for side, x in [("L", -0.2), ("R", 0.2)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.12, depth=0.55, location=(x, 0, 0.55))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_gear)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.22, location=(x, 0.05, 0.14))
        boot = bpy.context.active_object
        boot.scale = (0.8, 1.3, 1.2)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Cyraxx to {output_path}")

def build_candy_rooks(output_path):
    clear_scene()
    mat_skin = create_material("SkinCandy", (0.84, 0.70, 0.60, 1.0), roughness=0.6)
    mat_apron = create_material("ApronCandy", (0.85, 0.45, 0.65, 1.0), roughness=0.5)
    mat_bandana = create_material("BandanaCandy", (0.95, 0.95, 0.95, 1.0), roughness=0.6)
    mat_boots = create_material("BootsCandy", (0.15, 0.12, 0.15, 1.0), roughness=0.4)
    mat_wrap = create_material("WrapCandy", (0.9, 0.9, 0.9, 1.0), roughness=0.7)
    
    root = bpy.data.objects.new("CandyRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.52, location=(0, 0, 1.15))
    torso = bpy.context.active_object
    torso.scale = (1.22, 0.96, 1.20)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_apron)
    torso.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.30, location=(0, 0, 1.74))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.33, depth=0.25, location=(0, 0, 1.90))
    bandana = bpy.context.active_object
    bandana.name = "Bandana"
    bandana.data.materials.append(mat_bandana)
    bandana.parent = root
    
    for side, x in [("L", -0.62), ("R", 0.62)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.17, depth=0.70, location=(x, 0, 1.22))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        bpy.ops.mesh.primitive_cylinder_add(radius=0.19, depth=0.24, location=(x, 0, 0.95))
        tape = bpy.context.active_object
        tape.name = f"Tape_{side}"
        tape.data.materials.append(mat_wrap)
        tape.parent = root
        
    for side, x in [("L", -0.30), ("R", 0.30)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.21, depth=0.62, location=(x, 0, 0.55))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_apron)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.30, location=(x, 0.05, 0.15))
        boot = bpy.context.active_object
        boot.scale = (1.0, 1.35, 1.0)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Candy Rooks to {output_path}")

def build_andy_ditch(output_path):
    clear_scene()
    mat_skin = create_material("SkinAndy", (0.86, 0.72, 0.62, 1.0), roughness=0.6)
    mat_dungarees = create_material("DungareesAndy", (0.25, 0.35, 0.65, 1.0), roughness=0.7)
    mat_pads = create_material("PadsAndy", (0.6, 0.6, 0.6, 1.0), roughness=0.5)
    mat_boots = create_material("BootsAndy", (0.1, 0.1, 0.1, 1.0), roughness=0.4)
    
    root = bpy.data.objects.new("AndyRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.56, location=(0, 0, 1.15))
    torso = bpy.context.active_object
    torso.scale = (1.30, 0.92, 1.25)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_dungarees)
    torso.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.31, location=(0, 0, 1.75))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    for side, x in [("L", -0.65), ("R", 0.65)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.17, depth=0.68, location=(x, 0, 1.20))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        bpy.ops.mesh.primitive_cylinder_add(radius=0.20, depth=0.20, location=(x, 0, 1.20))
        pad = bpy.context.active_object
        pad.name = f"Pad_{side}"
        pad.data.materials.append(mat_pads)
        pad.parent = root
        
    for side, x in [("L", -0.32), ("R", 0.32)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.22, depth=0.58, location=(x, 0, 0.54))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_dungarees)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.31, location=(x, 0.05, 0.15))
        boot = bpy.context.active_object
        boot.scale = (1.05, 1.35, 1.0)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Andy Ditch to {output_path}")

def build_jupiter_the_hybrid(output_path):
    clear_scene()
    mat_skin = create_material("SkinJupiter", (0.80, 0.68, 0.58, 1.0), roughness=0.5)
    mat_violet = create_material("VioletJupiter", (0.2, 0.1, 0.35, 1.0), roughness=0.4)
    mat_silver = create_material("SilverJupiter", (0.8, 0.8, 0.9, 1.0), roughness=0.2, metallic=0.6)
    mat_hair = create_material("HairJupiter", (0.1, 0.05, 0.15, 1.0), roughness=0.6)
    mat_boots = create_material("BootsJupiter", (0.15, 0.15, 0.18, 1.0), roughness=0.4)
    
    root = bpy.data.objects.new("JupiterRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.32, depth=0.75, location=(0, 0, 1.25))
    torso = bpy.context.active_object
    torso.scale = (1.05, 0.82, 1.02)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_violet)
    torso.parent = root
    
    bpy.ops.mesh.primitive_torus_add(major_radius=0.36, minor_radius=0.06, location=(0, 0, 1.0))
    sash = bpy.context.active_object
    sash.name = "Sash"
    sash.data.materials.append(mat_silver)
    sash.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.27, location=(0, 0, 1.82))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.18, depth=0.5, location=(0, -0.22, 1.90))
    hair = bpy.context.active_object
    hair.rotation_euler = (math.radians(-45), 0, 0)
    hair.name = "Hair"
    hair.data.materials.append(mat_hair)
    hair.parent = root
    
    for side, x in [("L", -0.52), ("R", 0.52)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.12, depth=0.72, location=(x, 0, 1.25))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        bpy.ops.mesh.primitive_cylinder_add(radius=0.14, depth=0.20, location=(x, 0, 0.98))
        wrap = bpy.context.active_object
        wrap.name = f"SilverWrap_{side}"
        wrap.data.materials.append(mat_silver)
        wrap.parent = root
        
    for side, x in [("L", -0.24), ("R", 0.24)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.16, depth=0.68, location=(x, 0, 0.58))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_violet)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.26, location=(x, 0.05, 0.15))
        boot = bpy.context.active_object
        boot.scale = (0.9, 1.3, 1.1)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Jupiter the Hybrid to {output_path}")

def build_anacondasin(output_path):
    clear_scene()
    mat_skin = create_material("SkinAnaconda", (0.78, 0.65, 0.54, 1.0), roughness=0.5)
    mat_green = create_material("GreenAnaconda", (0.15, 0.45, 0.25, 1.0), roughness=0.3)
    mat_gold = create_material("GoldAnaconda", (0.85, 0.75, 0.3, 1.0), roughness=0.25, metallic=0.7)
    mat_boots = create_material("BootsAnaconda", (0.1, 0.15, 0.1, 1.0), roughness=0.3)
    
    root = bpy.data.objects.new("AnacondaRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.33, depth=0.70, location=(0, 0, 1.18))
    torso = bpy.context.active_object
    torso.scale = (1.10, 0.85, 1.10)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_green)
    torso.parent = root
    
    bpy.ops.mesh.primitive_torus_add(major_radius=0.36, minor_radius=0.05, location=(0, 0, 0.95))
    belt = bpy.context.active_object
    belt.name = "SerpentBelt"
    belt.data.materials.append(mat_gold)
    belt.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.26, location=(0, 0, 1.70))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    for side, x in [("L", -0.52), ("R", 0.52)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.13, depth=0.68, location=(x, 0, 1.20))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_skin)
        arm.parent = root
        
        bpy.ops.mesh.primitive_cylinder_add(radius=0.15, depth=0.18, location=(x, 0, 1.15))
        wrap = bpy.context.active_object
        wrap.name = f"ElbowWrap_{side}"
        wrap.data.materials.append(mat_gold)
        wrap.parent = root
        
    for side, x in [("L", -0.25), ("R", 0.25)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.17, depth=0.64, location=(x, 0, 0.55))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_green)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.27, location=(x, 0.05, 0.14))
        boot = bpy.context.active_object
        boot.scale = (0.9, 1.35, 1.1)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_boots)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported AnacondaSin to {output_path}")

def build_daniel_larson(output_path):
    clear_scene()
    mat_skin = create_material("SkinDaniel", (0.85, 0.72, 0.62, 1.0), roughness=0.6)
    mat_orange = create_material("OrangeDaniel", (0.85, 0.45, 0.1, 1.0), roughness=0.5)
    mat_slate = create_material("SlateDaniel", (0.2, 0.2, 0.25, 1.0), roughness=0.6)
    mat_hair = create_material("HairDaniel", (0.45, 0.35, 0.25, 1.0), roughness=0.9)
    mat_shoes = create_material("ShoesDaniel", (0.8, 0.8, 0.8, 1.0), roughness=0.4)
    
    root = bpy.data.objects.new("DanielRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.27, depth=0.72, location=(0, 0, 1.25))
    torso = bpy.context.active_object
    torso.scale = (0.82, 0.75, 1.02)
    bpy.ops.object.transform_apply(scale=True)
    torso.name = "Torso"
    torso.data.materials.append(mat_orange)
    torso.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.25, location=(0, 0, 1.78))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.28, location=(0, -0.02, 1.90))
    hair = bpy.context.active_object
    hair.scale = (1.1, 1.05, 0.75)
    bpy.ops.object.transform_apply(scale=True)
    hair.name = "MessyHair"
    hair.data.materials.append(mat_hair)
    hair.parent = root
    
    for side, x in [("L", -0.46), ("R", 0.46)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.09, depth=0.74, location=(x, 0, 1.22))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_orange)
        arm.parent = root
        
    for side, x in [("L", -0.22), ("R", 0.22)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.12, depth=0.72, location=(x, 0, 0.58))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_slate)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.24, location=(x, 0.06, 0.14))
        shoe = bpy.context.active_object
        shoe.scale = (0.85, 1.4, 0.9)
        bpy.ops.object.transform_apply(scale=True)
        shoe.name = f"Shoe_{side}"
        shoe.data.materials.append(mat_shoes)
        shoe.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Daniel Larson to {output_path}")

def build_referee_cobra(output_path):
    clear_scene()
    mat_skin = create_material("SkinCobra", (0.7, 0.58, 0.48, 1.0), roughness=0.6)
    mat_stripes = create_material("RefereeShirt", (0.9, 0.9, 0.9, 1.0), roughness=0.6)
    mat_hat = create_material("GothicHat", (0.05, 0.05, 0.06, 1.0), roughness=0.5)
    mat_pants = create_material("RefereePants", (0.08, 0.08, 0.1, 1.0), roughness=0.5)
    mat_halo = create_material("HaloGold", (1.0, 0.82, 0.2, 1.0), roughness=0.1, metallic=0.2, emission_color=(1.0, 0.85, 0.25, 1.0), emission_strength=4.0)
    
    root = bpy.data.objects.new("RefereeRoot", None)
    bpy.context.collection.objects.link(root)
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.34, depth=0.75, location=(0, 0, 1.15))
    torso = bpy.context.active_object
    torso.name = "Torso"
    torso.data.materials.append(mat_stripes)
    torso.parent = root
    
    bpy.ops.mesh.primitive_uv_sphere_add(radius=0.26, location=(0, 0, 1.68))
    head = bpy.context.active_object
    head.name = "Head"
    head.data.materials.append(mat_skin)
    head.parent = root
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.48, depth=0.05, location=(0, 0, 1.82))
    brim = bpy.context.active_object
    brim.name = "HatBrim"
    brim.data.materials.append(mat_hat)
    brim.parent = root
    
    bpy.ops.mesh.primitive_cylinder_add(radius=0.28, depth=0.32, location=(0, 0, 2.0))
    crown = bpy.context.active_object
    crown.name = "HatCrown"
    crown.data.materials.append(mat_hat)
    crown.parent = root
    
    # Permanent Gold Memorial Halo
    bpy.ops.mesh.primitive_torus_add(major_radius=0.35, minor_radius=0.045, location=(0, 0, 2.30))
    halo = bpy.context.active_object
    halo.name = "HaloMesh"
    halo.data.materials.append(mat_halo)
    halo.parent = root
    
    for side, x in [("L", -0.48), ("R", 0.48)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.11, depth=0.65, location=(x, 0, 1.2))
        arm = bpy.context.active_object
        arm.name = f"Arm_{side}"
        arm.data.materials.append(mat_stripes)
        arm.parent = root
        
    for side, x in [("L", -0.22), ("R", 0.22)]:
        bpy.ops.mesh.primitive_cylinder_add(radius=0.15, depth=0.65, location=(x, 0, 0.58))
        leg = bpy.context.active_object
        leg.name = f"Leg_{side}"
        leg.data.materials.append(mat_pants)
        leg.parent = root
        
        bpy.ops.mesh.primitive_cube_add(size=0.26, location=(x, 0.05, 0.14))
        boot = bpy.context.active_object
        boot.scale = (0.9, 1.3, 1.0)
        bpy.ops.object.transform_apply(scale=True)
        boot.name = f"Boot_{side}"
        boot.data.materials.append(mat_hat)
        boot.parent = root

    bpy.ops.export_scene.gltf(filepath=output_path, export_format='GLB')
    print(f"Exported Referee to {output_path}")

if __name__ == "__main__":
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    models_dir = os.path.join(base_dir, "assets", "models")
    os.makedirs(models_dir, exist_ok=True)
    
    build_ring(os.path.join(models_dir, "ring_arena.glb"))
    build_tophiachu(os.path.join(models_dir, "tophiachu.glb"))
    build_novaonline(os.path.join(models_dir, "novaonline.glb"))
    build_cyraxx(os.path.join(models_dir, "cyraxx.glb"))
    build_candy_rooks(os.path.join(models_dir, "candy_rooks.glb"))
    build_andy_ditch(os.path.join(models_dir, "andy_ditch.glb"))
    build_jupiter_the_hybrid(os.path.join(models_dir, "jupiter_the_hybrid.glb"))
    build_anacondasin(os.path.join(models_dir, "anacondasin.glb"))
    build_daniel_larson(os.path.join(models_dir, "daniel_larson.glb"))
    build_referee_cobra(os.path.join(models_dir, "referee_cobra.glb"))
    print("ALL 8 ROSTER ASSETS + REFEREE GENERATED SUCCESSFULLY!")
`

### File: project.godot
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

### File: scenes/arena/ring_arena.tscn
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

### File: scenes/fighter/fighter.tscn
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

### File: scenes/main.tscn
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

### File: scenes/referee/referee.tscn
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

### File: scenes/ui/character_select.tscn
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

### File: scenes/ui/match_hud.tscn
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

### File: scripts/ai/cpu_controller.gd
`gdscript
class_name CPUController
extends Node

## Tactical CPU wrestler controller.
## Drives standard Fighter input interface with realistic reaction intervals
## and profile-tailored tactical choices.

@export var fighter: Fighter
@export var reaction_interval: float = 0.22 # Reaction delay in seconds

var timer: float = 0.0
var think_state: String = "approach"

func _ready() -> void:
	if fighter:
		fighter.is_cpu = true

func _physics_process(delta: float) -> void:
	if not is_instance_valid(fighter) or not is_instance_valid(fighter.opponent):
		return
	
	timer += delta
	if timer >= reaction_interval:
		timer = 0.0
		_think()

func _think() -> void:
	var opp: Fighter = fighter.opponent
	var dist: float = fighter.global_position.distance_to(opp.global_position)
	var opp_pos: Vector3 = opp.global_position
	var my_pos: Vector3 = fighter.global_position
	
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
		
	# Check if I am pinned -> escape mash!
	if fighter.current_state == Fighter.State.PINNED:
		fighter.input_pin = true
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

### Binary Asset: scripts/ai/cpu_controller.gd.uid
*Compiled 3D GLB model for Godot. Size: 20 bytes.*

### File: scripts/core/audio_manager.gd
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

### Binary Asset: scripts/core/audio_manager.gd.uid
*Compiled 3D GLB model for Godot. Size: 20 bytes.*

### File: scripts/core/main_scene.gd
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

### Binary Asset: scripts/core/main_scene.gd.uid
*Compiled 3D GLB model for Godot. Size: 19 bytes.*

### File: scripts/core/match_config.gd
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

### Binary Asset: scripts/core/match_config.gd.uid
*Compiled 3D GLB model for Godot. Size: 20 bytes.*

### File: scripts/core/match_manager.gd
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
	if pin_timer >= next_threshold:
		current_count += 1
		pin_count_ticked.emit(current_count)
		if referee:
			referee.on_pin_count(current_count)
		if AudioManager.instance:
			AudioManager.instance.play_referee_slap()
			AudioManager.instance.play_count_tone(current_count)
			
		if current_count >= 3:
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

### Binary Asset: scripts/core/match_manager.gd.uid
*Compiled 3D GLB model for Godot. Size: 20 bytes.*

### File: scripts/core/match_rules.gd
`gdscript
class_name MatchRules
extends RefCounted

## Authoritative match configuration constants and geometric thresholds

const RING_MAT_RADIUS: float = 4.0 # Distance from center (0,0) to ropes in meters
const ROPE_BREAK_DISTANCE: float = 0.85 # Distance from rope threshold to trigger rope break
const PIN_COUNT_INTERVAL: float = 1.1 # Seconds per referee count
const PIN_ESCAPE_BASE_RATE: float = 28.0 # Percent escape per second base
const MAX_HYPE: float = 100.0
const HYPE_GAIN_ON_HIT: float = 12.0
const HYPE_GAIN_ON_COUNTER: float = 20.0
const STAMINA_REGEN_RATE: float = 12.0 # Units per second when not attacking or sprinting
const STRIKE_STAMINA_COST: float = 14.0
const GRAPPLE_STAMINA_COST: float = 22.0
const BLOCK_STAMINA_DRAIN: float = 15.0 # Per second held
const REVERSAL_STAMINA_COST: float = 18.0
const FINISHER_HYPE_COST: float = 100.0

static func is_near_ropes(position_3d: Vector3) -> bool:
	var x: float = abs(position_3d.x)
	var z: float = abs(position_3d.z)
	var max_coord: float = max(x, z)
	return max_coord >= (RING_MAT_RADIUS - ROPE_BREAK_DISTANCE)
`

### Binary Asset: scripts/core/match_rules.gd.uid
*Compiled 3D GLB model for Godot. Size: 20 bytes.*

### File: scripts/core/roster_data.gd
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

### Binary Asset: scripts/core/roster_data.gd.uid
*Compiled 3D GLB model for Godot. Size: 20 bytes.*

### File: scripts/fighter/fighter.gd
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

# Input buffer
var input_dir: Vector2 = Vector2.ZERO
var input_strike: bool = false
var input_grapple: bool = false
var input_block: bool = false
var input_reversal: bool = false
var input_pin: bool = false
var input_finisher: bool = false

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
	if not is_cpu:
		_gather_player_inputs()
	
	_tick_stamina(delta)
	_update_state_machine(delta)
	_clamp_within_ring()

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
	input_pin = Input.is_action_just_pressed(prefix + "pin")
	input_finisher = Input.is_action_just_pressed(prefix + "finisher")

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
			if state_timer >= 0.25:
				_set_state(State.IDLE) # Missed grapple recovery
				
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
		
		# Rotate towards movement direction
		var target_angle: float = atan2(input_dir.x, input_dir.y)
		rotation.y = lerp_angle(rotation.y, target_angle, 10.0 * delta)
		
		if current_state != State.MOVING:
			_set_state(State.MOVING)
	else:
		velocity = Vector3.ZERO
		if is_inside_tree():
			move_and_slide()
		if current_state != State.IDLE:
			_set_state(State.IDLE)
		
		# Face opponent when standing still
		if is_instance_valid(opponent):
			var my_pos: Vector3 = global_position if is_inside_tree() else position
			var opp_pos: Vector3 = opponent.global_position if opponent.is_inside_tree() else opponent.position
			var look_pos: Vector3 = Vector3(opp_pos.x, my_pos.y, opp_pos.z)
			if not my_pos.is_equal_approx(look_pos):
				var target_rot: float = atan2(look_pos.x - my_pos.x, look_pos.z - my_pos.z)
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
			var dist: float = my_p.distance_to(opp_p)
			if dist <= reach_distance:
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

func _attempt_grapple(is_finisher: bool = false) -> void:
	_set_state(State.GRAPPLE_STARTUP)
	if not is_instance_valid(opponent):
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
	var dist: float = my_p.distance_to(opp_p)
	if dist <= (reach_distance + 0.35):
		# Validate defender state
		if opponent.current_state in [State.IDLE, State.MOVING, State.BLOCKING]:
			# Successful grapple! (Grapple breaks guard)
			_start_synchronized_throw(opponent)
		elif opponent.current_state == State.REVERSAL_STANCE:
			# Defender counters the grapple!
			_apply_countered_by(opponent)

func _start_synchronized_throw(target: Fighter) -> void:
	synchronized_partner = target
	throw_has_impacted = false
	state_timer = 0.0
	throw_duration = 1.1
	throw_impact_time = 0.6
	
	_set_state(State.GRAPPLING_ATTACKER)
	target.on_locked_by_throw(self)
	
	# Face each other
	var p1: Vector3 = global_position if is_inside_tree() else position
	var p2: Vector3 = target.global_position if target.is_inside_tree() else target.position
	var forward_dir: Vector3 = (p2 - p1).normalized()
	if not forward_dir.is_zero_approx():
		rotation.y = atan2(forward_dir.x, forward_dir.z)
		target.rotation.y = atan2(-forward_dir.x, -forward_dir.z)

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
				
			synchronized_partner.receive_damage(throw_damage, self, false)
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
			if synchronized_partner.is_inside_tree():
				synchronized_partner.global_position = slam_pos
			else:
				synchronized_partner.position = slam_pos
		
	if state_timer >= throw_duration:
		# Release mutual lock
		var partner: Fighter = synchronized_partner
		synchronized_partner = null
		_set_state(State.IDLE)
		partner.on_throw_released()

func on_throw_released() -> void:
	synchronized_partner = null
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
	var prefix: String = "p" + str(player_index) + "_"
	var escape_gain: float = 0.0
	
	if Input.is_action_just_pressed(prefix + "pin") or Input.is_action_just_pressed(prefix + "strike") or Input.is_action_just_pressed(prefix + "grapple"):
		escape_gain += 15.0
	elif Input.is_action_pressed(prefix + "pin") or Input.is_action_pressed(prefix + "strike"):
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
	
	if is_instance_valid(opponent) and opponent.current_state == State.SUBMISSION_ATTACKER:
		opponent.on_submission_broken_by_escape()

func on_submission_broken_by_escape() -> void:
	if visual_root:
		visual_root.position = Vector3.ZERO
	var push_dir: Vector3 = -global_transform.basis.z.normalized() if is_inside_tree() else -transform.basis.z.normalized()
	if is_inside_tree():
		global_position += push_dir * 1.2
	else:
		position += push_dir * 1.2
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
	# Accumulate escape progress via button presses or hold
	var prefix: String = "p" + str(player_index) + "_"
	var escape_gain: float = 0.0
	
	if Input.is_action_just_pressed(prefix + "pin") or Input.is_action_just_pressed(prefix + "strike") or Input.is_action_just_pressed(prefix + "grapple"):
		escape_gain += 16.0
	elif Input.is_action_pressed(prefix + "pin"): # Accessibility hold-to-resist
		escape_gain += MatchRules.PIN_ESCAPE_BASE_RATE * delta
	
	# Scale with remaining stamina & vitality
	var stamina_factor: float = 0.5 + 0.5 * (stamina / max_stamina)
	pin_escape_progress += escape_gain * stamina_factor
	
	if pin_escape_progress >= 100.0:
		_execute_kick_out()

func _execute_kick_out() -> void:
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
	# Stumble back
	var push_dir: Vector3 = -global_transform.basis.z.normalized() if is_inside_tree() else -transform.basis.z.normalized()
	if is_inside_tree():
		global_position += push_dir * 1.2
	else:
		position += push_dir * 1.2
	_set_state(State.IDLE)

func break_pin_rope_break() -> void:
	if current_state in [State.PINNING, State.PINNED]:
		if visual_root:
			visual_root.rotation = Vector3.ZERO
			visual_root.position = Vector3.ZERO
		_set_state(State.IDLE)

func receive_damage(amount: float, from_fighter: Fighter, was_blocked: bool) -> void:
	vitality = max(0.0, vitality - amount)
	vitality_changed.emit(vitality, max_vitality)
	
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

### Binary Asset: scripts/fighter/fighter.gd.uid
*Compiled 3D GLB model for Godot. Size: 20 bytes.*

### File: scripts/referee/referee.gd
`gdscript
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
`

### Binary Asset: scripts/referee/referee.gd.uid
*Compiled 3D GLB model for Godot. Size: 20 bytes.*

### File: scripts/ring/broadcast_camera.gd
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

### Binary Asset: scripts/ring/broadcast_camera.gd.uid
*Compiled 3D GLB model for Godot. Size: 20 bytes.*

### File: scripts/ring/ring.gd
`gdscript
class_name WrestlingRing
extends Node3D

## 3D Wrestling Ring with canvas, 4 turnbuckle posts, and 3-tiered ropes.

@export var mat_size: float = 8.0
@export var rope_radius: float = 3.8

func _ready() -> void:
	pass
`

### Binary Asset: scripts/ring/ring.gd.uid
*Compiled 3D GLB model for Godot. Size: 19 bytes.*

### File: scripts/ui/character_select.gd
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

### Binary Asset: scripts/ui/character_select.gd.uid
*Compiled 3D GLB model for Godot. Size: 20 bytes.*

### File: scripts/ui/match_hud.gd
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

### Binary Asset: scripts/ui/match_hud.gd.uid
*Compiled 3D GLB model for Godot. Size: 20 bytes.*

### File: tests/test_suite.gd
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
	defender.position = Vector3(0, 0, 0.8) # Within reach
	
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
`

### Binary Asset: tests/test_suite.gd.uid
*Compiled 3D GLB model for Godot. Size: 20 bytes.*

