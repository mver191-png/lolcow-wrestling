# Next Implementation Task: Pass A Priority 2 (Boundary-Safe Paired Throws)

## Immediate Next Task
**Priority 2: Boundary-Safe Paired Throws**:
1. Implement shared pre-throw spatial and trajectory validation in `Fighter._attempt_grapple()` and `_start_synchronized_throw()`.
2. When a throw is initiated near ropes ($|x| > 2.8\text{m}$ or $|z| > 2.8\text{m}$), automatically adjust the attacker-defender pair inwards, reorient facing inward toward the ring center, or trigger a rope collision/break rather than writing defender coordinates outside ring boundary ($|x| > 3.65\text{m}$) during slam arcs.
3. Validate complete throw cycles near all 4 ring edges and 4 corners in both scene tree processing orders (P1/P2 and P2/P1) without defender clipping or snap-back.

## Subsequent Backlog (In Strict Priority Order)
- **Priority 3**: Directional hit cones (`_handle_strike_active_window`) and distinct grapple startup vulnerability window (`GRAPPLE_STARTUP`).
- **Priority 4**: Centralized hold cleanup and deterministic outcome priority for simultaneous tap-out vs escape frames in `MatchManager`.
- **Priority 5**: Scene integration and visual verification across all 64 matchups.
