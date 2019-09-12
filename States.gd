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
	pass
	# print (state)

#Transition conditions
func _get_transition(delta):
	match state:
		states.idle:
			pass	
	return null
	
#Enter state conditions (mostly animations)
func _enter_state(new_state, old_state):
	match state:
		states.idle:
			pass	
	pass

func _exit_state(old_state, new_state):
	match state:
		states.idle:
			pass	
	pass
