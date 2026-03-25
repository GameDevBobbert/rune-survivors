class_name Projectile
extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 0.0
var damage: float = 0.0

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func setup(new_direction: Vector2, new_speed: float, new_damage: float) -> void:
	direction = new_direction
	speed = new_speed
	damage = new_damage
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	print("Bullet hit area: ", area.name)

	if area.name == "Hitbox":
		var enemy = area.get_parent()
		if enemy != null and enemy.has_method("take_damage"):
			enemy.take_damage(damage)
		queue_free()
