# GEMINI GRAPHICS & ANIMATION MASTER PROMPT
Visual-Production Specification for LOLCOW WRESTLING: OFFLINE MAYHEM

## PRIMARY GOAL
Make the improvement obvious in normal full-body gameplay with bloom, particles, and camera shake disabled. Replace primitive mannequins with recognizable, properly skinned, textured wrestlers; replace whole-model rotations and offsets with articulated motion.

Keep the visual style consistent: stylized-realistic arcade wrestling in a small, professionally presented indoor venue. No blocky toy anatomy, featureless heads, identical bodybuilder meshes, rubber limbs, or photographic faces pasted onto spheres.

## PRESERVE THE PROJECT
Keep all eight wrestlers, their canonical IDs, stats, move names, controls, selection flow, and working combat repairs. KingCobraJFS remains the neutral, untargetable referee with a permanent halo.

Inspect installed Godot/Blender versions and existing repository instructions. Protect user changes. Do not change engines, reset the repository, or rewrite the game from scratch.

Preserve authoritative damage, pin/submission outcomes, input processing, and movement ownership. Animation and VFX must not decide who wins. Do not introduce a second gameplay controller.

## FIRST PRODUCTION PRIORITY: CHARACTERS AND MOTION
Start with Tophiachu, then Cyraxx, then the referee. Finish that contrasting heavyweight/lightweight pair before spreading unfinished art across the full roster. Preserve the remaining six as explicitly provisional but playable characters during migration.

Create real character meshes with intentional anatomical surfaces, proper facial structure, articulated hands, clothing thickness and folds, hair, UVs, and material separation. Use approved references for likeness. Do not invent verified anatomy or medical caricatures.

Author a consistent humanoid rig with separate floor root and pelvis, spine, neck/head, clavicles, arms/hands, legs/feet/toes, and appropriate finger controls. Adapt proportions and weights per physique rather than merely scaling one mesh. Validate shoulders, elbows, hips, knees, and clothing in extreme poses.

Keep editable source assets and a reproducible per-character export. Export skinned assets and baked animation tracks, then verify them in Godot. A skeleton existing in a file is not proof of correct motion. Use appropriately licensed base assets when useful; do not rip models or animations from commercial games or purchase assets without approval.

## REPLACE THE OLD ANIMATION SHORTCUTS
Build a dedicated presentation component driven by gameplay state. For migrated characters, remove or explicitly disable the legacy visual_root rotation/height overrides, limb-node punch tweens, and whole-model get-up lerps. Do not let them compete with skeletal poses.

Use authored clips with AnimationPlayer and a tested AnimationTree or equivalent blend graph. Keep mutable playback state per fighter, including mirror matches. Preserve one world-movement owner. Begin with locomotion matched to actual velocity; never apply animation root motion and controller displacement twice.

Author a usable match library: idle, travel/turn/stop, guard, strike, hit reactions, reversal, grapple entry, paired throw, knockdown, supported get-up, pin/struggle/kick-out, submission/escape/tap-out, finisher, entrance, and victory/defeat presentation.

Give Tophiachu planted weight shifts, torso involvement, and committed follow-through. Give Cyraxx compact attacks, quicker direction changes, and distinct leverage-based wrestling. Neither should skate or snap between unrelated poses.

A get-up must show support through elbow/hand, knee/foot, and rising hips. Rotating a horizontal model upright is not a finished get-up. A pin must show an actual cover; a submission must show a connected hold.

## PAIRED ANIMATION IS THE MAIN QUALITY GATE
Author attacker and defender together in shared space. Drive both from one action ID and authoritative timeline. Define grip acquisition, loading, lift/leverage, impact, release, and recovery phases.

Maintain hands on intended grip targets with bounded correction; do not stretch arms or teleport bodies to force contact. Keep planted feet stable. Match the visible landing, sound, and cosmetic response to the authoritative impact. Do not duplicate damage or effects.

Test heavyweight-to-lightweight, lightweight-to-heavyweight, both mirror matches, and edge/corner setups. A lightweight takedown needs its own leverage poses, not an overhead slam with a lower height.

Keep current balance initially. If a readable clip requires different move timing, make one explicit metadata change and test it; do not silently retime the combat or arbitrarily speed up the animation.

## REFEREE
Replace model bounces and pin-position teleporting with articulated observing, repositioning, kneeling, hand-to-canvas counting, rope-break, submission-check, get-up, and winner-acknowledgment animations.

The official count remains authoritative. Prepare the gesture so the hand contacts the canvas at the official count; referee travel must never delay or bias the result.

Use one halo attached above the animated head, visible with bloom off. Keep its gold emission restrained and its count pulse subtle. Do not wash out the face or duplicate halos from old scene/model assets.

## ARENA AND CAMERA
Finish one ring and venue: canvas texture/seams, padded turnbuckles, connected ropes, apron folds, steps, platform, barriers, seating, entrance curtain/ramp, visible truss lights, speakers, and timekeeper area. Keep gameplay canvas coordinates consistent.

Add varied, modest-cost crowd characters with staggered reactions. Avoid identical synchronized loops and full-detail rigs for every seat.

Light faces and feet clearly. Use distinct skin, fabric, metal, hair, and canvas materials. Evaluate baked indirect light plus dynamic character lighting/shadows. Add restrained atmosphere only after the assets look good under neutral light. No fog wall or excessive bloom.

Improve the broadcast camera to frame complete interactions, including lifted and downed fighters. Do not hide feet, hands, or reversal windows. Reserve cinematic angles for safe moments. Retain reduced-shake and stable-camera options. Menu polish is secondary to the match itself.

## DELIVERY ORDER AND PROOF
First session: inspect briefly, capture a genuine baseline when tools permit, establish the presentation seam, then finish a skinned, textured Tophiachu with idle, locomotion/stop, characteristic strike, knockdown, and supported get-up IN THE REAL MATCH SCENE. Continue to Cyraxx only after that pipeline works. Advance from existing finished work rather than rebuilding it.

Next gate: a complete two-wrestler match with connected grapples, ground interactions, animated referee, finished arena, and result. Only then migrate the remaining roster and extend unique sequences.

Capture real before/after views, full-body locomotion, both throw directions, pin/kick-out, submission, referee counting, and an uninterrupted match. Inspect normal and slow playback. Generated art, Blender-only turntables, and headless test logs are not gameplay proof.

Keep IMPLEMENTED, AUTOMATED CHECK PASSED, and VISUALLY ACCEPTED separate. Mark checks NOT RUN when tools are unavailable. Never invent footage, asset licenses, test outcomes, or frame rates. Profile 1080p/60 FPS on identified hardware; do not assume the user's GPU or memory capacity.

Report changed assets/code, exact launch commands or a playable build, checks actually run, captures actually inspected, remaining provisional work, and one next implementation task. Update the existing project notes accurately. Do not mark the entire overhaul complete after changing lighting or adding an unused skeleton.

Begin implementation, not another roadmap. The first deliverable must visibly improve a real wrestler in the real game.
