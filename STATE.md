# Current self-review follow-up

Baseline: e3df96e3, retaining its repaired portrait seams, P2 bindings, selection,
model initialization and shake behavior. This pass adds CPU stamina recovery,
private AI/audio randomness, complete CPU command snapshots, invalid-hold cleanup
and closer final-bounds-aware match framing. Actor meshes, rig, moves, health,
stamina/escape rules and resource budgets are unchanged.

The matched 128-case study observed 39 baseline timeouts versus zero afterward.
Completed-match median was 12.17 versus 17.05 seconds, excluding timeouts. This is
limited observation, not balance acceptance. 22 new sample losses still occurred
above 70% vitality. See docs/PACING_SELF_REVIEW.md for exact scope and reproduction.

Local configured suites pass, including 35 new controller/cleanup regressions and
14 action-camera checks. The unchanged baseline failed 14 of those 35 controller
assertions. CI repeats the current build tests, 128-case audit, random-noise parity
and real rendered captures. Consult the commit's job result for CI status.

The unforced normal-controller capture is separate from older staged kick-out
videos. Software OpenGL does not establish target hardware performance. No main
merge, production-art or comprehensive human-playtest approval is claimed.
