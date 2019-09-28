extends StateMachine

onready var signals =  get_parent().get_node("Signals")

func _ready():
	add_state("idle")
	add_state("attack")
	add_state("pursuit")
	add_state("hurt")
	add_state("die")
	call_deferred("set_state", states.idle)	

func _state_logic(delta):
	if state == states.idle:
		parent.check_fov()
	if state == states.pursuit:
		parent.follow_target(parent.player)
	if state == states.hurt:
		parent.hurt

#Transition conditions
func _get_transition(delta):
	match state:
		states.idle:
			if parent.foundPlayer:
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
		states.hurt:
			if !parent.hurt:
				return states.pursuit
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
			parent.audio_stream.play_shot()
			parent.anim_player.play("hurt")

func _exit_state(old_state, new_state):
	match old_state:
		states.idle:
			parent.audio_stream.play_found()
