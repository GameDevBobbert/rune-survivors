class_name MeleeWeapon
extends WeaponBase

func attack() -> void:
	var enemy := _get_enemy_in_range()
	if enemy == null:
		return
	
	_hit(enemy)

func _get_enemy_in_range() -> Enemy:
	var enemies := get_tree().get_nodes_in_group("enemies")
	
	var closest: Enemy = null
	var closest_dist := attack_range
	
	for node in enemies:
		var enemy := node as Enemy
		if enemy == null:
			continue
		
		var dist := global_position.distance_to(enemy.global_position)
		if dist <= closest_dist:
			closest_dist = dist
			closest = enemy
	
	return closest

func _hit(enemy: Enemy) -> void:
	if enemy.health != null:
		enemy.health.take_damage(damage)
