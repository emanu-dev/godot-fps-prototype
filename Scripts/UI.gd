extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Player_health_update(player):
	$HBoxContainer/VBoxContainer/LifeCounter.text = str(player.health) +  "%"
	if player.health < 30:
		$HBoxContainer/VBoxContainer/LifeCounter.set("custom_colors/font_color", Color(1,0,0))
	elif player.health < 50:
			$HBoxContainer/VBoxContainer/LifeCounter.set("custom_colors/font_color", Color(1,1,0))
	else:
			$HBoxContainer/VBoxContainer/LifeCounter.set("custom_colors/font_color", Color(0,1,0))
	
func _on_Player_weapon_change(name, ammo):
	$HBoxContainer/VBoxContainer2/AmmoLabel.text = name
	update_ammo(ammo)	

func _on_Player_ammo_update(ammo):
	update_ammo(ammo)	

func update_ammo(ammo):
	if ammo >= 0:
		$HBoxContainer/VBoxContainer2/AmmoCounter.text = str(ammo)
	else:
		$HBoxContainer/VBoxContainer2/AmmoCounter.text = ""	