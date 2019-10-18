extends MarginContainer

# Declare member variables here. Examples:
# var b = "text"
var start_label
var credits
var controls
var alpha = .8

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	start_label = get_node("MainScreen/VBoxContainer/MarginContainer/PressStartLabel")
	controls = get_node("Controls")
	credits = get_node("Credits")

func _process(delta):
	start_label.modulate.a += alpha * delta
	
	if start_label.modulate.a > 1 || start_label.modulate.a < 0:
		alpha = -alpha

	if Input.is_action_just_pressed("ui_accept"):
		if controls.visible == false and credits.visible == false:
			get_node("MainScreen").visible = false
			credits.visible = false
			controls.visible = true
		elif controls.visible == true:
			get_node("MainScreen").visible = false
			controls.visible = false
			credits.visible = true
		elif credits.visible == true:	
			get_tree().change_scene("res://Scenes/Levels/World.tscn")
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()