class_name CombatComponent
extends Node

signal damage_dealt

@export var damage: int = 10

func process_update(owner: Node, delta: float) -> void:
	pass

func deal_damage(target: Node) -> void:
	print(target.name, " took damage")

	if target.has_method("take_damage"):
		target.take_damage(damage)
		damage_dealt.emit()
