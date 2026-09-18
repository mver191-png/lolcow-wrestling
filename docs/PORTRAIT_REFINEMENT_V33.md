# Reference-directed portrait refinement v3.3

This pass continues the existing v3.2 source studies (`49871c7`), not the older
unreferenced v3 meshes. It changes generated character art and its verification,
not combat, animation schedules, colliders, game statistics or match outcomes.
No reference photograph is embedded, sampled into a texture or shipped in the game.

## New work

- Less horizontally exaggerated cranial/jaw contours; individual nose, mouth,
  brow and neck controls refined against the selected source appearances.
- One fitted eye surface contains original iris/sclera detail. The iris is clipped
  by its actual aperture rather than layering a small opaque oval onto a white
  slit. Lid tissue ramps into orbital skin; brow cushions and shallow facial folds
  are continuous geometry.
- Original 512x512 face albedo, micro-normal and roughness maps. Normal-map surfaces
  have explicitly exported orthonormal tangents. Roughness is spatially varied;
  no claim of measured skin properties is made.
- Flattened/tapered hair clumps and original fiber maps replace many cylindrical
  strands. Source-selected tied curls/bun/yellow band, parted shoulder-length hair,
  cropped coils, cropped waves, receding fringe and headwear differentiate the cast.
- The backward cap and referee bandana use rough cloth instead of shiny boot material.
- A rounded shoulder/sleeve envelope replaces the previous intersecting horizontal
  shoulder bridge plus capped sleeve. Hidden upper-arm skin under the sleeve is
  omitted to avoid exposed skin protruding through the garment. The original
  elbow crease, skin helper rules and all skeleton/contact landmarks remain.
- Dedicated source-labelled cover art was found for Jupiter and AnacondaSin.
  They now have first portrait studies instead of generic fallback heads. Their
  profile/side-view coverage is still limited, and likeness is not approved.

## Source register and selected appearance

Sources establish the publisher's attribution, not biometric identity verification
or the truth of any accompanying commentary. Only visual content was used. The
reference pages may contain editorial allegations; none are incorporated into the
models, character dialogue or game mechanics. All numeric shape controls are art
parameters, not measurements of real people.

| Slot | Visual direction used this pass | Public source page |
|---|---|---|
| Tophiachu | Fuller lower face, hooded eyes, tied curls/bun and yellow cloth band | https://knowyourmeme.com/memes/people/tophiachu-tiktok-lolcow |
| NovaOnline | Full cheek/neck silhouette, rectangular glasses, parted shoulder hair, purple shirt | https://knowyourmeme.com/memes/people/nova-online-tiktok-lolcow |
| Cyraxx | Narrower jaw/longer facial planes, receding fringe and tapered chin beard | https://tenor.com/view/cyraxx-chance-wilkins-psyraxx-43-gif-7870491556437349690 |
| Candy Rooks | Fuller lips and nasal planes, compact coils, dark shirt | https://open.spotify.com/episode/1cdZ9Rc2SO3ukrnMlHwerB |
| Andy Ditch | Bald scalp, rounded jaw/neck, rectangular frames and orange shirt | https://tenor.com/view/andrew-ditch-ditch-poopsquatch-andy-ditch-andy-gif-16852068161994619749 |
| Jupiter the Hybrid | Broad brow, short dark waves, light facial-hair study; right closed-mouth cover portrait | https://open.spotify.com/episode/2EpxP1PWU3fHsPguvZ9cOZ |
| AnacondaSin | Rectangular frames, brown shoulder hair and backward cap; central cover portrait | https://open.spotify.com/episode/3k0IOy5dBTIbC7HTutG0en |
| Daniel Larson | Narrower jaw, longer nasal profile and short brown crop | https://knowyourmeme.com/photos/2345829-daniel-larson |
| KingCobraJFS referee | Glasses, longer side hair, tapered facial hair and black bandana; existing single halo retained | https://cowboystatedaily.com/2025/09/13/how-a-bullied-casper-kid-went-viral-as-the-internets-gothic-kingcobra/ |

The game remains fully clothed and non-graphic. Costumes are fictional ring outfits,
not claims about what someone always wears. New cover images are one perspective,
not calibrated front/side/back photographs or full-body measurements.

## Verification contracts

The Python suite checks deterministic exports, normalized region-owned skinning,
unchanged joint/contact landmarks, all 25 complete-channel clips, actual tangent
orthogonality, nine source records, and original embedded material channels.
The Godot likeness suite checks the **imported** 512px texture, normal/roughness
maps, fitted-eye material, tangents, animation library and exactly one referee halo.
The other gameplay/deformation/contact/clearance/whole-match suites remain enabled.

Actual engine renders include 36 neutral portrait views, 51 model states, bend
studies and the staged match. A neutral fill gallery is not a substitute for the
separate shadowed match/light tests. CI checks rendered output exists and rejects
engine errors; no automated test is presented as an identity or realism score.

Use the commit-linked CI artifact and `evidence/*.log` for exact executed results.
The `evidence/.gdignore` marker prevents the editor from repeatedly importing its
own test PNGs. It does not omit the game assets or tests from execution.

## Reproduce

Downloaded game packages already include the rebuilt GLBs. A raw source checkout
still needs its deterministic asset build before Godot import:

```sh
python tools/build_roster.py
python tests/test_roster_assets.py
godot --headless --editor --path . --import
godot --headless --fixed-fps 60 --path . -s tests/test_likeness_assets.gd
godot --path . --audio-driver Dummy --rendering-method gl_compatibility --disable-render-loop --fixed-fps 60 -s tools/capture_likeness.gd
```

The single-player game uses `project.godot`; press F5 in Godot 4.7.2. Blender is not
needed to play the packaged version. Art remains editable via the generators and
self-contained glTF files. No paid model service, voice cloning or image-generation
API is part of runtime.

## Explicit limits

These are more individualized stylized game portraits, **not photorealistic scans**.
Static facial expressions, hairline/clump shapes, shoulders, fabric intersections
and extreme contact need continued visual review. Existing short recovery timing,
logical strike envelopes and shared finishers are unchanged. Full-body clearance
is still a conservative square-envelope correction, not physical rope/opponent
collision. Hardware Forward+, Windows export, gamepads and human-facing likeness
approval are not established by software-rendered captures or headless checks.
