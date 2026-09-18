# Open issues in the source-guided v3.3 build

- Half-angle helpers preserve the measured elbow/knee crease, not the entire limb's
  volume. Adjacent skin, shoulders, armpits, collars and clothes can still intersect.
- Full-mesh clearance is bounded cosmetic translation within a square envelope,
  not collision with ropes, turnbuckles, opponents or referee. No penetration in
  sampled fixtures does not prove zero hovering or continuous collision safety.
- Two distinct primary attacks and authored recoveries are implemented for
  Tophiachu/Cyraxx. Most other moves/finishers/traits still share mechanics.
- Strike contact remains a logical facing/range envelope, not a swept limb volume.
- First referee count after late arrival may not show the full gesture; official
  counts remain independent of travel. The final slap retention fix is preserved.
- All nine slots now have source-attributed portrait studies, not approved scans.
  Jupiter and AnacondaSin are based on newly located subject-labelled covers; more
  profile/full-body views are needed. Texture maps are original procedural art.
- Hair/face shading, shoulder/sleeve seams and facial expression still need polish.
  The dedicated portrait studio uses unshadowed fill; coarse self-shadow artifacts
  in other lighting are not claimed solved by that capture setup.
- Two seeded normal CPU matches demonstrate termination, not balanced match length
  or human usability. Windows export, gamepads, target-GPU Forward+ performance
  and comprehensive human playtesting remain unverified.
- Existing invalid-Unicode import diagnostics and virtual-driver VSync warnings
  remain. Source checkouts contain baseline GLBs and need `python tools/build_roster.py`;
  downloadable packages and CI artifacts contain the newly compiled assets.

See `docs/PORTRAIT_REFINEMENT_V33.md`, `docs/REFERENCE_LIKENESS.md` and `docs/INTEGRATED_DEFORMATION.md` for scope.
