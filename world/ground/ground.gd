extends TileMapLayer

@export var player_path: NodePath
@export var chunk_size: int = 16
@export var render_distance: int = 2

@export var grass_source_id: int = 0
@export var grass_atlas_coords: Vector2i = Vector2i(0, 0)

@export var dirt_source_id: int = 1
@export var dirt_atlas_coords: Vector2i = Vector2i(0, 0)

@export var dirt_chance: float = 0.1

var player: Node2D
var generated_chunks: Dictionary = {}

func _ready() -> void:
	player = get_node(player_path)

func _process(_delta: float) -> void:
	update_chunks()

func update_chunks() -> void:
	var player_cell := local_to_map(player.global_position)
	var player_chunk := Vector2i(
		floori(float(player_cell.x) / chunk_size),
		floori(float(player_cell.y) / chunk_size)
	)

	for y in range(player_chunk.y - render_distance, player_chunk.y + render_distance + 1):
		for x in range(player_chunk.x - render_distance, player_chunk.x + render_distance + 1):
			var chunk_pos := Vector2i(x, y)

			if not generated_chunks.has(chunk_pos):
				generate_chunk(chunk_pos)
				generated_chunks[chunk_pos] = true

func generate_chunk(chunk_pos: Vector2i) -> void:
	var start_x := chunk_pos.x * chunk_size
	var start_y := chunk_pos.y * chunk_size

	for y in range(start_y, start_y + chunk_size):
		for x in range(start_x, start_x + chunk_size):
			var cell := Vector2i(x, y)

			if randf() < dirt_chance:
				set_cell(cell, dirt_source_id, dirt_atlas_coords)
			else:
				set_cell(cell, grass_source_id, grass_atlas_coords)
