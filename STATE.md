# Current review-branch state

The roster/venue overhaul and paired-contact pass remain on `astra/character-animation-overhaul`; `main` is unchanged. The contact pass has rotation-only grip correction, supported lateral covers, kneeling wrist control, bounded downed support, eased release and referee hand-to-mat correction.

A new animation-polish layer is IMPLEMENTED and VALIDATION PENDING in the current head. It adds articulated finger curls during strikes/holds, low-amplitude secondary breathing/body motion, stamina-responsive ring-body language, and bounded hand/foot IK support during get-up. Imported surface materials are duplicated per instance and receive conservative skin/hair/cloth/boot roughness tuning. These are fictional presentation choices driven by game state/stats, not claims about the real people represented.

Last fully validated predecessor: 408 mechanics, 126 scene integration, 35 presentation, 305 overhaul and 1,941 contact assertions passed with zero failures; three Python asset-compiler tests passed. Counts overlap. The CI workflow now includes `tests/test_animation_polish.gd`; do not promote the new layer to validated until that run succeeds.

See `docs/CONTACT_PASS.md` for contact tolerances and capture commands. PR remains a draft. Windows packaging, target-hardware performance and a complete human playtest remain unverified.
