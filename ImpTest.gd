extends KinematicBody

export var anim_col = 0

var camera = null
func set_camera(c):
	camera = c 

const MOVE_SPEED = 3

onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite3D

var player = null
var dead = false

func _ready():
	anim_player.play("walk")

func _process(delta):
	if camera == null:
		return
		
	var p_fwd = -camera.global_transform.basis.z
	var fwd = global_transform.basis.z
	var left = global_transform.basis.x
	
	var l_dot = left.dot(p_fwd)
	var f_dot = fwd.dot(p_fwd)
	
	var row = 0
	sprite.flip_h = false
	if f_dot < -0.85:
		row = 0 # front sprite
	elif f_dot > 0.85:
		row = 4 # back sprite
	else: 
		sprite.flip_h = l_dot > 0
		if abs(f_dot) < 0.3:
			row = 2 # left sprite
		elif f_dot < 0:
			row = 1 # forward left sprite
		else:
			row = 3 # back left sprite
	
	sprite.frame = anim_col + row * sprite.hframes
	
	
func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
		
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	raycast.cast_to = vec_to_player * 1.5
	
	# move_and_collide(vec_to_player * MOVE_SPEED * delta)
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == "Player":
			coll.kill()
	
func kill():
	dead = true
	$CollisionShape.disabled = true
	# anim_player.play("die")
		
func set_player(p):
	player = p
