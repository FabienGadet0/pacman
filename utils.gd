extends Node2D

@onready var map = $"../background"
@onready var CELL_OFFSET = map.tile_set.tile_size.x / 2 # Offset that is half a cell size, it allows to center stuff easily

func cell_id_to_draw(cell_id: Vector2) -> Vector2:
	return map.to_global(map.map_to_local(cell_id))

# Get the global position (example : (450,450)) and return the cell id.
func draw_to_cell_id(pos: Vector2i):
	return map.local_to_map(map.to_local(pos))


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
