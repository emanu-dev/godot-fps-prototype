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

#Transition conditions
func _get_transition(delta):
	match state:
		states.idle:
			if parent.foundPlayer:
				return states.pursuit
			if parent.dead:
				return states.die
		states.pursuit:
			if parent.dead:
				return states.die
			pass	
	return null
	
#Enter state conditions (mostly animations)
func _enter_state(new_state, old_state):
	match state:
		states.die:
			pass	
	pass

func _exit_state(old_state, new_state):
	match state:
		states.idle:
			pass	
	pass
