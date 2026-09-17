# Current review-branch state

The roster/venue overhaul and paired-contact pass remain on `astra/character-animation-overhaul`; `main` is unchanged.

Animation-polish iteration 2 is IMPLEMENTED and VALIDATION PENDING. It adds articulated finger curls, subtle secondary breathing/body motion, conservative renderer-only material tuning, bounded hand/foot support during get-up, and differentiated fictional ring-movement signatures for the eight wrestlers. The signatures alter only skeletal presentation and are driven by the existing game archetypes/stats; they are not claims about the real people represented.

Validation history is intentionally explicit: the first polish test used the wrong Quaternion API and failed; after correcting that, the next run showed the recovery floor target was unreachable by all eight arm chains. The implementation now lowers the cosmetic model during the early recovery support phase instead of stretching limbs to fake contact. A fresh CI run must pass before this layer is called validated.

Last fully validated predecessor: 408 mechanics, 126 scene integration, 35 presentation, 305 overhaul and 1,941 contact assertions passed with zero failures; three Python asset-compiler tests passed. Counts overlap. See `docs/CONTACT_PASS.md` for contact tolerances. PR remains a draft; Windows packaging, target-hardware performance and a complete human playtest remain unverified.
