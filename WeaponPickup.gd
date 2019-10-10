extends Sprite3D

class_name WeaponPickup

var player
enum weapon_types {MELEE, PISTOL, SPREAD, RAPID}
var weapon_obj = {}

func _process(delta):
	$AnimationPlayer.play("Hover")

func set_player(p):
	player = p
	
func destroy():
	yield($AudioStreamPlayer, "finished")
	get_parent().remove_child(self)

func _on_Area_body_entered(body):
	if player != null && body == player:
		var weapon_inv = player.get_weapon_system().get_weapon_inv()
		weapon_inv.append(weapon_obj)
		
		player.feedback_canvas.feedback_recover()
		player.get_weapon_system().set_current_weapon(weapon_inv.size() - 1)
		$AudioStreamPlayer.play()
		$Area/CollisionShape.disabled = true
		self.visible = false		
		destroy()
	else:
		return
