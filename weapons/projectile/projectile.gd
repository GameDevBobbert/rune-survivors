class_name Projectile
extends Area2D

var velocity: Vector2
var damage: float

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func setup(dir: Vector2, speed: float, dmg: float) -> void:
	velocity = dir * speed
	damage = dmg

func _physics_process(delta: float) -> void:
	global_position += velocity * delta

func _on_area_entered(area: Area2D) -> void:
	#print("Projectile hit area: ", area.name)

	var target = area.get_parent()
	if target != null and target.is_in_group("enemy"):
		if target.has_method("take_damage"):
			target.take_damage(damage)
		queue_free()

func _on_body_entered(body: Node) -> void:
	#print("Projectile hit body: ", body.name)

	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()
