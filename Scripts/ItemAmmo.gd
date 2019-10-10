extends Sprite3D

var player
var ammo
enum weapon_types {MELEE, PISTOL, SPREAD, RAPID}
export (weapon_types) var ammo_type

func _ready():
	add_to_group("items")
	match ammo_type:
		weapon_types.PISTOL:
			self.texture = load("res://Sprites/Items/FN45.png")
			ammo = 10
		weapon_types.SPREAD:
			self.texture = load("res://Sprites/Items/SawedOff.png")
			ammo = 3
		weapon_types.RAPID:
			self.texture = load("res://Sprites/Items/AKM.png")
			ammo = 50

func _process(delta):
	$AnimationPlayer.play("Hover")

func set_player(p):
	player = p

func restore_ammo():
	return self.ammo
	
func destroy():
	$AudioStreamPlayer.play()
	$Area/CollisionShape.disabled = true
	self.visible = false
	yield($AudioStreamPlayer, "finished")
	get_parent().remove_child(self)

func _on_Area_body_entered(body):
	if player != null && body == player:
		var weapon_index = player.get_weapon_system().has_weapon_type(ammo_type)
		if weapon_index != null:
			var x = player.get_weapon_system().increase_ammo(weapon_index, restore_ammo())
			if x == false:
				return
			player.feedback_canvas.feedback_ammo()
			destroy()
