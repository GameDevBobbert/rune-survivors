class_name Player
extends CharacterBody2D

@onready var movement: MovementComponent = $MovementComponent
@onready var health: HealthComponent = $HealthComponent
@onready var combat: CombatComponent = $CombatComponent

func _ready() -> void:
	add_to_group("player")
	health.died.connect(_on_died)

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	movement.physics_update(self, direction, delta)

func _process(delta: float) -> void:
	combat.process_update(self, delta)

func take_damage(amount: int) -> void:
	print("Player took damage:", amount)
	health.take_damage(amount)
	print("Player current health: ", health.current_health)

func _on_died() -> void:
	queue_free()
