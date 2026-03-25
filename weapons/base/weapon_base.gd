class_name WeaponBase
extends Node2D

@export var damage: float = 1.0
@export var attack_speed: float = 1.0

@onready var fire_timer: Timer = $FireTimer

func _ready() -> void:
	fire_timer.wait_time = 1.0 / attack_speed
	fire_timer.timeout.connect(_on_fire_timer_timeout)
	fire_timer.start()

func _on_fire_timer_timeout() -> void:
	attack()

func attack() -> void:
	pass

func get_nearest_enemy() -> Enemy:
	var enemies = get_tree().get_nodes_in_group("enemy")
	print("Enemies found: ", enemies.size())

	var nearest: Enemy = null
	var nearest_distance := INF

	for e in enemies:
		if e is Enemy:
			var dist = global_position.distance_to(e.global_position)
			if dist < nearest_distance:
				nearest_distance = dist
				nearest = e

	return nearest
