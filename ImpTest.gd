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
	add_to_group("zombies")

func _process(delta):
	if camera == null:
		return
		
	var p_fwd = -camera.global_transform.basis.z
	var fwd = -global_transform.basis.z # Godot uses OpenGL convention for its transforms, so looking forward means looking at the negative Z axis
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
		sprite.flip_h = l_dot < 0 # Inverted because of negative z-axis
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
	raycast.cast_to = (-vec_to_player * 1.5) # Inverted because of negative z-axis
	
	#self.look_at(player.translation - vec_to_player, Vector3(0,1,0))
	
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
	look_at(player.translation, Vector3(0, 1, 0))
	#rotate_y(deg2rad(1.0))
	
	#print(rotation_degrees)
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll == player:
			coll.kill()
	
func kill():
	dead = true
	$CollisionShape.disabled = true
	anim_player.play("die")
		
func set_player(p):
	player = p
