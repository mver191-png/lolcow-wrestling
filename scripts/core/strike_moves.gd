class_name StrikeMoves
extends RefCounted
## Gameplay-owned hit schedules. Fractions divide ONE strike's damage/Hype budget.
## Presentation reads the same identifier and clock but never causes damage.

static func definition(character_id: String) -> Dictionary:
	if character_id == "cyraxx":
		return {"id": "feedback_flurry", "duration": 0.45, "hits": [
			{"id": 0, "start": 0.12, "end": 0.175, "share": 0.25, "hand": "L"},
			{"id": 1, "start": 0.225, "end": 0.275, "share": 0.30, "hand": "R"},
			{"id": 2, "start": 0.325, "end": 0.38, "share": 0.45, "hand": "L"}]}
	if character_id == "tophiachu":
		return {"id": "comment_section_clothesline", "duration": 0.45, "hits": [
			{"id": 0, "start": 0.12, "end": 0.32, "share": 1.0, "hand": "R"}]}
	return {"id": "standard_strike", "duration": 0.45, "hits": [
		{"id": 0, "start": 0.12, "end": 0.32, "share": 1.0, "hand": "R"}]}

static func display_name(character_id: String) -> String:
	return str(RosterData.get_character(character_id).get("moves", {}).get("strike", "Strike"))
