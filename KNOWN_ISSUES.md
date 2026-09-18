# Open issues in integrated v3.1

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
- Stylized faces/hair are not approved likenesses. More authored grip/finger,
  deformation and body-specific costume work is needed.
- Two seeded normal CPU matches demonstrate termination, not balanced match length
  or human usability. Windows export, gamepads, target-GPU Forward+ performance
  and comprehensive human playtesting remain unverified.
- Existing invalid-Unicode import diagnostics and virtual-driver VSync warnings
  remain. Source checkouts contain baseline GLBs and need `python tools/build_roster.py`;
  downloadable packages and CI artifacts contain compiled v3.1 assets.

See `docs/INTEGRATED_DEFORMATION.md` for executed tests and precise metric scope.
