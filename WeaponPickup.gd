extends Node

enum weapon_types {MELEE, PISTOL, SPREAD, RAPID}
var properties = {}

func construct(weapon_name, weapon_type, texture_path, shot_sfx_path, frames, shot_range, fire_rate, max_damage, max_ammo, initial_ammo):
	properties["name"] = weapon_name
	properties["type"] = weapon_type
	properties["texture"] = load(texture_path)
	properties["shot_sfx"] = load(shot_sfx_path)
	properties["frames"] = {"h": frames.h, "v": frames.v}
	properties["shotrange"] = shot_range
	properties["rate"] = fire_rate
	properties["damage"] = max_damage
	properties["max_ammo"] = max_ammo
	properties["ammo"] = initial_ammo
	
