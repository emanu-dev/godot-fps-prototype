extends KinematicBody

export var anim_col = 0

var camera = null
func set_camera(c):
	camera = c 

const MOVE_SPEED = 3

var foundPlayer = false

onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite3D

var player = null
var dead = false

func _ready():
	anim_player.play("walk")
	add_to_group("zombies")
	$DirectionPlaceholder.visible = false

func _process(delta):
	if camera == null:
		return
		
	var row = _check_sprite_direction (camera)
	sprite.frame = anim_col + row * sprite.hframes

	
func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
		
	if foundPlayer:
		_follow_target(player, delta)
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll == player:
			coll.kill()
	
func kill():
	dead = true
	$CollisionShape.disabled = true
	$Area.monitoring = false
	anim_player.play("die")
		
func set_player(p):
	player = p

func _on_Area_body_entered(body):
	if body == player:
		$AudioStreamPlayer.play()
		$Area/CollisionShape.disabled = true;
		print ("Entered")
		foundPlayer = true


func _check_sprite_direction (camera):
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

	return row	
	
func _follow_target (target, delta):
	var vec_to_target = target.translation - translation
	vec_to_target = vec_to_target.normalized()
	
	look_at(target.translation, Vector3(0, 1, 0))
	move_and_collide(vec_to_target * MOVE_SPEED * delta)