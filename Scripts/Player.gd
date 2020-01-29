extends KinematicBody

signal health_update
signal weapon_change
signal ammo_update

onready var anim_player = $AnimationPlayer
onready var bobbing_player = $BobbingPlayer
onready var raycast = $RayCast
onready var camera = $Camera
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var feedback_canvas = $FeedbackCanvas

var health = 100
const MOVE_SPEED = 800
const MOUSE_SENS = 0.5
var move_vec = Vector3()
var gravity = 50
var jump_height = 15
var has_contact = false

func _ready():
	state_machine.start('still')
	emit_signal("health_update", self)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Get mouse stuck on center
	yield(get_tree(), "idle_frame") # Wait one frame
	get_tree().call_group("zombies", "set_player", self) # set the player on all enemies
	get_tree().call_group("zombies", "set_camera", camera) # set the camera on all imps
	get_tree().call_group("items", "set_player", self) # set the player on all enemies

func _input(event):
	if event is InputEventMouseMotion && health > 0:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
		#rotation_degrees.x -= MOUSE_SENS * event.relative.y
		
func _process(delta):
	if health > 0:
		if Input.is_action_just_pressed("exit"):
			get_tree().change_scene("res://Scenes/MainMenu.tscn")
		if Input.is_action_pressed("restart"):
			get_tree().reload_current_scene()
		
		#FIX THIS DOWN BELOW -> KISS
		if Input.is_action_just_released("switch_weapon_up"):
			if !$Weapon.is_switching_weapon():
				$Weapon.set_switching_weapon(true)
				state_machine.travel("down_weapon")
				yield(get_tree().create_timer(.4), "timeout")
				$Weapon.switch_weapon_up()
				state_machine.travel("up_weapon")
				yield(get_tree().create_timer(.4), "timeout")
				$Weapon.set_switching_weapon(false)
	
		if Input.is_action_just_released("switch_weapon_down"):
			if !$Weapon.is_switching_weapon():
				$Weapon.set_switching_weapon(true)
				state_machine.travel("down_weapon")
				yield(get_tree().create_timer(.4), "timeout")	
				$Weapon.switch_weapon_down()
				state_machine.travel("up_weapon")
				yield(get_tree().create_timer(.4), "timeout")	
				$Weapon.set_switching_weapon(false)
		
		if move_vec.x != 0 && !anim_player.is_playing() && !$Weapon.is_switching_weapon():
			state_machine.travel("walking")
		elif $Weapon.is_switching_weapon():
			pass
		else:
			state_machine.travel("still")
	
func _physics_process(delta):
	move_vec = Vector3()
	
	if health > 0:
		if Input.is_action_pressed("move_forwards"):
			move_vec.z -= 1
		if Input.is_action_pressed("move_backwards"):
			move_vec.z += 1
		if Input.is_action_pressed("move_left"):
			move_vec.x -= 1
		if Input.is_action_pressed("move_right"):
			move_vec.x += 1		
			
		if (is_on_floor()):
			has_contact = true
		else:
			if !$SlopeRayCast.is_colliding():
				has_contact = false
				
		if (has_contact and !is_on_floor()):
			if (abs(move_vec.x) + abs(move_vec.z) != 0):
				move_and_collide(Vector3(0, -1, 0))
				move_vec.y -= gravity * delta

		move_vec = move_vec.normalized()
		move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
		move_and_slide(move_vec * MOVE_SPEED * delta, Vector3(0, 1, 0), true)
		
		if Input.is_action_just_pressed("shoot") and !$Weapon.has_ammo():
			$Weapon.no_ammo_clip()
		
		if Input.is_action_pressed("shoot"):
			if $Weapon.can_shoot():
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
	state_machine.stop()
	bobbing_player.play("dead")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://Scenes/Levels/World.tscn")
	
func set_health(value):
	health = value
	emit_signal("health_update", self)
	
func get_health():
	return health

func get_weapon_system():
	return $Weapon
