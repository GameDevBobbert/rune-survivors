extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_radius: float = 250.0
@export var spawn_interval: float = 2.0

@onready var timer: Timer = $SpawnTimer

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D

	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_spawn_timer_timeout)
	timer.start()

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()

func spawn_enemy() -> void:
	if enemy_scene == null:
		push_warning("Spawner mangler enemy_scene")
		return

	if player == null:
		return

	var enemy = enemy_scene.instantiate()
	var direction := Vector2.RIGHT.rotated(randf_range(0.0, TAU))
	var spawn_position := player.global_position + direction * spawn_radius

	enemy.global_position = spawn_position
	get_tree().current_scene.add_child(enemy)
	
	print("Spawned enemy!")
	print(enemy.health.current_health)
