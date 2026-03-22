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
	print("PEW")
