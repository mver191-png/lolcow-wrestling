# Current review-branch state

The roster/venue overhaul and paired-contact pass remain on `astra/character-animation-overhaul`; `main` is unchanged.

Animation-polish iteration 5 is IMPLEMENTED and VALIDATION PENDING. It adds articulated finger curls, subtle secondary breathing/body motion, conservative renderer-only material tuning, bounded recovery support, and differentiated fictional ring-movement signatures for all eight wrestlers.

The recovery validation rejected repeated attempts to force a hand-to-floor pose because the arm chain remained physically out of reach. The implementation now uses a thigh-braced left hand plus a planted right foot during the rising phase. This is an intentional quality correction: choose reachable support choreography rather than stretching limbs or moving the gameplay root to satisfy a visual target. A fresh CI run must pass before this layer is called validated.

Last fully validated predecessor: 408 mechanics, 126 scene integration, 35 presentation, 305 overhaul and 1,941 contact assertions passed with zero failures; three Python asset-compiler tests passed. Counts overlap. PR remains a draft; Windows packaging, target-hardware performance and a complete human playtest remain unverified.
