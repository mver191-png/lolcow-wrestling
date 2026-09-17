class_name RosterData
extends RefCounted

## Fictional stats and profiles for LOLCOW WRESTLING: OFFLINE MAYHEM.
## All attributes and abilities are fictional game-design choices.

const CHARACTERS: Dictionary = {
	"tophiachu": {
		"id": "tophiachu",
		"name": "Tophiachu",
		"title": "Live & Unfiltered",
		"archetype": "Heavyweight Counter-Brawler",
		"stats": {
			"power": 8,
			"mobility": 3,
			"grappling": 7,
			"stamina": 5,
			"durability": 9,
			"reversal": 4,
			"showmanship": 6
		},
		"moves": {
			"strike": "Comment-Section Clothesline",
			"grapple": "Block-Button Backbreaker",
			"corner": "Going-Live Corner Splash",
			"finisher": "Live-Stream Shutdown",
			"trait": "Last Word"
		},
		"visual": {
			"primary_color": Color(0.45, 0.22, 0.58), # Purple
			"secondary_color": Color(0.12, 0.12, 0.14), # Dark Charcoal
			"height": 1.70,
			"body_scale": Vector3(1.35, 0.95, 1.30),
			"reach": 1.25
		}
	},
	"novaonline": {
		"id": "novaonline",
		"name": "NovaOnline",
		"title": "Main-Event Energy",
		"archetype": "Momentum Heavyweight",
		"stats": {
			"power": 9,
			"mobility": 4,
			"grappling": 6,
			"stamina": 4,
			"durability": 9,
			"reversal": 3,
			"showmanship": 7
		},
		"moves": {
			"strike": "Buffering Bodycheck",
			"ground": "Main-Character Elbow",
			"corner": "Offline Avalanche",
			"finisher": "Going Offline",
			"trait": "Momentum Feed"
		},
		"visual": {
			"primary_color": Color(0.85, 0.15, 0.15), # Red
			"secondary_color": Color(0.9, 0.8, 0.2), # Gold
			"height": 1.85,
			"body_scale": Vector3(1.25, 1.05, 1.15),
			"reach": 1.35
		}
	},
	"cyraxx": {
		"id": "cyraxx",
		"name": "Cyraxx",
		"title": "Feedback Frenzy",
		"archetype": "Lightweight Burst Striker",
		"stats": {
			"power": 4,
			"mobility": 9,
			"grappling": 5,
			"stamina": 6,
			"durability": 3,
			"reversal": 8,
			"showmanship": 7
		},
		"moves": {
			"strike": "Feedback Flurry",
			"grapple": "Mic-Drop DDT",
			"counter": "Encore Reversal",
			"finisher": "Raxx and Ruin",
			"trait": "Overdrive"
		},
		"visual": {
			"primary_color": Color(0.15, 0.55, 0.35), # Dark Olive Green
			"secondary_color": Color(0.2, 0.2, 0.2), # Black
			"height": 1.55,
			"body_scale": Vector3(0.78, 0.88, 0.78),
			"reach": 0.95
		}
	},
	"candy_rooks": {
		"id": "candy_rooks",
		"name": "Candy Rooks",
		"title": "Kitchen-Sink Brawler",
		"archetype": "Combination Grappler",
		"stats": {
			"power": 7,
			"mobility": 4,
			"grappling": 8,
			"stamina": 6,
			"durability": 8,
			"reversal": 5,
			"showmanship": 4
		},
		"moves": {
			"strike": "Kitchen-Sink Combo",
			"rush": "Ragoon Rush",
			"grapple": "Second-Helping Side Slam",
			"finisher": "Ribs & Kidney Beans",
			"trait": "Recipe Combo"
		},
		"visual": {
			"primary_color": Color(0.85, 0.45, 0.65), # Pink/Apron
			"secondary_color": Color(0.95, 0.95, 0.95), # White
			"height": 1.68,
			"body_scale": Vector3(1.22, 0.96, 1.20),
			"reach": 1.18
		}
	},
	"andy_ditch": {
		"id": "andy_ditch",
		"name": "Andy Ditch",
		"title": "Immovable Object",
		"archetype": "Territory Anchor Grappler",
		"stats": {
			"power": 8,
			"mobility": 2,
			"grappling": 9,
			"stamina": 5,
			"durability": 10,
			"reversal": 4,
			"showmanship": 4
		},
		"moves": {
			"counter": "Sit-Down Counter",
			"grapple": "Deadweight Takedown",
			"taunt": "Complaint Department",
			"finisher": "Case Closed",
			"trait": "Hold My Ground"
		},
		"visual": {
			"primary_color": Color(0.25, 0.35, 0.65), # Denim Blue
			"secondary_color": Color(0.6, 0.6, 0.6), # Grey
			"height": 1.72,
			"body_scale": Vector3(1.30, 0.92, 1.25),
			"reach": 1.15
		}
	},
	"jupiter_the_hybrid": {
		"id": "jupiter_the_hybrid",
		"name": "Jupiter the Hybrid",
		"title": "Double Feature",
		"archetype": "Stance-Shift Grappler",
		"stats": {
			"power": 6,
			"mobility": 7,
			"grappling": 7,
			"stamina": 5,
			"durability": 5,
			"reversal": 6,
			"showmanship": 6
		},
		"moves": {
			"stance": "Hybrid Shift",
			"strike": "Moonrise Lariat",
			"counter": "Midnight Counter",
			"finisher": "Eclipse Driver",
			"trait": "Best of Both"
		},
		"visual": {
			"primary_color": Color(0.2, 0.1, 0.35), # Deep Violet
			"secondary_color": Color(0.8, 0.8, 0.9), # Silver
			"height": 1.80,
			"body_scale": Vector3(1.05, 1.02, 1.02),
			"reach": 1.28
		}
	},
	"anacondasin": {
		"id": "anacondasin",
		"name": "AnacondaSin",
		"title": "The Counter-Coil",
		"archetype": "Positional Submission Specialist",
		"stats": {
			"power": 5,
			"mobility": 6,
			"grappling": 9,
			"stamina": 6,
			"durability": 5,
			"reversal": 7,
			"showmanship": 4
		},
		"moves": {
			"feint": "Question-Time Feint",
			"counter": "Coil Counter",
			"sweep": "Wraparound Sweep",
			"finisher": "Anaconda Lock",
			"trait": "Tightening Grip"
		},
		"visual": {
			"primary_color": Color(0.15, 0.45, 0.25), # Emerald Green
			"secondary_color": Color(0.85, 0.75, 0.3), # Gold
			"height": 1.65,
			"body_scale": Vector3(1.10, 0.98, 1.10),
			"reach": 1.20
		}
	},
	"daniel_larson": {
		"id": "daniel_larson",
		"name": "Daniel Larson",
		"title": "Roaring Thunder",
		"archetype": "Mobile Opportunist",
		"stats": {
			"power": 4,
			"mobility": 9,
			"grappling": 4,
			"stamina": 8,
			"durability": 3,
			"reversal": 7,
			"showmanship": 7
		},
		"moves": {
			"strike": "Roaring Thunder Knee",
			"aerial": "Stage-Dive Elbow",
			"escape": "Tour-Bus Escape",
			"finisher": "Final Encore",
			"trait": "Touring Legs"
		},
		"visual": {
			"primary_color": Color(0.85, 0.45, 0.1), # Bright Orange
			"secondary_color": Color(0.2, 0.2, 0.25), # Slate
			"height": 1.78,
			"body_scale": Vector3(0.82, 1.02, 0.80),
			"reach": 1.30
		}
	}
}

static func get_character(id: String) -> Dictionary:
	return CHARACTERS.get(id, {})

static func get_all_ids() -> Array:
	return CHARACTERS.keys()
