extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Player_health_update(player):
	$HBoxContainer/VBoxContainer/LifeCounter.text = str(player.health) +  "%"
	
func _on_Player_weapon_change(name, ammo):
	$HBoxContainer/VBoxContainer2/AmmoLabel.text = name
	$HBoxContainer/VBoxContainer2/AmmoCounter.text = str(ammo)

func _on_Player_ammo_update(ammo):
	$HBoxContainer/VBoxContainer2/AmmoCounter.text = str(ammo)
