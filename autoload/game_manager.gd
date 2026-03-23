extends Node

signal gold_changed(value)
signal kills_changed(value)
signal gold_added(amount, world_position)

var gold: int = 0
var kill_count: int = 0

func _ready() -> void:
	_emit_all_state()

func register_kill(enemy_position: Vector2, gold_amount: int) -> void:
	kill_count += 1
	kills_changed.emit(kill_count)

	add_gold(enemy_position, gold_amount)

func add_gold(world_position: Vector2, amount: int) -> void:
	gold += amount
	gold_changed.emit(gold)
	gold_added.emit(amount, world_position)

func spend_gold(amount: int) -> void:
	gold -= amount
	gold_changed.emit(gold)

func _emit_all_state() -> void:
	kills_changed.emit(kill_count)
	gold_changed.emit(gold)
