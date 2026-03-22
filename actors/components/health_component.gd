class_name HealthComponent
extends Node

signal died
signal health_changed(current_health: int)

@export var max_health: int = 10
var current_health: int

func _ready() -> void:
	current_health = max_health
	health_changed.emit(current_health)

func take_damage(amount: int) -> void:
	current_health -= amount
	current_health = clamp(current_health, 0, max_health)
	health_changed.emit(current_health)

	if current_health <= 0:
		died.emit()
