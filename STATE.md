# Current review branch

The v3.3 source-guided models, 46-joint skinning, authored primary attacks and
shared match authority remain. This patch repairs problems reproduced during a
self-review; see `docs/SELF_REVIEW.md` for scope and evidence.

Implemented: real P2 keypad bindings plus top-row alternatives; focus-safe and
right-click selection; larger lit actor previews; nonduplicated stat updates;
single model initialization per match entry; immediately disabled camera shake;
non-overshooting camera interpolation; closed portrait seams; fitted beard roots.

Local regression suites pass, including 94 new interaction assertions and 12
Python cases. Actual old/new GLBs show all 873 head seam pairs coincide after the
fix. Fresh editor import no longer produces the invalid-Unicode key-code error.
A live-render-loop test verifies both menu previews. Consult the current commit's
CI result for independently repeated validation; counts are not realism scores.

Main and predecessor branches remain unchanged. Keep PR #3 draft. Likeness/art
approval, static expressions, broader balance, full-skin contacts, physical rope
collision, Windows export, gamepads and target-GPU behavior remain unfinished.
Downloaded packages have current GLBs; raw clones must rebuild before import.
