extends Node

onready var anim = $AnimationPlayer

func _process(delta):
	if anim.is_playing():
		$Sprite3D.visible = true
	else:
		$Sprite3D.visible = false

func burst():
	anim.play("burst")