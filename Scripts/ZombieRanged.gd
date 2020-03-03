extends GenericEnemy

const RANGE = 5
const CLOSE_ZONE = 3

onready var projectileScene = preload("res://Scenes/Projectile.tscn")
onready var projectileTimer = $ProjectileTimer

var projectile = null
var attacking = false


func attack_ranged(player):
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
	
	projectileTimer.set_one_shot(true)
	
	if !$SlopeRayCast.is_colliding() && !dead:
		move_and_collide(Vector3(0, -1, 0))
	
	vec_to_target = vec_to_target.normalized()
	look_at(target.translation, Vector3(0, 1, 0))	
	
	
	if distance > RANGE && !attacking:
		move_and_slide(vec_to_target * MOVE_SPEED * get_physics_process_delta_time (), Vector3 (0, 1, 0) )
	elif distance < CLOSE_ZONE && !attacking:
		move_and_slide(Vector3(vec_to_target.x, 0, vec_to_target.z) * -MOVE_SPEED * get_physics_process_delta_time (), Vector3 (0, 1, 0) )
	else:
		if projectileTimer.is_stopped():
			projectileTimer.start(2)
			if projectile == null:
				attack_ranged(player)

func kill():
	dead = true
	set_projectile(null)
	attacking = false
	$CollisionShape.disabled = true
	$Area.monitoring = false
	remove_from_group("zombies")

func set_projectile(p):
	projectile = p
