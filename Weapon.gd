extends Node

onready var anim_player = get_parent().get_node("AnimationPlayer")
onready var bobbing_player = get_parent().get_node("BobbingPlayer")
onready var raycast = get_parent().get_node("RayCast")
onready var state_machine =  get_parent().get_node("AnimationTree").get("parameters/playback")

var weapon_inv = [{}]
var current_weapon setget set_current_weapon, get_current_weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_inv.append({ "name" : "Pistol",
	"texture": load("res://Sprites/Gun.png"),
	"frames": {"h": 1, "v": 4},
	"range": -2000,
	"damage": 34,
	"max_ammo": 25,
	"ammo": 25 })
	
func set_current_weapon(index):
	current_weapon = weapon_inv[index]
	
func get_current_weapon():
	return current_weapon

func switch_weapon_up():
	pass

func switch_weapon_down():
	pass

func update_weapon_parameters():
	pass
	
func shoot_weapon():
	pass
#func _process(delta):
#	pass
