extends KinematicBody

const MOVE_SPEED = 8
const MOUSE_SENS = 0.5

onready var anim_player = $AnimationPlayer
onready var bobbing_player = $BobbingPlayer
onready var raycast = $RayCast
onready var camera = $Camera
onready var state_machine = $AnimationTree.get("parameters/playback")

var move_vec

func _ready():
	state_machine.start('still')
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Get mouse stuck on center
	yield(get_tree(), "idle_frame") # Wait one frame
	get_tree().call_group("zombies", "set_player", self) # set the player on all enemies
	get_tree().call_group("zombies", "set_camera", camera) # set the camera on all imps

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
		
func _process(delta):

	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_pressed("restart"):
		kill()

	
	if move_vec != Vector3(0,0,0) && !anim_player.is_playing():
		print("hooray")
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
		anim_player.play("shoot")
		$AudioStreamPlayer.play()
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("kill"):
			coll.kill()
			
func kill():
	get_tree().reload_current_scene()