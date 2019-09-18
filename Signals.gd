extends Node

onready var parent = self.get_parent()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hurt":
		parent.hurt = false
