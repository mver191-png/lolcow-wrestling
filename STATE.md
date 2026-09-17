# Current review-branch state

The roster/venue overhaul and paired-contact pass remain on `astra/character-animation-overhaul`; `main` is unchanged. The contact pass has rotation-only grip correction, supported lateral covers, kneeling wrist control, bounded downed support, eased release and referee hand-to-mat correction.

The secondary animation-polish layer preserves articulated finger curls, fictional character-specific stance/tempo accents, stamina-responsive body language and per-instance material tuning. Its older recovery IK is now a fallback: when dedicated recovery support is enabled, it must not re-solve the limbs or curl the planted left palm after PairedContact.

## Recovery and count-contact follow-up

- Latched left-palm and phased ankle support during the existing 0.60-second recovery, with unchanged limb lengths and gameplay root.
- Strict solver validation and zero-weight no-op; clean contact disabling during holds.
- A cosmetic 0.08-second final-slap hold preserves hand-to-canvas contact after the result. Ordinary referee transitions blend for 0.16 seconds without delaying counts.
- New real-scene recovery/event acceptance and capture tooling. See `docs/CONTACT_ACCEPTANCE.md`.

Local validation before reconciliation with the incoming animation-polish commits: 408 mechanics, 126 scene physics, 35 presentation, 305 overhaul, 1941 paired-contact and 142 recovery/event assertions passed, plus three Python compiler tests. Counts overlap. The combined branch is awaiting fresh CI and local render verification; consult actual CI artifacts rather than treating these predecessor numbers as its result.

The initial incoming animation-polish test used `angle()` rather than `get_angle()`; that upstream correction is preserved. The updated polish test checks the active recovery owner rather than demanding both layers solve the same limb.

PR remains a draft. Full-body clearance, anatomical limits, unique move mechanics, Windows packaging, target-hardware performance and comprehensive human playtesting remain unverified. See `KNOWN_ISSUES.md`, `NEXT_TASK.md` and the contact documentation.
