# Next Implementation Tasks: Visual & Animation Overhaul (Phase 2 & 3)

## Current Status: Phase 1 Complete (Tophiachu Production Asset & Presentation Architecture)
Tophiachu has been overhauled with a production-grade 22-bone humanoid armature, customized anatomical mesh, and 16 keyframed skeletal animation clips exported to `assets/models/tophiachu.glb`. `FighterPresentation` coordinates model loading, skeletal detection, locomotion stride synchronization, and backward-compatible fallbacks for unmigrated fighters. All 530 automated tests (404 unit/presentation tests + 126 scene physics tests) pass 100%.

---

## Next Immediate Milestones: Phase 2 & Phase 3

### Phase 2: Cyraxx Production Asset & Rapid Striker Animation Set
1. **Model & Skeleton Generation**:
   - Extend `blender/build_skinned_character.py` (or create `build_skinned_cyraxx.py`) to build Cyraxx with the identical 22-bone humanoid armature hierarchy.
   - Proportions: Frail, lightweight cruiserweight frame, sunken cheeks, defined nasal bridge, black beanie silhouette, olive tank top, dark joggers, and wrestling boots.
   - Distinct PBR material assignments for skin, clothing, beanie, and footwear.
2. **Author Unique Animation Set (16 clips)**:
   - Dynamic, twitchy cruiserweight idle loop.
   - Rapid-tempo walking cycle.
   - Rapid double-jab / flurry strike clip.
   - Unique synchronized throw attacker/defender clips.
   - Getting up, knockdown, submission struggle, victory/defeat.
3. **Integration & Automated Verification**:
   - Export to `assets/models/cyraxx.glb`.
   - Update `tests/test_visual_presentation.gd` and `tests/test_suite.gd` to verify Cyraxx has `has_skeletal_rig == true` and 16 valid clips.
   - Run Tophiachu vs Cyraxx full match in `test_pin_balance_scene.gd` with both fighters rigged.

### Phase 3: KingCobraJFS Neutral Referee Rig & Permanent Memorial Halo
1. **Armature & Visual Model**:
   - Humanoid armature for KingCobraJFS with custom referee polo/vest, iconic glasses, and bowler hat.
   - Permanent, glowing golden memorial halo (1991–2025) securely parented to the `Head` bone with pulsing emissive shader/material.
2. **Referee Animation Set**:
   - Upright officiating idle with observational head glances.
   - Fast, decisive floor drop for pin counts (dropping to chest, hitting the mat for counts 1, 2, 3).
   - Standing wave-off animation for kick-outs and rope breaks.
   - Authoritative pointing gesture to designate match winner.
3. **Integration & Verification**:
   - Export to `assets/models/referee_cobra.glb`.
   - Verify referee remains neutral, untargetable, with halo visible throughout all match phases.

### Phase 4: Remaining 6 Fighters in Roster Pipeline
- `novaonline`: Athletic heavyweight frame, fiery red/gold attire, powerful striking stance.
- `candy_rooks`: Broad kitchen-sink powerhouse brute, pink apron aesthetic, wrist wraps.
- `andy_ditch`: Sturdy territory anchor, padded denim blue wrestling singlet.
- `jupiter_the_hybrid`: Slender celestial martial artist, violet/silver attire.
- `anacondasin`: Flexible submission technician, serpentine emerald/gold tights.
- `daniel_larson`: Erratic, lanky scrapper, bright orange jacket silhouette.
