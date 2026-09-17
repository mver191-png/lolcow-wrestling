# Current review-branch state

The roster/venue overhaul and paired-contact pass remain on `astra/character-animation-overhaul`; `main` is unchanged.

Animation-polish iteration 3 is IMPLEMENTED and VALIDATION PENDING. It adds articulated finger curls, subtle secondary breathing/body motion, conservative renderer-only material tuning, bounded hand/foot support during get-up, and differentiated fictional ring-movement signatures for the eight wrestlers. The signatures alter only skeletal presentation and are driven by existing game archetypes/stats; they are not claims about the real people represented.

Validation history is explicit. Earlier polish tests exposed and corrected a wrong Quaternion API and an unreachable early floor-support setup. The test now distinguishes a deliberately blended partial IK target from a full-weight support contact: chain reach is checked throughout, while target error is asserted only when the support weight is above 0.90. This prevents a false failure caused by measuring a half-blended foot against its eventual full target. A fresh CI run must pass before the layer is called validated.

Last fully validated predecessor: 408 mechanics, 126 scene integration, 35 presentation, 305 overhaul and 1,941 contact assertions passed with zero failures; three Python asset-compiler tests passed. Counts overlap. PR remains a draft; Windows packaging, target-hardware performance and a complete human playtest remain unverified.
