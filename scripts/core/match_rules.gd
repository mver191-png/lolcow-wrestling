class_name MatchRules
extends RefCounted

## Authoritative match configuration constants and geometric thresholds

const RING_MAT_RADIUS: float = 4.0 # Distance from center (0,0) to ropes in meters
const ROPE_BREAK_DISTANCE: float = 0.85 # Distance from rope threshold to trigger rope break
const PIN_COUNT_INTERVAL: float = 1.1 # Seconds per referee count
const PIN_ESCAPE_BASE_RATE: float = 30.0 # Percent escape per second base (hold-to-resist)
const PIN_ESCAPE_MASH_BASE: float = 16.0 # Base progress gained per active mash pulse
const PIN_ESCAPE_DECAY_RATE: float = 8.0 # Passive escape progress decay per second when unresisted
const PIN_ESCAPE_FINISHER_PENALTY: float = 0.55 # Multiplier on escape rate following a finisher impact
const MAX_HYPE: float = 100.0
const HYPE_GAIN_ON_HIT: float = 12.0
const HYPE_GAIN_ON_COUNTER: float = 20.0
const STAMINA_REGEN_RATE: float = 12.0 # Units per second when not attacking or sprinting
const STRIKE_STAMINA_COST: float = 14.0
const GRAPPLE_STAMINA_COST: float = 22.0
const BLOCK_STAMINA_DRAIN: float = 15.0 # Per second held
const REVERSAL_STAMINA_COST: float = 18.0
const FINISHER_HYPE_COST: float = 100.0

static func is_near_ropes(position_3d: Vector3) -> bool:
	var x: float = abs(position_3d.x)
	var z: float = abs(position_3d.z)
	var max_coord: float = max(x, z)
	return max_coord >= (RING_MAT_RADIUS - ROPE_BREAK_DISTANCE)
