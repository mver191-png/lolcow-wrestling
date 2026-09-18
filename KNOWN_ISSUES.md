# Open issues

This is a playable review branch, not a production-art sign-off.

- A geometry-derived final pass now protects the current skinned meshes against the canvas plane and square rope envelope in the tested poses. It is not collision against rope cylinders, pads, the opponent or the referee. Blend shapes, cloth simulation, unskinned accessories and shader displacement are outside its contract.
- Clearance offsets are cosmetic and capped: 0.30 m upward and 1.20 m per horizontal axis. Impossible fits are reported rather than scaled away. Safety can take precedence over smoothing at entry; visible bodies can differ from gameplay origins. Hovering and poorly authored weight-bearing poses still need refinement.
- IK now limits excessive flexion and preserves limb lengths. Complete anatomical shoulder/twist constraints, exact finger contact and clothing intersections remain open.
- Shared choreography still underlies most named moves. Character-specific finishers, traits and fully authored recovery transitions remain incomplete.
- Original stylized faces are not approved likeness scans. Detailed face topology, hair, clothing folds and visible shoulder seams remain art tasks. This pass did not rebuild the character geometry.
- Referee first-count choreography can remain incomplete after late arrival. Counts and outcomes remain independent of travel and animation.
- Compatibility/Mobile use imported PBR materials instead of the optional runtime overrides that produced invalid material diagnostics under OpenGL. Forward+ overrides have not been hardware-verified here.
- Windows exports, gamepads, target-GPU performance and a full human playtest remain unverified. Software rendering reports an unsupported VSync warning. A short create/free smoke fixture also reported two ObjectDB instances at shutdown, including with material polish disabled; its origin is not isolated. Do not use fixed-FPS captures as a performance benchmark.

See `docs/CLEARANCE_PASS.md`, `docs/CONTACT_PASS.md` and `REVIEW.md` for scope, measured results and reproduction commands.
