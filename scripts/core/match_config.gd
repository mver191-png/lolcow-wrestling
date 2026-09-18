class_name MatchConfig
extends RefCounted

## Global match configuration tracking selected fighters and CPU state.
## Persists match selections between Character Select and the Ring Arena.

static var p1_character_id: String = "tophiachu"
static var p2_character_id: String = "cyraxx"
static var p2_is_cpu: bool = true
# Fixed until the next match selection. Restart reproduces the same CPU streams.
static var match_seed: int = 91707

static func set_match(p1_id: String, p2_id: String, cpu_p2: bool = true, deterministic_seed: int = -1) -> void:
	p1_character_id = p1_id
	p2_character_id = p2_id
	p2_is_cpu = cpu_p2
	if deterministic_seed >= 0:
		match_seed = deterministic_seed
	else:
		# Independent entropy; sound/preview random draws cannot pick the match seed.
		var entropy := RandomNumberGenerator.new()
		entropy.randomize()
		match_seed = entropy.randi()

static func reset_defaults() -> void:
	p1_character_id = "tophiachu"
	p2_character_id = "cyraxx"
	p2_is_cpu = true
	match_seed = 91707
