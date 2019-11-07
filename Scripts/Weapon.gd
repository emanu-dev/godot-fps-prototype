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
var current_index = 1
var can_shoot = true setget set_can_shoot, can_shoot
var weapon_click = true
enum weapon_types {MELEE, PISTOL, SPREAD, RAPID}

# Called when the node enters the scene tree for the first time.
func _ready():
	weapon_inv.append({ "name" : "Bat",
	"type": weapon_types.MELEE,
	"anim": "bat",
	"shot_sfx": load("res://SFX/bat-swoosh.wav"),
	"shotrange": -5,
	"rate": .6,
	"damage": 30,
	"max_ammo": -1,
	"ammo": -1 })	
	
	weapon_inv.append({ "name" : "Handgun",
	"type": weapon_types.PISTOL,
	"anim": "handgun",
	"shot_sfx": load("res://SFX/shot-handgun.wav"),
	"shotrange": -100,
	"rate": .6,
	"damage": 50,
	"max_ammo": 25,
	"ammo": 10 })

	call_deferred("set_current_weapon", current_index)
	state_machine.start("up_weapon")

func _process(delta):
	if !weapon_click:
		weapon_click = true
	
func set_current_weapon(index):
	current_weapon = weapon_inv[index]
	update_weapon_parameters(current_weapon)	
	get_parent().emit_signal("weapon_change", get_current_weapon().name, get_current_weapon().ammo)
	anim_player.play(current_weapon["anim"] + "-idle")
	current_index = index
	
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
	raycast.cast_to = Vector3(0,0, current_weapon.shotrange)
	
func shoot_weapon():
	
	if current_weapon.ammo > 0 || current_weapon["type"] == weapon_types.MELEE:
		set_can_shoot(false)
		state_machine.travel("still")
		anim_player.play(current_weapon["anim"])
		audio_stream.stream = current_weapon["shot_sfx"]
		audio_stream.play()
		decrease_ammo(1)
		
		var enemies_to_shoot
		if current_weapon["type"] == weapon_types.SPREAD:
			enemies_to_shoot = get_enemies_in_range("zombies", current_weapon["shotrange"], 25, get_parent(), 3)
			for enemy in enemies_to_shoot:
				shoot_enemy(get_parent(), enemy, current_weapon["shotrange"], current_weapon["damage"])
		else:
			enemies_to_shoot = get_enemy_in_front(raycast, "zombies")
			shoot_enemy(get_parent(), enemies_to_shoot, current_weapon["shotrange"], current_weapon["damage"])			
		
		yield(get_tree().create_timer(current_weapon.rate), "timeout")	
		set_can_shoot(true)

func has_ammo():
	return current_weapon.ammo > 0 || current_weapon["type"] == weapon_types.MELEE

func no_ammo_clip():
	audio_stream.stream = load("res://SFX/out_of_ammo.wav")
	audio_stream.play()

func decrease_ammo(amount):
	current_weapon.ammo -= amount
	get_parent().emit_signal("ammo_update", current_weapon.ammo)
	
func increase_ammo(index, amount):
	if weapon_inv[index].ammo < weapon_inv[index].max_ammo:
		weapon_inv[index].ammo = min(weapon_inv[index].ammo + amount, weapon_inv[index].max_ammo)
		get_parent().emit_signal("ammo_update", current_weapon.ammo)
		return true
	else:
		return false

func has_weapon_type(type):
	for i in len(weapon_inv):
		if weapon_inv[i].type == type:
			return i
	return null

func set_switching_weapon(switching):
	switching_weapon = switching

func is_switching_weapon():
	return switching_weapon

func set_can_shoot(flag):
	can_shoot = flag
	
func can_shoot():
	return can_shoot
	
func get_weapon_types():
	return weapon_types
	
func get_weapon_inv():
	return weapon_inv
	
func get_enemies_in_range(group, weapon_range, weapon_radius, player, total):
	var enemy_array = []
	var result_array = []
	var i = 0
	
	#Get all enemies within weapon range
	var enemies = get_tree().get_nodes_in_group(group)
	for enemy in enemies:
		var distance = player.translation.distance_to(enemy.translation)
		if distance <= abs(weapon_range):
			enemy_array.append([distance, enemy])
	
	enemy_array.sort_custom(self, "sortEnemiesByDist")
	
	#Sort the closest enemies
	for sorted_enemy in enemy_array:
		if i < total:
			var a = player.get_transform().basis.z # Players's forward vector
			var b = (player.get_translation() - sorted_enemy[1].get_translation()).normalized() # Vector from player to enemy
		
			if acos(a.dot(b)) <= deg2rad(weapon_radius): # If the angle is less than or equal to the radius
				result_array.append(sorted_enemy[1])
				i += 1

	return result_array

func get_enemy_in_front(raycast, group):
	var enemy = raycast.get_collider()
	
	if raycast.is_colliding() and enemy.is_in_group(group):
		return enemy
	
	return null
	
func shoot_enemy(player, enemy, weapon_range, damage):
	if enemy == null:
		return
	else:
		var distance = player.translation.distance_to(enemy.translation)
		var space_state = player.get_world().direct_space_state
		var ray = space_state.intersect_ray(player.get_translation(), enemy.translation, [self])					
		
		if ray && ray.collider == enemy:
			distance = clamp(distance, 0, abs(weapon_range) * 1.5)
			enemy.hurt(current_weapon.damage - distance)

static func sortEnemiesByDist(a, b):
    if a[0] < b[0]:
        return true
    return false
