# Current portrait-refinement branch

Active: `astra/model-quality-v3`, draft PR #3. Main and predecessor review branches
remain unchanged. The source-guided v3.2 work is the starting point, not new work
claimed by this pass.

V3.3 refines all nine character portraits, fitted eyes, original skin/hair material
maps and rounded shirt shoulders. Additional subject-labelled public cover images
allow first studies for Jupiter and AnacondaSin; their profiles still need better
reference coverage and user approval. All art parameters are interpretations, not
biometric measurements. No photographs are included in compiled textures.

The original 46-joint contract, deformation helpers, contact landmarks, 25 clips,
combat scripts, stats and match rules are preserved. Runtime source is unchanged.
New imported-material/tangent checks join the existing regression and render
suites. Consult the exact CI artifact/logs for execution results; implementation
and automated passes do not certify photorealism or an approved likeness.

See `docs/PORTRAIT_REFINEMENT_V33.md` for sources, scope, commands and limits.
Packaged downloads contain rebuilt GLBs. Raw checkouts require the Python asset
build before Godot import. Keep PR #3 a draft; do not auto-merge.
