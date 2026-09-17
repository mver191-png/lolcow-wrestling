# Contact refinement acceptance

This pass continues from `06260e8de03896c86988c0bd63177ff0e860b121` on the review branch. Preserve the existing contact solver and all current gameplay changes; do not merge into main automatically.

## Acceptance gates

- Run the existing mechanics, scene-physics, presentation, overhaul and contact suites against the actual branch.
- Measure hand-to-target errors during acquisition, maintained grips, release and recovery, with both heavyweight/lightweight directions and mirror matches.
- Verify that contact correction rotates bones only; no bone-length scaling, gameplay root teleporting, damage or outcome changes.
- Exercise actor order inversions and neutral-input recovery to catch stale contact targets.
- Inspect real Godot frames for grips, covers, submissions, supported recovery and referee hand-to-canvas contact. Headless assertions do not establish visual quality.
- Keep full-body clipping and unverified platform/performance limits visible in the review notes.

## Baseline status

Current branch changes are being revalidated. This document is an acceptance checklist, not a claim of passing tests or completed visual polish. Results and remaining limitations will be recorded after execution.
