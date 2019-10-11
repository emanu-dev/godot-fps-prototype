extends StateMachine

onready var signals =  get_parent().get_node("Signals")

func _ready():
	add_state("idle")
	add_state("attack")
	add_state("pursuit")
	add_state("hurt")
	add_state("die")
	add_state("taunt")
	call_deferred("set_state", states.idle)	

func _state_logic(delta):
	if state == states.idle:
		parent.check_fov()
	if state == states.pursuit:
		parent.follow_target(parent.player)
	if state == states.hurt:
		parent.hurt
	if state == states.attack:
		parent.raycast.enabled = true
	else:
		parent.raycast.enabled = false

#Transition conditions
func _get_transition(delta):
	match state:
		states.idle:
			if parent.foundPlayer:
				if parent.is_randomized(50, 100):
					return states.taunt
				else:
					return states.pursuit
			if parent.dead:
				return states.die
			if parent.hurt == true:
				return states.hurt
		states.pursuit:
			if parent.dead:
				return states.die
			if parent.hurt == true:
				return states.hurt
			if parent._get_distance_from_target(parent.player) < parent.attack_range:
				return states.attack				
		states.hurt:
			if !parent.hurt:
				if parent.is_randomized(50, 100):
					return states.taunt
				else:
					return states.pursuit
			elif !parent.anim_player.is_playing():
				return states.hurt
			if parent.dead:
				return states.die				
		states.attack:
			if parent._get_distance_from_target(parent.player) > parent.attack_range:
				return states.pursuit
			if parent.hurt == true:
				return states.hurt
			if parent.dead:
				return states.die
		states.taunt:
			if !parent.anim_player.is_playing():
				return states.pursuit
			if parent.dead:
				return states.die
			if parent.hurt == true:
				return states.hurt
	return null
	
#Enter state conditions (mostly animations)
func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			parent.anim_player.play("idle")
		states.pursuit:
			parent.anim_player.play("walk")
		states.die:
			parent.anim_player.play("die")
			parent.audio_stream.play_die()
		states.hurt:
			parent.audio_stream.stop()
			parent.audio_stream.play_shot()
			parent.anim_player.play("hurt")
		states.attack:
			parent.anim_player.play("attack")
		states.taunt:
			parent.anim_player.play("taunt")
			parent.audio_stream.play_die()

func _exit_state(old_state, new_state):
	match old_state:
		states.idle:
			parent.audio_stream.play_found()
			

