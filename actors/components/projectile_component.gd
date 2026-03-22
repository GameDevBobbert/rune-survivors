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
	#print("PEW")
	
	if projectile_scene == null:
		print("No projectile_scene assigned")
		return

	var enemy = get_tree().get_first_node_in_group("enemy")
	if enemy == null:
		print("No enemy found")
		return
		
	var projectile := projectile_scene.instantiate() as Projectile
	if projectile == null:
		print("Could not cast instantiated scene to Projectile")
		return
		
	get_tree().current_scene.add_child(projectile)

	var owner = get_parent() as Node2D
	if owner == null:
		print("Owner is not Node2D")
		return

	projectile.global_position = owner.global_position
	#print("Projectile spawned at: ", projectile.global_position)

	var direction = (enemy.global_position - projectile.global_position).normalized()
	projectile.setup(direction, projectile_speed, projectile_damage)
