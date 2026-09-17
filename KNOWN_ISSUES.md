# Known Issues & Observable Defects: LOLCOW WRESTLING: OFFLINE MAYHEM

## Three Biggest Observable Issues (Identified in M1)
1. **Procedural vs Skeletal Animation (Target: M2)**:
   - *Observation*: Character movement and attacks currently use procedural programmatic tweening (arm thrusts, body tilt, canvas bounce, prone tilt) to strictly guarantee synchronized locking and state transitions.
   - *Fix Needed*: Author skeletal armatures and animation trees in Blender/Godot to provide natural joint bending while preserving authoritative frame events.
2. **Asymmetric Grapple Lift Offsets (Target: M2)**:
   - *Observation*: The lift height during throws is uniform across all character pairings. When compact Cyraxx throws heavyweight Tophiachu, an overhead lift looks visually unnatural.
   - *Fix Needed*: Scale lift heights and throw styles by character weight class ratio (e.g. leverage-based trips and hip tosses for light-on-heavy pairings).
3. **Sound Effects & Foley (Target: M2)**:
   - *Observation*: Match events (canvas slaps, referee bangs, bell, crowd buzz) fire logic signals, but dedicated WAV sound streams are not yet authored.
   - *Fix Needed*: Add a dedicated `AudioManager` with impact thuds, canvas slaps, ring bell, and crowd reaction layers.
