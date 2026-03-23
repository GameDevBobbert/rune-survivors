extends Node2D

@export var rise_speed: float = 30.0
@export var lifetime: float = 0.8

@onready var label: Label = $Label

var time_passed: float = 0.0

func _process(delta: float) -> void:
	time_passed += delta
	position.y -= rise_speed * delta

	if time_passed >= lifetime:
		queue_free()

func set_amount(amount: int) -> void:
	label.text = "+%d Gold" % amount
