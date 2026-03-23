class_name Player
extends CharacterBody2D

@onready var movement: MovementComponent = $MovementComponent
@onready var health: HealthComponent = $HealthComponent
@onready var combat: CombatComponent = $CombatComponent
@onready var animated_sprite := $AnimatedSprite2D

func _ready() -> void:
	add_to_group("player")
	health.died.connect(_on_died)
	
func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction.length() > 0:
		if abs(direction.x) > abs(direction.y):
			# Horizontal movement
			if direction.x > 0:
				animated_sprite.play("right")
			else:
				animated_sprite.play("left")
		else:
			# Vertical movement
			if direction.y > 0:
				animated_sprite.play("down")
			else:
				animated_sprite.play("up")

	movement.physics_update(self, direction, delta)

func _process(delta: float) -> void:
	combat.process_update(self, delta)

func take_damage(amount: int) -> void:
	print("Player took damage:", amount)
	health.take_damage(amount)
	print("Player current health: ", health.current_health)

func _on_died() -> void:
	queue_free()
