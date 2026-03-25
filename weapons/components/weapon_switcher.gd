extends Node

@export var weapon_1_scene: PackedScene
@export var weapon_2_scene: PackedScene

@onready var weapon_anchor: Node2D = $"../WeaponAnchor"

var current_weapon: Node2D = null

func _ready() -> void:
	equip_weapon(weapon_1_scene)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("weapon_1"):
		print("Weapon 1 selected")
		equip_weapon(weapon_1_scene)

	if Input.is_action_just_pressed("weapon_2"):
		print("Weapon 2 selected")
		equip_weapon(weapon_2_scene)
		
func equip_weapon(weapon_scene: PackedScene) -> void:
	if weapon_scene == null:
		return

	if current_weapon != null:
		current_weapon.queue_free()
		current_weapon = null

	var new_weapon := weapon_scene.instantiate() as Node2D
	if new_weapon == null:
		return

	weapon_anchor.add_child(new_weapon)
	new_weapon.position = Vector2.ZERO
	current_weapon = new_weapon
