extends GenericEnemy

const RANGE = 5
const CLOSE_ZONE = 3

onready var projectileScene = preload("res://Scenes/Projectile.tscn")
var projectile = null
var attacking = false

func attack_ranged(player):
	if projectile != null:
		return
	else:
		attacking = true
		audio_stream.play_found()
		projectile = projectileScene.instance()
		projectile.set_player(player)
		projectile.set_parent(self)
		get_parent().add_child(projectile)
		yield(anim_player, "animation_finished")
		attacking = false		
	
func follow_target (target):
	var vec_to_target = target.translation - translation
	var distance = _get_distance_from_target(player)
	
	if (is_on_floor()):
		has_contact = true
	else:
		if !$SlopeRayCast.is_colliding():
			has_contact = false
			
	if (has_contact and !is_on_floor()):
		move_and_collide(Vector3(0, -1, 0))

	vec_to_target = vec_to_target.normalized()
	look_at(target.translation, Vector3(0, 1, 0))
	
	if distance > RANGE:
		move_and_slide(vec_to_target * MOVE_SPEED * get_physics_process_delta_time (), Vector3 (0, 1, 0) )
	elif distance < CLOSE_ZONE:
		move_and_slide(vec_to_target * -MOVE_SPEED * get_physics_process_delta_time (), Vector3 (0, 1, 0) )
	else:
		if is_randomized(50, 100):
			attack_ranged(player)
		else:
			move_and_slide(vec_to_target * -MOVE_SPEED * get_physics_process_delta_time (), Vector3 (0, 1, 0) )

func set_projectile(p):
	projectile = p