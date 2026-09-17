# Current review-branch state

The roster/venue overhaul and paired-contact pass remain on `astra/character-animation-overhaul`; `main` is unchanged. The contact pass has rotation-only grip correction, supported lateral covers, kneeling wrist control, bounded downed support, eased release and referee hand-to-mat correction.

A new animation-polish layer is IMPLEMENTED and VALIDATION PENDING in the current head. It adds articulated finger curls during strikes/holds, low-amplitude secondary breathing/body motion, stamina-responsive fictional ring-body language, and bounded hand/foot IK support during get-up. Imported surface materials are duplicated per instance and receive conservative skin/hair/cloth/boot roughness tuning when a renderer is available; renderer-only overrides are skipped under headless validation.

The first animation-polish CI attempt correctly failed because the new test used the wrong Godot Quaternion API (`angle()` instead of `get_angle()`). That test error has been fixed and a fresh validation is running. Last fully validated predecessor: 408 mechanics, 126 scene integration, 35 presentation, 305 overhaul and 1,941 contact assertions passed with zero failures; three Python asset-compiler tests passed. Counts overlap.

See `docs/CONTACT_PASS.md` for contact tolerances and capture commands. PR remains a draft. Windows packaging, target-hardware performance and a complete human playtest remain unverified.
