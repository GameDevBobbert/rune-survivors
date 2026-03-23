class_name Enemy
extends CharacterBody2D

@onready var movement: MovementComponent = $MovementComponent
@onready var health: HealthComponent = $HealthComponent
@onready var combat: CombatComponent = $CombatComponent
@onready var hitbox: Area2D = $Hitbox
@onready var aim_point: Marker2D = $AimPoint
@onready var damage_timer: Timer = $DamageTimer

@export var stop_distance: float = 10.0
@export var gold_value: int = 1

var player: Node2D
var player_in_hitbox: Node = null

func _ready() -> void:
	health.died.connect(_on_died)

	hitbox.body_entered.connect(_on_hitbox_body_entered)
	hitbox.body_exited.connect(_on_hitbox_body_exited)
	damage_timer.timeout.connect(_on_damage_timer_timeout)

	player = get_tree().get_first_node_in_group("player") as Node2D

func _physics_process(delta: float) -> void:
	if player == null:
		return

	var to_player := player.global_position - global_position
	var distance := to_player.length()

	var direction := Vector2.ZERO
	if distance > stop_distance:
		direction = to_player.normalized()

	movement.physics_update(self, direction, delta)

func _process(delta: float) -> void:
	combat.process_update(self, delta)

func take_damage(amount: int) -> void:
	health.take_damage(amount)
	print("Enemy took damage: ", amount)

func _on_hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_hitbox = body
		combat.deal_damage(body)
		damage_timer.start()

func _on_hitbox_body_exited(body: Node) -> void:
	if body == player_in_hitbox:
		player_in_hitbox = null
		damage_timer.stop()

func _on_damage_timer_timeout() -> void:
	if player_in_hitbox != null and is_instance_valid(player_in_hitbox):
		combat.deal_damage(player_in_hitbox)

func _on_died(dead_owner: Node) -> void:
	GameManager.register_kill(global_position, gold_value)
	queue_free()
