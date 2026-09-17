class_name MatchHUD
extends Control

## Broadcast television style HUD for LOLCOW WRESTLING: OFFLINE MAYHEM.

@export var match_manager: MatchManager
@export var p1_name_label: Label
@export var p1_title_label: Label
@export var p1_vitality_bar: ProgressBar
@export var p1_stamina_bar: ProgressBar
@export var p1_hype_bar: ProgressBar
@export var p1_state_label: Label

@export var p2_name_label: Label
@export var p2_title_label: Label
@export var p2_vitality_bar: ProgressBar
@export var p2_stamina_bar: ProgressBar
@export var p2_hype_bar: ProgressBar
@export var p2_state_label: Label

@export var center_announcement: Label
@export var pin_escape_container: Control
@export var pin_escape_bar: ProgressBar
@export var victory_panel: Control
@export var victory_label: Label

var current_pinned_fighter: Fighter = null

func _ready() -> void:
	if victory_panel:
		victory_panel.visible = false
	if pin_escape_container:
		pin_escape_container.visible = false
	if center_announcement:
		center_announcement.visible = false
		
	if match_manager:
		match_manager.pin_started.connect(_on_pin_started)
		match_manager.pin_count_ticked.connect(_on_pin_count)
		match_manager.pin_broken.connect(_on_pin_broken)
		match_manager.submission_started.connect(_on_submission_started)
		match_manager.submission_escaped.connect(_on_submission_escaped)
		match_manager.rope_break_called.connect(_on_rope_break)
		match_manager.match_ended.connect(_on_match_ended)
		
		_bind_fighter(match_manager.fighter_1, 1)
		_bind_fighter(match_manager.fighter_2, 2)

func _process(_delta: float) -> void:
	if is_instance_valid(current_pinned_fighter) and pin_escape_container and pin_escape_container.visible:
		pin_escape_bar.value = current_pinned_fighter.pin_escape_progress

func _bind_fighter(f: Fighter, p_idx: int) -> void:
	if not is_instance_valid(f):
		return
		
	if p_idx == 1:
		if p1_name_label: p1_name_label.text = f.char_name.to_upper()
		if p1_title_label: p1_title_label.text = f.char_title
		if p1_vitality_bar:
			p1_vitality_bar.max_value = f.max_vitality
			p1_vitality_bar.value = f.vitality
		if p1_stamina_bar:
			p1_stamina_bar.max_value = f.max_stamina
			p1_stamina_bar.value = f.stamina
		if p1_hype_bar:
			p1_hype_bar.max_value = MatchRules.MAX_HYPE
			p1_hype_bar.value = f.hype
			
		f.vitality_changed.connect(func(cur, max_v):
			if p1_vitality_bar:
				p1_vitality_bar.max_value = max_v
				p1_vitality_bar.value = cur
		)
		f.stamina_changed.connect(func(cur, max_s):
			if p1_stamina_bar:
				p1_stamina_bar.max_value = max_s
				p1_stamina_bar.value = cur
		)
		f.hype_changed.connect(func(cur, max_h):
			if p1_hype_bar:
				p1_hype_bar.max_value = max_h
				p1_hype_bar.value = cur
		)
		f.character_loaded.connect(func(fighter: Fighter):
			if p1_name_label: p1_name_label.text = fighter.char_name.to_upper()
			if p1_title_label: p1_title_label.text = fighter.char_title
			if p1_vitality_bar:
				p1_vitality_bar.max_value = fighter.max_vitality
				p1_vitality_bar.value = fighter.vitality
			if p1_stamina_bar:
				p1_stamina_bar.max_value = fighter.max_stamina
				p1_stamina_bar.value = fighter.stamina
		)
		f.state_changed.connect(func(_old_s, new_s):
			if p1_state_label:
				p1_state_label.text = Fighter.State.keys()[new_s]
		)
	else:
		if p2_name_label: p2_name_label.text = f.char_name.to_upper()
		if p2_title_label: p2_title_label.text = f.char_title
		if p2_vitality_bar:
			p2_vitality_bar.max_value = f.max_vitality
			p2_vitality_bar.value = f.vitality
		if p2_stamina_bar:
			p2_stamina_bar.max_value = f.max_stamina
			p2_stamina_bar.value = f.stamina
		if p2_hype_bar:
			p2_hype_bar.max_value = MatchRules.MAX_HYPE
			p2_hype_bar.value = f.hype
			
		f.vitality_changed.connect(func(cur, max_v):
			if p2_vitality_bar:
				p2_vitality_bar.max_value = max_v
				p2_vitality_bar.value = cur
		)
		f.stamina_changed.connect(func(cur, max_s):
			if p2_stamina_bar:
				p2_stamina_bar.max_value = max_s
				p2_stamina_bar.value = cur
		)
		f.hype_changed.connect(func(cur, max_h):
			if p2_hype_bar:
				p2_hype_bar.max_value = max_h
				p2_hype_bar.value = cur
		)
		f.character_loaded.connect(func(fighter: Fighter):
			if p2_name_label: p2_name_label.text = fighter.char_name.to_upper()
			if p2_title_label: p2_title_label.text = fighter.char_title
			if p2_vitality_bar:
				p2_vitality_bar.max_value = fighter.max_vitality
				p2_vitality_bar.value = fighter.vitality
			if p2_stamina_bar:
				p2_stamina_bar.max_value = fighter.max_stamina
				p2_stamina_bar.value = fighter.stamina
		)
		f.state_changed.connect(func(_old_s, new_s):
			if p2_state_label:
				p2_state_label.text = Fighter.State.keys()[new_s]
		)

func _on_pin_started(_pinner: Fighter, pinned: Fighter) -> void:
	current_pinned_fighter = pinned
	if pin_escape_container:
		pin_escape_container.visible = true
	if center_announcement:
		center_announcement.text = "PIN ATTEMPT!"
		center_announcement.visible = true

func _on_pin_count(count: int) -> void:
	if center_announcement:
		center_announcement.text = "COUNT: " + str(count) + "!"
		center_announcement.visible = true

func _on_pin_broken(reason: String) -> void:
	current_pinned_fighter = null
	if pin_escape_container:
		pin_escape_container.visible = false
	if center_announcement:
		center_announcement.text = "KICK OUT!" if reason == "KICKOUT" else "PIN BROKEN"
		var tween: Tween = create_tween()
		tween.tween_interval(0.8)
		tween.tween_callback(func(): center_announcement.visible = false)

func _on_submission_started(_attacker: Fighter, defender: Fighter) -> void:
	current_pinned_fighter = defender
	if pin_escape_container:
		pin_escape_container.visible = true
	if center_announcement:
		center_announcement.text = "SUBMISSION HOLD!"
		center_announcement.visible = true

func _on_submission_escaped() -> void:
	current_pinned_fighter = null
	if pin_escape_container:
		pin_escape_container.visible = false
	if center_announcement:
		center_announcement.text = "ESCAPED!"
		var tween: Tween = create_tween()
		tween.tween_interval(0.8)
		tween.tween_callback(func(): center_announcement.visible = false)

func _on_rope_break() -> void:
	current_pinned_fighter = null
	if pin_escape_container:
		pin_escape_container.visible = false
	if center_announcement:
		center_announcement.text = "ROPE BREAK!"
		center_announcement.visible = true
		var tween: Tween = create_tween()
		tween.tween_interval(1.2)
		tween.tween_callback(func(): center_announcement.visible = false)

func _on_match_ended(winner: Fighter, method: String) -> void:
	current_pinned_fighter = null
	if pin_escape_container:
		pin_escape_container.visible = false
	if center_announcement:
		center_announcement.visible = false
	if victory_panel:
		victory_panel.visible = true
		if victory_label:
			victory_label.text = winner.char_name.to_upper() + " WINS!\n[" + method + "]\n\nPress [R] to Rematch | [ESC] Character Select"
