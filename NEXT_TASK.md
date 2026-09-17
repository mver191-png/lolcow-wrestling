# Next Implementation Task: Pass A Priority 4 (Simultaneous Submission Outcome Ordering)

## Immediate Next Task
**Priority 4: Simultaneous Submission Outcome Ordering**:
1. Implement authoritative simultaneous outcome resolution policy in `MatchManager` when submission vitality depletion (tap-out condition) and escape progress (break condition) reach their thresholds on the exact same physics frame.
2. Ensure centralized hold cleanup:
   - Clear synchronized partner pointers symmetrically on both attacker and defender.
   - Prevent conflicting multi-frame state transitions or dangling references.
3. Validate across both player slot orders (P1 Attacker / P2 Defender vs P2 Attacker / P1 Defender) and scene tree iteration orders (Attacker before Defender vs Defender before Attacker).

## Subsequent Backlog (In Strict Priority Order)
- **Priority 5**: Scene integration and visual verification across all 64 matchups.
- **Priority 6**: Skeletal animation rigging and authored animation pipeline.
