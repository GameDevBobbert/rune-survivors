extends Control

@onready var kill_label: Label = $KillLabel
@onready var damage_label: Label = $DamageLabel
@onready var upgrade_label: Label = $UpgradeLabel
@onready var gold_label: Label = $GoldLabel

func _ready() -> void:
	GameManager.kills_changed.connect(_on_kills_changed)
	GameManager.gold_changed.connect(_on_gold_changed)

	var upgrade_system := get_tree().get_first_node_in_group("upgrade_system")
	if upgrade_system != null:
		upgrade_system.damage_changed.connect(_on_damage_changed)
		upgrade_system.upgrade_progress_changed.connect(_on_upgrade_progress_changed)

func _on_kills_changed(value: int) -> void:
	kill_label.text = "Kills: %d" % value

func _on_gold_changed(value: int) -> void:
	gold_label.text = "Gold: %d" % value

func _on_damage_changed(value: int) -> void:
	damage_label.text = "Damage: %d" % value

func _on_upgrade_progress_changed(value: int) -> void:
	upgrade_label.text = "Next upgrade: %d" % value
