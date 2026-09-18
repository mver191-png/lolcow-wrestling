# Next task: precise strike contact and visible character refinement

Keep the tested primary-strike metadata, one-action damage/Hype budgets, shared
clocks, authored recovery and bounded clearance. Do not expand all named moves by
copying the same visual clip.

1. Fit Tophiachu's clothesline and Cyraxx's flurry to gameplay-owned swept contact
   volumes with body-specific hurtboxes. Define the volume from move data, not the
   mutable cosmetic skeleton. Verify edge-of-reach misses and compare visible arm
   contact at each hit. Preserve explicit hit IDs and counter/interruption behavior.
2. Refine the first two characters' shoulder/elbow/knee surfaces and finger poses.
   The rendered evidence exposes seams and awkward bends that numeric clearance
   alone cannot solve. Use approved reference direction for likeness; no new
   medical caricatures or unverified anatomy claims.
3. Review full-speed recovery from throws, pin escapes and submission escapes from
   multiple angles, then port accepted choreography to the remaining roster.
4. Improve referee first-count approach anticipation and run an uninterrupted
   human match. Keep Windows, controller and target-GPU verification separate.

Use `tests/test_authored_moves.gd` and `tools/capture_choreography.gd` with the
existing contact/clearance suites. Do not mark a new finisher or final art accepted
because a primary strike passes its hit-budget tests.
