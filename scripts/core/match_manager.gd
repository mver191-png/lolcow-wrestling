class_name MatchManager
extends Node

## Authoritative match state coordinator.
## Manages match progression, pin counting, rope break priority, and victory conditions.

signal match_started()
signal pin_started(pinner: Fighter, pinned: Fighter)
signal pin_count_ticked(count: int)
signal pin_broken(reason: String)
signal rope_break_called()
signal match_ended(winner: Fighter, method: String)

enum MatchState {
	INTRO,
	IN_PROGRESS,
	PIN_ATTEMPT,
	MATCH_OVER
}

@export var fighter_1: Fighter
@export var fighter_2: Fighter
@export var referee: Referee
@export var hud: Node

var current_state: MatchState = MatchState.IN_PROGRESS
var current_pinner: Fighter = null
var current_pinned: Fighter = null
var pin_timer: float = 0.0
var current_count: int = 0

func _ready() -> void:
	_setup_match()

func _setup_match() -> void:
	if not is_instance_valid(fighter_1) or not is_instance_valid(fighter_2):
		return
	
	fighter_1.opponent = fighter_2
	fighter_2.opponent = fighter_1
	
	if referee:
		referee.setup_targets(fighter_1, fighter_2)
		
	# Connect fighter signals
	if not fighter_1.pin_initiated.is_connected(_on_fighter_pin_initiated):
		fighter_1.pin_initiated.connect(_on_fighter_pin_initiated)
	if not fighter_2.pin_initiated.is_connected(_on_fighter_pin_initiated):
		fighter_2.pin_initiated.connect(_on_fighter_pin_initiated)
		
	if not fighter_1.kick_out_succeeded.is_connected(_on_kick_out_succeeded):
		fighter_1.kick_out_succeeded.connect(_on_kick_out_succeeded)
	if not fighter_2.kick_out_succeeded.is_connected(_on_kick_out_succeeded):
		fighter_2.kick_out_succeeded.connect(_on_kick_out_succeeded)

	match_started.emit()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("match_restart"):
		restart_match()
		return
		
	if current_state == MatchState.PIN_ATTEMPT:
		_process_pin_countdown(delta)

static func get_fighter_pos(f: Fighter) -> Vector3:
	if not is_instance_valid(f):
		return Vector3.ZERO
	if f.is_inside_tree() and f.get_parent() is Node3D:
		return f.global_position
	return f.position

func _on_fighter_pin_initiated(pinner: Fighter, pinned: Fighter) -> void:
	if current_state != MatchState.IN_PROGRESS:
		return
		
	current_pinner = pinner
	current_pinned = pinned
	
	# Priority 1: Check Rope Break immediately on pin start
	var pin_pos: Vector3 = get_fighter_pos(pinned)
	var pnr_pos: Vector3 = get_fighter_pos(pinner)
	if MatchRules.is_near_ropes(pin_pos) or MatchRules.is_near_ropes(pnr_pos):
		_call_rope_break()
		return
		
	current_state = MatchState.PIN_ATTEMPT
	pin_timer = 0.0
	current_count = 0
	
	if referee:
		referee.on_pin_started(get_fighter_pos(pinned))
	
	pin_started.emit(pinner, pinned)

func _process_pin_countdown(delta: float) -> void:
	if not is_instance_valid(current_pinned) or not is_instance_valid(current_pinner):
		_abort_pin("INVALID_PARTICIPANTS")
		return
		
	# Check if fighters moved near ropes during pin struggle
	if MatchRules.is_near_ropes(get_fighter_pos(current_pinned)) or MatchRules.is_near_ropes(get_fighter_pos(current_pinner)):
		_call_rope_break()
		return
		
	pin_timer += delta
	
	var next_threshold: float = (current_count + 1) * MatchRules.PIN_COUNT_INTERVAL
	if pin_timer >= next_threshold:
		current_count += 1
		pin_count_ticked.emit(current_count)
		if referee:
			referee.on_pin_count(current_count)
			
		if current_count >= 3:
			_end_match(current_pinner, "PINFALL (3-COUNT)")

func _call_rope_break() -> void:
	rope_break_called.emit()
	if referee:
		referee.on_rope_break()
		
	if is_instance_valid(current_pinner):
		current_pinner.break_pin_rope_break()
	if is_instance_valid(current_pinned):
		current_pinned.break_pin_rope_break()
		
	current_pinner = null
	current_pinned = null
	current_state = MatchState.IN_PROGRESS

func _on_kick_out_succeeded(fighter: Fighter) -> void:
	if current_state == MatchState.PIN_ATTEMPT and fighter == current_pinned:
		pin_broken.emit("KICKOUT")
		if referee:
			referee.on_pin_broken()
			
		current_pinner = null
		current_pinned = null
		current_state = MatchState.IN_PROGRESS

func _abort_pin(reason: String) -> void:
	pin_broken.emit(reason)
	if referee:
		referee.on_pin_broken()
	current_pinner = null
	current_pinned = null
	current_state = MatchState.IN_PROGRESS

func _end_match(winner: Fighter, method: String) -> void:
	current_state = MatchState.MATCH_OVER
	var loser: Fighter = fighter_2 if winner == fighter_1 else fighter_1
	
	winner.set_victory()
	loser.set_defeated()
	
	if referee:
		referee.on_match_won(winner.global_position)
		
	match_ended.emit(winner, method)

func restart_match() -> void:
	get_tree().reload_current_scene()
