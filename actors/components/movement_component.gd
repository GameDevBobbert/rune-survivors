class_name MovementComponent
extends Node

@export var speed: float = 100.0

func physics_update(body: CharacterBody2D, direction: Vector2, delta: float) -> void:
	body.velocity = direction * speed
	body.move_and_slide()
	
