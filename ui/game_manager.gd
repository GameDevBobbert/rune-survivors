extends Node

@export var kills_per_upgrade: int = 5
@export var damage_increase_per_upgrade: int = 1

var projectile_component: Node
var kill_count: int = 0
var player: Player

@onready var kill_label: Label = $"../CanvasLayer/KillLabel"
@onready var damage_label: Label = $"../CanvasLayer/DamageLabel"
@onready var upgrade_label: Label = $"../CanvasLayer/UpgradeLabel"

func _ready() -> void:
	add_to_group("game_manager")

	player = get_tree().get_first_node_in_group("player") as Player
	if player != null:
		projectile_component = player.get_node("ProjectileComponent")
	
	update_ui()

func register_kill() -> void:
	kill_count += 1
	print("Kills: ", kill_count)

	if kill_count % kills_per_upgrade == 0:
		apply_damage_upgrade()

	update_ui()

func apply_damage_upgrade() -> void:
	if projectile_component == null:
		return

	projectile_component.projectile_damage += damage_increase_per_upgrade
	print("Damage upgraded to: ", projectile_component.projectile_damage)

func update_ui() -> void:
	if kill_label:
		kill_label.text = "Kills: %d" % kill_count

	if damage_label and projectile_component:
		damage_label.text = "Damage: %d" % projectile_component.projectile_damage

	if upgrade_label:
		var remainder = kill_count % kills_per_upgrade
		var kills_until_upgrade = kills_per_upgrade - remainder

		if kills_until_upgrade == 0:
			kills_until_upgrade = kills_per_upgrade

		upgrade_label.text = "Next upgrade: %d" % kills_until_upgrade
