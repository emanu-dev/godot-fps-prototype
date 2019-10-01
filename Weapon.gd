extends Node

onready var anim_player = get_parent().get_node("AnimationPlayer")
onready var bobbing_player = get_parent().get_node("BobbingPlayer")
onready var raycast = get_parent().get_node("RayCast")
onready var state_machine =  get_parent().get_node("AnimationTree").get("parameters/playback")
onready var weapon_canvas = get_parent().get_node("WeaponCanvas")
onready var weapon_sprite = get_parent().get_node("WeaponCanvas/Control/WeaponSprite")
onready var audio_stream = get_parent().get_node("AudioStreamPlayer")

var weapon_inv = []
var current_weapon setget set_current_weapon, get_current_weapon
var switching_weapon = false setget set_switching_weapon, is_switching_weapon
var current_index = 0
var can_shoot = true setget set_can_shoot, can_shoot

# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_inv.append({ "name" : "Pistol",
	"texture": load("res://Sprites/Weapon/pistol-pixelator.png"),
	"shot_sfx": load("res://SFX/shot-handgun.wav"),
	"frames": {"h": 4, "v": 1},
	"shotrange": -100,
	"rate": .6,
	"damage": 34,
	"max_ammo": 25,
	"ammo": 25 })
	
	weapon_inv.append({ "name" : "Machine Gun",
	"texture": load("res://Sprites/Weapon/smg-pixelator.png"),
	"shot_sfx": load("res://SFX/shot-handgun.wav"),
	"frames": {"h": 4, "v": 1},
	"shotrange": -200,
	"rate": .2,
	"damage": 10,
	"max_ammo": 350,
	"ammo": 350 })	

	weapon_inv.append({ "name" : "Shotgun",
	"texture": load("res://Sprites/Weapon/shotgun-pixelator.png"),
	"shot_sfx": load("res://SFX/shot-handgun.wav"),
	"frames": {"h": 4, "v": 1},
	"shotrange": -50,
	"rate": 1.6,
	"damage": 50,
	"max_ammo": 8,
	"ammo": 8 })
	
	state_machine.start("up_weapon")
	call_deferred("set_current_weapon", 0)
	
func set_current_weapon(index):
	current_weapon = weapon_inv[index]
	update_weapon_parameters(current_weapon)	
	get_parent().emit_signal("weapon_change", get_current_weapon().name, get_current_weapon().ammo)
	
	
func get_current_weapon():
	return current_weapon

func switch_weapon_up():
	if (current_index + 1) >= weapon_inv.size():
		current_index = 0
	else:
		current_index += 1
	
	set_current_weapon(current_index)

func switch_weapon_down():
	if (current_index - 1) < 0:
		current_index = weapon_inv.size() - 1
	else:
		current_index -= 1
		
	set_current_weapon(current_index)

func update_weapon_parameters(current_weapon):
	weapon_sprite.texture = current_weapon.texture
	weapon_sprite.hframes = current_weapon.frames.h
	weapon_sprite.vframes = current_weapon.frames.v
	
	raycast.cast_to = Vector3(0,0, current_weapon.shotrange)
	
func shoot_weapon():
	if current_weapon.ammo > 0:
		set_can_shoot(false)
		state_machine.travel("still")
		anim_player.play("shoot")
		audio_stream.play()
		decrease_ammo(1)
		var coll = raycast.get_collider()
		
		if raycast.is_colliding() and coll.has_method("hurt"):
			print (coll.health)
			var distance = clamp(get_parent().translation.distance_to(coll.translation), 10, 40) - 10
			coll.hurt(current_weapon.damage - distance)
			print (coll.health)
		
		yield(get_tree().create_timer(current_weapon.rate), "timeout")	
		set_can_shoot(true)
		
func decrease_ammo(amount):
	current_weapon.ammo -= amount
	get_parent().emit_signal("ammo_update", current_weapon.ammo)
	
func increase_ammo(amount):
	current_weapon.ammo += amount
	get_parent().emit_signal("ammo_update", current_weapon.ammo)
	
func set_switching_weapon(switching):
	switching_weapon = switching

func is_switching_weapon():
	return switching_weapon

func set_can_shoot(flag):
	can_shoot = flag
	
func can_shoot():
	return can_shoot