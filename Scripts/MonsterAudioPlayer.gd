extends AudioStreamPlayer3D

var found_sfx = []
var shot_sfx = []
var attack_sfx = []
var die_sfx = []

# Called when the node enters the scene tree for the first time.
func _ready():
	found_sfx.append(load("res://SFX/monsters/monster-found-1.wav"))
	found_sfx.append(load("res://SFX/monsters/monster-found-2.wav"))
	
	shot_sfx.append(load("res://SFX/monsters/monster-shot-1.wav"))
	shot_sfx.append(load("res://SFX/monsters/monster-shot-2.wav"))
	shot_sfx.append(load("res://SFX/monsters/monster-shot-3.wav"))
	
	attack_sfx.append(load("res://SFX/monsters/monster-attack-1.wav"))
	attack_sfx.append(load("res://SFX/monsters/monster-attack-2.wav"))
	
	die_sfx.append(load("res://SFX/monsters/monster-die-1.wav"))
	die_sfx.append(load("res://SFX/monsters/monster-die-2.wav"))

func play_found():
	self.stop()
	var source_index = randi() % found_sfx.size()
	self.stream = found_sfx[source_index]
	self.play()

func play_shot():
	self.stop()
	var source_index = randi() % shot_sfx.size()
	self.stream = shot_sfx[source_index]
	self.play()
	
func play_die():
	self.stop()
	var source_index = randi() % die_sfx.size()
	self.stream = die_sfx[source_index]
	self.play()	