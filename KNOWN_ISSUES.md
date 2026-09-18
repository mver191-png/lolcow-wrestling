# Open issues

The review branch is playable but is not a production-art sign-off.

- Tophiachu and Cyraxx now have distinct primary-strike choreography and hit
  schedules, not unique finishers. Cyraxx's flurry deliberately splits the former
  single-hit damage/Hype budget. Practical matchup balance needs human playtests.
- Strike contact still uses the existing logical forward/range envelope. Accurate
  swept limb volumes and body-specific hurtboxes remain work; matching a hit window
  is not proof of visual hand contact at the edge of reach.
- The first two characters have authored, supported recovery. The other six keep
  the current baseline. The short arcade get-up and early pose transition still
  need more art refinement; reduced correction does not prove perfect foot planting.
- Full-mesh clearance protects the current linear-skinned geometry against canvas
  and a square rope envelope. It is not collision with rope cylinders, turnbuckles,
  the referee, opponents, shader displacement, cloth or future blend shapes.
- Bounded cosmetic offsets remain separate from gameplay roots. The safeguard can
  prevent penetration while still producing hovering or noticeable displacement.
- Grip markers and constant limb lengths do not prove collision-free fingers or
  clothing. Shoulder/elbow seams, extreme joints, detailed faces and hair remain
  visible art limitations. The stylized models are not approved likeness scans.
- Referee approach/first-count anticipation and distinct finisher/trait mechanics
  are still pending. No tournament/online mode was added.
- Windows export, gamepads, Forward+ target-GPU performance and a comprehensive
  human match playtest remain unverified. Software rendering has an unsupported
  VSync warning. Previous Unicode import diagnostics and a small create/free smoke
  fixture's shutdown instances have not been fully isolated.

See `docs/AUTHORED_MOTION_PASS.md`, `docs/CLEARANCE_PASS.md`,
`docs/CONTACT_PASS.md` and `REVIEW.md` for implemented scope and evidence.
