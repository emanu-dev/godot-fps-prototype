extends Node

onready var parent = self.get_parent()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "hurt":
		parent.hurt = false


func _on_Area_body_entered(body):
	if body == parent.player:
		parent.get_node("Area/CollisionShape").disabled = true;
		parent.foundPlayer = true
