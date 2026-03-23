extends Node

signal damage_changed(value)
signal upgrade_progress_changed(value)

@export var kills_per_upgrade: int = 5
@export var damage_increase_per_upgrade: int = 1

var player: Player
var projectile_component: Node

func _ready() -> void:
	GameManager.kills_changed.connect(_on_kills_changed)

	player = get_tree().get_first_node_in_group("player") as Player
	if player != null:
		projectile_component = player.get_node("ProjectileComponent")

	_emit_current_state()

func _on_kills_changed(current_kills: int) -> void:
	_emit_upgrade_progress(current_kills)

	if current_kills > 0 and current_kills % kills_per_upgrade == 0:
		apply_damage_upgrade()

func apply_damage_upgrade() -> void:
	if projectile_component == null:
		return

	projectile_component.projectile_damage += damage_increase_per_upgrade
	damage_changed.emit(projectile_component.projectile_damage)

func _emit_upgrade_progress(current_kills: int) -> void:
	var remainder = current_kills % kills_per_upgrade
	var kills_until_upgrade = kills_per_upgrade - remainder

	if kills_until_upgrade == 0:
		kills_until_upgrade = kills_per_upgrade

	upgrade_progress_changed.emit(kills_until_upgrade)

func _emit_current_state() -> void:
	if projectile_component != null:
		damage_changed.emit(projectile_component.projectile_damage)

	_emit_upgrade_progress(GameManager.kill_count)
