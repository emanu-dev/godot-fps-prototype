extends Label

# Declare member variables here. Examples:
# var b = "text"

var alpha = .8

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	modulate.a += alpha * delta
	
	if modulate.a > 1 || modulate.a < 0:
		alpha = -alpha

	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://Scenes/Levels/World.tscn")