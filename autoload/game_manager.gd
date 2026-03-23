extends Node

signal gold_changed(value)
signal kills_changed(value)
signal damage_changed(value)
signal upgrade_progress_changed(value)

@export var kills_per_upgrade: int = 5
@export var damage_increase_per_upgrade: int = 1
var gold_popup_scene: PackedScene = preload("res://ui/gold_popup/gold_popup.tscn")

var projectile_component: Node
var kill_count: int = 0
var player: Player
var gold: int = 0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Player
	if player != null:
		projectile_component = player.get_node("ProjectileComponent")

	_emit_all_state()

func register_kill(enemy_position: Vector2, gold_amount: int) -> void:
	kill_count += 1
	kills_changed.emit(kill_count)

	_emit_upgrade_progress()
	add_gold(enemy_position, gold_amount)

	if kill_count % kills_per_upgrade == 0:
		apply_damage_upgrade()

func apply_damage_upgrade() -> void:
	if projectile_component == null:
		return

	projectile_component.projectile_damage += damage_increase_per_upgrade
	damage_changed.emit(projectile_component.projectile_damage)
	_emit_upgrade_progress()

func add_gold(spawn_position: Vector2, amount: int) -> void:
	gold += amount
	gold_changed.emit(gold)

	if gold_popup_scene != null:
		var popup := gold_popup_scene.instantiate() as Node2D
		get_tree().current_scene.add_child(popup)
		popup.global_position = spawn_position

		if popup.has_method("set_amount"):
			popup.set_amount(amount)

func spend_gold(amount: int) -> void:
	gold -= amount
	gold_changed.emit(gold)

func _emit_upgrade_progress() -> void:
	var remainder = kill_count % kills_per_upgrade
	var kills_until_upgrade = kills_per_upgrade - remainder

	if kills_until_upgrade == 0:
		kills_until_upgrade = kills_per_upgrade

	upgrade_progress_changed.emit(kills_until_upgrade)

func _emit_all_state() -> void:
	kills_changed.emit(kill_count)
	gold_changed.emit(gold)

	if projectile_component != null:
		damage_changed.emit(projectile_component.projectile_damage)

	_emit_upgrade_progress()
