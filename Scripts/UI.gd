extends MarginContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var init_enemies = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("calc_init_enemies")

func _process(delta):
	var current_enemies = get_tree().get_nodes_in_group("zombies").size()
	$Top/VBoxContainer/Label.text = "Enemies: " + str(current_enemies) + "/" + str(init_enemies)
	
	if current_enemies < 1:	
		yield(get_tree().create_timer(1), "timeout")
		get_tree().paused = true
		if $Panel.modulate.a < 1:
			$Panel.modulate.a += 0.8 * delta

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
		
func calc_init_enemies():
	init_enemies = get_tree().get_nodes_in_group("zombies").size();