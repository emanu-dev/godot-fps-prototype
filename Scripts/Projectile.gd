extends KinematicBody

var player = null
var target = null
var parent = null

const MOVE_SPEED = 12

func destroy():
	self.visible = false
	parent.set_projectile(null)
	get_parent().remove_child(self)

func set_player(p):
	player = p

func set_parent(p):
	parent = p

# Called when the node enters the scene tree for the first time.
func _ready():
	translation = parent.translation
	target = (player.translation - translation).normalized()
	
func _physics_process(delta):
	if target != null && player != null:
		move_and_collide(target * MOVE_SPEED * delta)
	else:
		destroy()		

func _process(delta):
	$AnimationPlayer.play("loop")
	if translation.distance_to(parent.translation) > 10:
		destroy()	
		
func _on_Area_body_entered(body):
	if body == player:
		body.hurt(15)
		destroy()

