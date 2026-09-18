# Model quality v3

Base: validated recovery/contact revision `5c11c236`. This branch changes character art only after the existing animation/contact behavior is protected.

## Goal

Replace the current simple procedural silhouettes with higher-quality stylized wrestling characters while retaining the canonical roster, gameplay roots, 42-bone humanoid contract, named animation library, deterministic export, and all existing contact tests.

## Required art changes

- Denser head and torso topology with better shoulder, hip, knee and elbow deformation loops.
- Better hands: palm volume, knuckles, tapered fingers, separated thumb silhouette and enough geometry for the existing finger curl.
- Better faces: jaw/chin, cheek, brow, eyelid and lip forms. Keep likeness claims conservative; these remain stylized ring interpretations, not scans.
- Character-specific clothing geometry and silhouette details rather than relying only on color: singlet/tank/trunks/apron/tights/jacket/referee shirt profiles, seams, cuffs and pads.
- Character-specific hair silhouettes with enough geometry to read from gameplay camera distance.
- Preserve region-owned normalized skin weights. Torso vertices may not be captured by arm bones.

## Acceptance

1. Python compiler remains deterministic and all committed GLBs match the manifest.
2. Rig remains compatible with the presentation/contact system.
3. Existing mechanics, scene, presentation, overhaul, contact, animation-polish and recovery suites remain green.
4. Add model-geometry checks for per-character vertex/triangle floors, hand topology, face detail, finite normals/weights, unique silhouettes and material/region coverage.
5. Render fixed-camera full-body and portrait turntables for every wrestler under neutral light plus normal match lighting.
6. Inspect shoulder raise, elbow bend, fist curl, squat, knockdown, get-up, throw grip, cover and wrist-control poses. A successful import is not visual acceptance.
7. Do not increase bloom/fog to disguise geometry. Keep a neutral-light comparison.
8. Do not change stats, damage, reach, collision, clocks or terminal rules to fit art.

## Scope honesty

Procedural geometry can be substantially improved, but it is not equivalent to a manually sculpted, likeness-approved production character. If a topology problem cannot be solved cleanly in the deterministic generator, preserve the editable GLB/Blender handoff and mark that character for dedicated DCC refinement rather than claiming completion.
