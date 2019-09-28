extends KinematicBody

const MOVE_SPEED = 10
const MOUSE_SENS = 0.5

signal health_update
signal weapon_change
signal ammo_update

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
		if !$Weapon.is_switching_weapon():
			$Weapon.set_switching_weapon(true)
			$Weapon.switch_weapon_down()
			yield(get_tree().create_timer(.4), "timeout")	
			$Weapon.set_switching_weapon(false)

	if Input.is_action_just_released("switch_weapon_down"):
		if !$Weapon.is_switching_weapon():
			$Weapon.set_switching_weapon(true)
			$Weapon.switch_weapon_up()
			yield(get_tree().create_timer(.4), "timeout")	
			$Weapon.set_switching_weapon(false)
	
	if move_vec != Vector3(0,0,0) && !anim_player.is_playing() && !$Weapon.is_switching_weapon():
		state_machine.travel("walking")
	elif $Weapon.is_switching_weapon():
		if state_machine.get_current_node() == "up_weapon":
			$Weapon.weapon_sprite.visible = true
		else:
			$Weapon.weapon_sprite.visible = false
			state_machine.travel("up_weapon")
	else:
		state_machine.travel("still")
		
	print($Weapon.is_switching_weapon())
		
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
		if !$Weapon.is_switching_weapon():
			$Weapon.shoot_weapon()

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