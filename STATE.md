# Current review-branch state

The roster/venue overhaul, paired-contact pass and animation-polish pass are on `astra/character-animation-overhaul`; `main` is unchanged.

Animation-polish iteration 5 is IMPLEMENTED + AUTOMATED VALIDATED. It adds articulated finger curls, subtle secondary breathing/body motion, conservative renderer-only material tuning, bounded thigh-braced/foot-supported recovery, and differentiated fictional ring-movement signatures for all eight wrestlers. The signatures alter only skeletal presentation and are not claims about the real people represented.

The validation process rejected fake hand-to-floor recovery because the real arm chains could not reach it without stretching. The accepted recovery uses a reachable thigh brace plus planted foot. GitHub Actions run 35280034856 passed asset rebuild/import and every configured suite, including the new animation-polish checks. Existing validated counts remain 408 mechanics, 126 scene integration, 35 presentation, 305 overhaul and 1,941 contact assertions; the animation-polish suite adds its own passing checks. Three Python asset-compiler tests pass. Counts overlap and are not human playtests.

PR remains a draft. This pass improves runtime material response and animation presentation; it does not claim a new high-detail character-geometry rebuild or approved likenesses. Windows packaging, target-hardware performance and a complete human playtest remain unverified.
