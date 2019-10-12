extends GenericEnemy

var dmg_bank = 0

func _ready():
	add_to_group("zombies")
	$DirectionPlaceholder.visible = false
	raycast.cast_to = Vector3(0, 0, -attack_range)
	
func hurt(dmg):
	$Blood.burst(dmg)
	if health - dmg <= 0:
		health = 0
		kill()
	else:
		health -= dmg
		dmg_bank += dmg
		if dmg_bank > 100:
			dmg_bank = 0
			hurt = true