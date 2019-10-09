extends Node

onready var anim = $AnimationPlayer

func _process(delta):
	if anim.is_playing():
		$Sprite3D.visible = true
	else:
		$Sprite3D.visible = false

func burst(damage):
	randomize()
	var rand_x = rand_range(-100, 100)
	var rand_y = rand_range(-100, 100)
	anim.stop()
	$Sprite3D.offset = Vector2(rand_x, rand_y)
	$Sprite3D.pixel_size = clamp(damage*0.00005, 0.001, 0.0025)
	print($Sprite3D.pixel_size)
	anim.play("burst")