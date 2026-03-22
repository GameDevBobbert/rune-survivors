extends Node

@export var projectile_scene: PackedScene
@export var projectile_speed: float = 250.0
@export var projectile_damage: float = 2.0
@export var fire_rate: float = 1.0

@onready var timer: Timer = $FireTimer

func _ready() -> void:
	timer.wait_time = fire_rate
	timer.timeout.connect(_on_fire_timer_timeout)
	timer.start()

func _on_fire_timer_timeout() -> void:
	shoot()

func shoot() -> void:
	if projectile_scene == null:
		return

	var enemy = get_nearest_enemy()
	if enemy == null:
		print("No enemy found")
		return

	var projectile := projectile_scene.instantiate() as Projectile
	if projectile == null:
		return

	get_tree().current_scene.add_child(projectile)

	var owner = get_parent() as Node2D
	if owner == null:
		return

	projectile.global_position = owner.global_position

	var direction = (enemy.global_position - projectile.global_position).normalized()
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
