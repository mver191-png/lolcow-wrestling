# Current project state

Branch: `astra/character-animation-overhaul`, based on `2307d013`.

Implemented: all-roster original skinned assets; corrected regional weights and
hardware release; authoritative pose sampling; mirror isolation; complete throw
lifecycle checks; animated referee/halo; venue and crowd; real selection previews.

Locally verified: 408 unit assertions, 126 integration assertions, 35 presentation
assertions, 305 new overhaul assertions, and 3 Python asset tests. All passed.
These counts overlap and do not constitute art-quality acceptance.

Rendered/inspected: real engine selection, full-body match, Tophiachu detail,
and sampled throw sequence. Baseline was separately rendered for comparison.
Environment: Linux Godot 4.7.2, Mesa llvmpipe Compatibility driver; not a target-GPU
benchmark or native Windows export test.

Open: likeness/final art approval, exact hand/foot contact during paired moves,
unique move/trait mechanics, hardware profiling, full manual playtesting.

See REVIEW.md for implementation details, reproducible commands and limitations.
