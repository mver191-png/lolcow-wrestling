class_name MatchConfig
extends RefCounted

## Global match configuration tracking selected fighters and CPU state.
## Persists match selections between Character Select and the Ring Arena.

static var p1_character_id: String = "tophiachu"
static var p2_character_id: String = "cyraxx"
static var p2_is_cpu: bool = true

static func set_match(p1_id: String, p2_id: String, cpu_p2: bool = true) -> void:
	p1_character_id = p1_id
	p2_character_id = p2_id
	p2_is_cpu = cpu_p2

static func reset_defaults() -> void:
	p1_character_id = "tophiachu"
	p2_character_id = "cyraxx"
	p2_is_cpu = true
