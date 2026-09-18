# Next: authored full-body contact and human-match quality

Continue from the integrated v3.1 review branch, not one of its older split parents.
Preserve the new helper joints, original gameplay chains, action schedules and
single recovery owner. Keep all draft PRs unmerged until acceptance.

1. Refine shoulder/armpit topology and grip acquisition with the existing same-camera
   bend fixtures. Check actual skin overlap, not just joint-marker proximity.
2. Add swept strike contact against explicit body regions, preserving per-action
   budgets and missed-window/reversal behavior. Never let a cosmetic IK adjustment
   silently become damage authority.
3. Evaluate ordinary complete matches, especially early pinfall balance, controller
   input and sustained gameplay. Add broader seeded CPU coverage but do not confuse
   it with human playtesting.
4. Verify Windows export, gamepads and identified target-hardware rendering.

Do not add tournament/online scope or increase clearance caps to conceal art issues.
Source builds require `python tools/build_roster.py` before import; complete packages
include the generated models. Document implemented, executed and visually reviewed
work separately.
