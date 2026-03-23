extends Node

@export var projectile_scene: PackedScene
@export var projectile_speed: float = 250.0
@export var projectile_damage: float = 2.0
@export var attack_speed: float = 1.0

@onready var timer: Timer = $FireTimer

func _ready() -> void:
	timer.wait_time = attack_speed_calc(attack_speed)
	timer.timeout.connect(_on_fire_timer_timeout)
	timer.start()
	
	print("Attack speed: ", attack_speed)
	print("Timer wait_time: ", attack_speed_calc(attack_speed))

func _on_fire_timer_timeout() -> void:
	shoot()

func shoot() -> void:
	if projectile_scene == null:
		return

	var enemy = get_nearest_enemy()
	if enemy == null:
		return

	var projectile := projectile_scene.instantiate() as Projectile
	if projectile == null:
		return

	var owner = get_parent() as Node2D
	if owner == null:
		return

	get_tree().current_scene.add_child(projectile)
	projectile.global_position = owner.global_position

	var target_position = enemy.aim_point.global_position
	var direction = (target_position - projectile.global_position).normalized()

	projectile.setup(direction, projectile_speed, projectile_damage)

func get_nearest_enemy() -> Enemy:
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest_enemy: Enemy = null
	var nearest_distance := INF

	var owner = get_parent() as Node2D
	if owner == null:
		return null

	for node in enemies:
		var enemy := node as Enemy
		if enemy == null:
			continue

		var distance = owner.global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy

	return nearest_enemy

func attack_speed_calc(attack_speed: float) -> float:
	if attack_speed <= 0.0:
		return 1.0

	return 1.0 / attack_speed
