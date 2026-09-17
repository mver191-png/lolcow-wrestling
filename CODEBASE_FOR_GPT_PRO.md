# Source navigation (overhaul branch)

The former concatenated digest is obsolete. Read the actual source files and
REVIEW.md rather than copying an old embedded snapshot into a new implementation.

- scripts/fighter/fighter.gd: simulation, input snapshots, action state
- scripts/fighter/fighter_presentation.gd: independent visual poses/shared clocks
- scripts/core/match_manager.gd: authoritative match outcome resolution
- tools/build_roster.py: deterministic meshes, regional weights, complete-pose clips
- scripts/ring/venue.gd: ring/stage/crowd presentation
- scripts/referee/referee.gd: non-authoritative referee presentation
- scripts/ui/character_preview.gd: real model previews
- tests/test_overhaul.gd: engine-scheduled all-pair/input/presentation regressions
- tests/test_roster_assets.py: compiler/asset integrity
- tools/capture_review.gd: reproducible actual-engine diagnostic captures

Remaining limits and current test results are in REVIEW.md and KNOWN_ISSUES.md.
