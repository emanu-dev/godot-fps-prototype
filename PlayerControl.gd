extends KinematicBody

const MOVE_SPEED = 10
const MOUSE_SENS = 0.5

signal health_update
signal weapon_change

onready var anim_player = $AnimationPlayer
onready var bobbing_player = $BobbingPlayer
onready var raycast = $RayCast
onready var camera = $Camera
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var feedback_canvas = $FeedbackCanvas

var move_vec
var health = 100

func _ready():
	state_machine.start('still')
	emit_signal("health_update", self)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Get mouse stuck on center
	yield(get_tree(), "idle_frame") # Wait one frame
	get_tree().call_group("zombies", "set_player", self) # set the player on all enemies
	get_tree().call_group("zombies", "set_camera", camera) # set the camera on all imps
	$Weapon.call_deferred("set_current_weapon", 1)

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
		#rotation_degrees.x -= MOUSE_SENS * event.relative.y
		
func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_pressed("restart"):
		kill()
	
	if Input.is_action_just_released("switch_weapon_up"):
		$Weapon.switch_weapon_down()
		emit_signal("weapon_change", $Weapon.get_current_weapon().name, $Weapon.get_current_weapon().ammo)

	if Input.is_action_just_released("switch_weapon_down"):
		$Weapon.switch_weapon_up()
		emit_signal("weapon_change", $Weapon.get_current_weapon().name, $Weapon.get_current_weapon().ammo)
	
	if move_vec != Vector3(0,0,0) && !anim_player.is_playing():
		state_machine.travel("walking")
	else:
		state_machine.travel("still")		
		
		
func _physics_process(delta):
	move_vec = Vector3()	
	
	if Input.is_action_pressed("move_forwards"):
		move_vec.z -= 1
	if Input.is_action_pressed("move_backwards"):
		move_vec.z += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1		
		
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_and_collide(move_vec * MOVE_SPEED * delta)
	
	if Input.is_action_pressed("shoot") and !anim_player.is_playing():
		$Weapon.shoot_weapon()
		#state_machine.travel("still")
		#anim_player.play("shoot")
		#$AudioStreamPlayer.play()
		#var coll = raycast.get_collider()
		#if raycast.is_colliding() and coll.has_method("hurt"):
		#	coll.hurt(34)

func hurt(dmg):
	if health - dmg <= 0:
		health = 0
		kill()
	else:
		health -= dmg
	
	feedback_canvas.feedback_hurt()
	emit_signal("health_update", self)

func kill():
	get_tree().reload_current_scene()