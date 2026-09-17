# Current review-branch state

The roster/venue overhaul and paired-contact pass remain on `astra/character-animation-overhaul`; `main` is unchanged.

Animation-polish iteration 4 is IMPLEMENTED and VALIDATION PENDING. It adds articulated finger curls, subtle secondary breathing/body motion, conservative renderer-only material tuning, bounded hand/foot support during get-up, and differentiated fictional ring-movement signatures for the eight wrestlers. The signatures alter only skeletal presentation and are driven by existing game archetypes/stats; they are not claims about the real people represented.

Validation history is explicit. Earlier runs exposed a wrong test API and then demonstrated that moving the imported model parent did not affect the Skeleton3D world-pose query used by the support solver. The recovery now lowers the articulated pelvis pose itself during the early support phase, so the solver evaluates the same transformed skeleton it renders and can keep real segment lengths. A fresh CI run must pass before this layer is called validated.

Last fully validated predecessor: 408 mechanics, 126 scene integration, 35 presentation, 305 overhaul and 1,941 contact assertions passed with zero failures; three Python asset-compiler tests passed. Counts overlap. PR remains a draft; Windows packaging, target-hardware performance and a complete human playtest remain unverified.
