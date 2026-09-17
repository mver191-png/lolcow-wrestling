# Current review-branch state

The roster/venue overhaul remains available on `astra/character-animation-overhaul`.
The paired-contact continuation adds rotation-only grip correction, supported
lateral covers, kneeling wrist control, bounded downed-body support, smooth contact
release, and referee hand-to-mat correction. Gameplay authority remains unchanged.

Local Godot 4.7.2 validation: 408 mechanics, 126 scene integration, 35 presentation,
305 prior overhaul and 1,941 contact assertions passed with zero failures.
Three Python asset-compiler tests passed. Counts overlap.

All 64 ordered pairings were exercised in both slot/insertion orders for the
contact pass. Baseline-disabled versus enabled gameplay traces matched exactly in
the tested 90-tick throw scenario. These results do not prove final art quality.

See `docs/CONTACT_PASS.md` for tolerances, capture commands and limitations.
See `REVIEW.md` for the original overhaul scope. PR remains a draft; main is not
merged. Windows packaging, target-hardware performance and a full human playtest
remain unverified.
