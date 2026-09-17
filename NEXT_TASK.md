# Next Implementation Task: Pass A Priority 3 (Directional Contact & Grapple Startup)

## Immediate Next Task
**Priority 3: Directional Attack Contact & Grapple Startup**:
1. Implement forward directional cone validation in `Fighter._handle_strike_active_window()`.
   - Ensure an attacker's strike only hits if the defender lies within a forward angular cone ($\cos(\theta) \ge \text{threshold}$, e.g. dot product $\ge 0.50$ / $60^\circ$ half-angle).
   - Prevent attacks from connecting with defenders positioned behind or at extreme flanks outside the facing arc.
2. Implement a measurable `GRAPPLE_STARTUP` window in `Fighter._attempt_grapple()`.
   - Instead of instantly locking the throw on the first frame of grapple button press, enter a brief startup state (e.g. 0.15s–0.25s).
   - During startup, attacker can be interrupted by incoming strikes.
   - If defender inputs grapple/reversal during startup window, handle reversal/break.
3. Add comprehensive automated tests in `tests/test_suite.gd` verifying:
   - Strikes connect when defender is in front ($0^\circ$), fail when defender is behind ($180^\circ$) or outside the cone ($90^\circ$).
   - Grapple startup window allows strike interruption before the synchronized lock is established.

## Subsequent Backlog (In Strict Priority Order)
- **Priority 4**: Centralized hold cleanup and deterministic outcome priority for simultaneous tap-out vs escape frames in `MatchManager`.
- **Priority 5**: Scene integration and visual verification across all 64 matchups.
