extends KinematicBody

export var anim_col = 0
signal target_entered
signal target_exited

var camera = null
func set_camera(c):
	camera = c 

var sfx_groan = load("res://SFX/groan.wav")

const MOVE_SPEED = 5
const DETECT_RADIUS = 20
const DETECT_FOV = 20

var foundPlayer = false

onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite3D
onready var audio_stream = $AudioStreamPlayer3D

var player = null
var dead = false
var hurt = false

var health = 100
export var attack_range = 1.8


func _ready():
	add_to_group("zombies")
	$DirectionPlaceholder.visible = false
	raycast.cast_to = Vector3(0, 0, -attack_range)

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
	
	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll == player:
			coll.hurt(2)
	
func kill():
	dead = true
	$CollisionShape.disabled = true
	$Area.monitoring = false

func hurt(dmg):
	$Blood.burst()
	if health - dmg <= 0:
		health = 0
		kill()
	else:
		hurt = true
		health -= dmg

func set_player(p):
	player = p

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

func check_fov():
	if player == null:
		return
	
	var distance_to_player = _get_distance_from_target(player)
	if abs(distance_to_player) < DETECT_RADIUS:
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(self.translation, player.translation, [self], collision_mask)
		if result:
			var angle_on_fov = rad2deg(self.translation.angle_to(result.collider.translation))
			if result.collider == player && angle_on_fov < DETECT_FOV && !foundPlayer:
				emit_signal("target_entered")
	else:
		emit_signal("target_exited")	
	
func follow_target (target):
	var vec_to_target = target.translation - translation
	vec_to_target = vec_to_target.normalized()
	
	look_at(target.translation, Vector3(0, 1, 0))
	move_and_collide(vec_to_target * MOVE_SPEED * get_physics_process_delta_time () )

func _on_ImpTest_target_entered():
	$Area/CollisionShape.disabled = true;
	foundPlayer = true

func sound_play_groan(audio_stream):
	audio_stream.play_found()

func _get_distance_from_target(target):
	return self.translation.distance_to(target.translation)