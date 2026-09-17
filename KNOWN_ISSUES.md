# Open issues

This is a playable review branch, not a production-art sign-off.

- Bounded hand/foot contact correction now exists. It targets anatomical markers,
  not full skin collision; small grip gaps, clothing penetration and extreme elbow
  or shoulder poses remain possible. There are no complete anatomical joint limits.
- Cover and wrist-control body offsets are cosmetic. Full-body clearance against
  ropes, opponents and referee is not covered by the existing actor-origin bounds.
- Shared choreography is still used for most named moves. Character-specific
  finishers/traits and finger articulation need work. Recovery now has tested
  palm/ankle supports, but its short arcade timing still needs art refinement.
- Original stylized faces are not approved likeness scans; facial/topology polish
  and visible shoulder seams remain art tasks.
- The final referee slap now stays visible through result resolution and transitions
  blend. A complete first gesture after late arrival is still not guaranteed.
  Official counts remain independent of travel and animation.
- Windows exports, gamepads, Forward+ target-GPU performance and a full human match
  playtest have not been verified. Software rendering reports an unsupported VSync
  setting; fixed-FPS captures must not be treated as performance measurements.

See `docs/CONTACT_PASS.md`, `docs/CONTACT_ACCEPTANCE.md` and `REVIEW.md` for scope.
