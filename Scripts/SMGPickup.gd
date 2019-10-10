extends WeaponPickup

func _ready():
	add_to_group("items")
	weapon_obj = { "name" : "Machine Gun",
		"type": weapon_types.RAPID,
		"anim": "smg",
		"shot_sfx": load("res://SFX/shot-handgun.wav"),
		"shotrange": -200,
		"rate": .2,
		"damage": 25,
		"max_ammo": 350,
		"ammo": 350 }