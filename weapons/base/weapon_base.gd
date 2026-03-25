extends Node2D

@export var projectile_scene: PackedScene
@export var projectile_speed: float = 250.0
@export var projectile_damage: float = 2.0
@export var attack_speed: float = 1.0

@onready var nozzle_point: Marker2D = $NozzlePoint
@onready var fire_timer: Timer = $FireTimer
@onready var aim_point: Marker2D = $AimPoint

func _ready() -> void:
	fire_timer.wait_time = attack_speed_calc(attack_speed)
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	fire_timer.start()
	
func _process(_delta: float) -> void:
	update_rotation()

func _on_fire_timer_timeout() -> void:
	shoot()

func shoot() -> void:
	if projectile_scene == null:
		return

	var enemy = get_nearest_enemy()
	if enemy == null:
		return

	var nozzle = get_nozzle_point()
	if nozzle == null:
		return

	var spawn_position = nozzle.global_position

	var projectile := projectile_scene.instantiate()
	if projectile == null:
		return

	get_tree().current_scene.add_child(projectile)
	projectile.global_position = spawn_position

	var target_position = target_enemy(enemy)
	var direction = (target_position - spawn_position).normalized()

	if projectile.has_method("setup"):
		projectile.setup(direction, projectile_speed, projectile_damage)

func get_nearest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemy")
	var nearest: Node2D = null
	var nearest_distance := INF

	for node in enemies:
		var enemy := node as Node2D
		if enemy == null:
			continue

		var dist = global_position.distance_to(enemy.global_position)
		if dist < nearest_distance:
			nearest_distance = dist
			nearest = enemy

	return nearest

func attack_speed_calc(value: float) -> float:
	if value <= 0.0:
		return 1.0

	return 1.0 / value

func update_rotation() -> void:
	var enemy = get_nearest_enemy()
	if enemy == null:
		return

	var target_position = target_enemy(enemy)
	var dir = target_position - global_position
	
	rotation = dir.angle()


func get_nozzle_point() -> Marker2D:
	return nozzle_point

func target_enemy(enemy: Enemy) -> Vector2:
	if enemy.has_node("AimPoint"):
		var aim = enemy.get_node("AimPoint") as Marker2D
		return aim.global_position

	return enemy.global_position
