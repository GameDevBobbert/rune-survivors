extends Node

@export var kills_per_upgrade: int = 5
@export var damage_increase_per_upgrade: int = 1
var gold_popup_scene: PackedScene = preload("res://ui/gold_popup/gold_popup.tscn")

var projectile_component: Node
var kill_count: int = 0
var player: Player
var gold: int = 0

var kill_label: Label
var damage_label: Label
var upgrade_label: Label
var gold_label: Label

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Player
	if player != null:
		projectile_component = player.get_node("ProjectileComponent")

	var main := get_tree().current_scene
	if main != null:
		kill_label = main.get_node("GameStats/KillLabel")
		damage_label = main.get_node("GameStats/DamageLabel")
		upgrade_label = main.get_node("GameStats/UpgradeLabel")
		gold_label = main.get_node("GameStats/GoldLabel")

	update_ui()

func register_kill(enemy_position: Vector2, gold_amount: int) -> void:
	kill_count += 1
	add_gold(enemy_position, gold_amount)
	
	print("REGISTER_KILL CALLED")
	print("Kills: ", kill_count)
	update_ui()

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

	if gold_label:
		gold_label.text = "Gold: %d" % gold

	if damage_label and projectile_component:
		damage_label.text = "Damage: %d" % projectile_component.projectile_damage

	if upgrade_label:
		var remainder = kill_count % kills_per_upgrade
		var kills_until_upgrade = kills_per_upgrade - remainder

		if kills_until_upgrade == 0:
			kills_until_upgrade = kills_per_upgrade

		upgrade_label.text = "Next upgrade: %d" % kills_until_upgrade


func add_gold(spawn_position: Vector2, amount: int) -> void:
	gold += amount

	if gold_popup_scene != null:
		var popup := gold_popup_scene.instantiate() as Node2D
		get_tree().current_scene.add_child(popup)
		popup.global_position = spawn_position

		# hvis du vil vise +X i popup:
		if popup.has_method("set_amount"):
			popup.set_amount(amount)
			
func spend_gold(amount: int) -> void:
	gold -= amount
	update_ui()
