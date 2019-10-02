extends Sprite3D

var player
var hp = 25

func _ready():
	add_to_group("items")

func _process(delta):
	$AnimationPlayer.play("Hover")

func set_player(p):
	player = p

func restore_health():
	return self.hp
	
func destroy():
	$AudioStreamPlayer.play()
	$Area/CollisionShape.disabled = true
	self.visible = false
	yield($AudioStreamPlayer, "finished")
	get_parent().remove_child(self)

func _on_Area_body_entered(body):
	if player != null && body == player && player.get_health() < 100:
		var new_health = min(player.get_health() + restore_health(), 100)
		player.set_health(new_health)
		player.feedback_canvas.feedback_recover()
		destroy()
	pass
