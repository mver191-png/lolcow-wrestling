# Open issues

This is a playable overhaul branch, not a production-quality sign-off.

- Shared animation clocks and corrected weights do not guarantee accurate grips.
  Hand/foot IK and pair-specific contact authoring remain the main visual task.
- Art is a consistent original stylized ring interpretation, not approved likeness
  scans. Material/facial/topology refinement remains; shoulder seams can be visible.
- Pin/submission/get-up contact is approximate; some poses intersect. Whole-body
  clearance around ropes is not covered by origin bounds.
- The referee does not delay the official count, but late arrival may make the
  visual gesture late. Refine arrival and count anticipation without changing rules.
- Canonical named moves/traits are preserved but many still share common mechanics.
- Native Windows exports, gamepads, Forward+ target-GPU performance, and a full
  manual match playtest have not been completed in this environment.
- Software rendering emits an unsupported VSync-setting warning. Fixed-FPS
  diagnostic captures must not be interpreted as performance measurements.

See REVIEW.md for verified changes and the distinction between automated tests,
rendered evidence and outstanding art acceptance.
