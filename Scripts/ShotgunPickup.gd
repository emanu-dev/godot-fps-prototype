extends WeaponPickup

func _ready():
	add_to_group("items")
	weapon_obj = { "name" : "Shotgun",
			"type": weapon_types.SPREAD,
			"anim": "shotgun",
			"shot_sfx": load("res://SFX/shot-shotgun.wav"),
			"shotrange": -15,
			"rate": 1.6,
			"damage": 70,
			"max_ammo": 8,
			"ammo": 8 }