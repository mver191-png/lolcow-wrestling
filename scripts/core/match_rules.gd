class_name MatchRules
extends RefCounted

## Authoritative match configuration constants and geometric thresholds

const RING_MAT_RADIUS: float = 4.0 # Distance from center (0,0) to ropes in meters
const ROPE_BREAK_DISTANCE: float = 0.85 # Distance from rope threshold to trigger rope break
const THROW_SAFE_RING_BOUND: float = 3.50 # Safe inner ring boundary for synchronized throw arcs
const PIN_COUNT_INTERVAL: float = 1.1 # Seconds per referee count
const PIN_ESCAPE_BASE_RATE: float = 85.0 # Percent escape per second base (hold-to-resist accessibility)
const PIN_ESCAPE_MASH_BASE: float = 10.0 # Base progress gained per active mash pulse (at 10 Hz = 100.0/s)
const PIN_ESCAPE_DECAY_RATE: float = 8.0 # Passive escape progress decay per second when unresisted
const PIN_ESCAPE_HOLD_STAMINA_DRAIN: float = 8.0 # Stamina units drained per second while holding to resist
const PIN_ESCAPE_MASH_STAMINA_COST: float = 0.8 # Stamina units drained per active mash pulse (at 10 Hz = 8.0/s)
const PIN_ESCAPE_FINISHER_PENALTY: float = 0.55 # Multiplier on escape rate following a genuine finisher impact
const PIN_ESCAPE_HEAVY_IMPACT_PENALTY: float = 0.85 # Multiplier on escape rate following an ordinary heavy throw/slam
const FINISHER_DISORIENTATION_DURATION: float = 4.5 # Seconds of finisher impact disorientation
const HEAVY_IMPACT_DISORIENTATION_DURATION: float = 1.5 # Seconds of ordinary heavy impact disorientation
const HEAVY_IMPACT_DAMAGE_THRESHOLD: float = 80.0 # Damage threshold for ordinary heavy impact
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
