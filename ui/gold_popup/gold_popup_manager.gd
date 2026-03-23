extends Node

var gold_popup_scene: PackedScene = preload("res://ui/gold_popup/gold_popup.tscn")

func _ready() -> void:
	GameManager.gold_added.connect(_on_gold_added)

func _on_gold_added(amount: int, world_position: Vector2) -> void:
	var popup := gold_popup_scene.instantiate() as Node2D
	get_tree().current_scene.add_child(popup)
	popup.global_position = world_position
	popup.set_amount(amount)
