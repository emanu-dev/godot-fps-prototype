extends MarginContainer

onready var timer
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = get_tree().create_timer(1)

func _process(delta):
	yield(timer, "timeout")
	if self.visible == true:
		self.visible = false
	else:
		self.visible = true
