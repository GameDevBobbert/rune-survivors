extends CanvasLayer

@export var inventory_scene: PackedScene
var inventory_ui: Control = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		toggle_inventory()

func toggle_inventory() -> void:
	if inventory_ui == null:
		inventory_ui = inventory_scene.instantiate() as Control
		add_child(inventory_ui)
		print("Inventory opened")
		GameManager.spend_gold(1)
		get_tree().paused = true
	else:
		inventory_ui.queue_free()
		print("Inventory closed")

		inventory_ui = null
		get_tree().paused = false
