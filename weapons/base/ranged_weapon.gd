class_name RangedWeapon
extends WeaponBase

@export var projectile_scene: PackedScene
@export var projectile_speed: float = 250.0

@onready var nozzle_point: Marker2D = $NozzlePoint


func _process(_delta: float) -> void:
	var enemy := get_nearest_enemy()
	if enemy == null:
		return

	var target_pos := _get_target_position(enemy)
	look_at(target_pos)

func attack() -> void:
	shoot()

func shoot() -> void:
	print("shoot called")

	if projectile_scene == null:
		print("projectile_scene is null")
		return
	
	var enemy := get_nearest_enemy()
	if enemy == null:
		print("enemy is null")
		return
	
	var spawn_pos := nozzle_point.global_position
	var target_pos := _get_target_position(enemy)
	var dir := (target_pos - spawn_pos).normalized()

	print("spawn_pos: ", spawn_pos)
	print("target_pos: ", target_pos)
	print("dir: ", dir)

	var projectile = projectile_scene.instantiate()
	if projectile == null:
		print("projectile instantiate failed")
		return

	print("projectile instance created: ", projectile)

	get_tree().current_scene.add_child(projectile)
	projectile.global_position = spawn_pos

	if projectile.has_method("setup"):
		projectile.setup(dir, projectile_speed, damage)
		print("setup called")
	else:
		print("projectile has no setup()")

func _get_target_position(enemy: Enemy) -> Vector2:
	if enemy.aim_point != null:
		return enemy.aim_point.global_position
	return enemy.global_position
