extends TileMap

@export var TILE_SCENES := {
	"food": preload("res://scenes/food.tscn"),
	"powerup": preload("res://scenes/powerup.tscn")
}

@onready var utils = $"../utils"
@onready var world = $"../../World"

func _ready():
	_replace_tiles_with_scenes()

func _replace_tiles_with_scenes(scene_dictionary: Dictionary = TILE_SCENES):
	for tile_pos in get_used_cells(0):
		var tile_type = get_cell_tile_data(0,tile_pos).get_custom_data("type")
		
		if scene_dictionary.has(tile_type):
			var object_scene = scene_dictionary[tile_type]
			_replace_tile_with_object(tile_pos, object_scene)

func _replace_tile_with_object(tile_pos: Vector2, object_scene: PackedScene, parent: Node = get_tree().current_scene):
	# Clear the cell in TileMap
	set_cell(0,tile_pos, -1, Vector2(7,1))
	
	# Spawn the object
	if object_scene:
		var obj = object_scene.instantiate()
		var ob_pos = utils.cell_id_to_draw(tile_pos)# + utils.CELL_OFFSET
		obj.connect("collide_point",world.handle_collisions) # Connect the signal on collision
		parent.add_child.call_deferred(obj)
		obj.global_position = ob_pos


func _on_warp_left_body_entered(body):
	if(body.name == "pacman" or body.name == "ghost"):
		body.global_position = Vector2(1890,1050/2)

#
func _on_warp_right_body_entered(body):
	if(body.name == "pacman" or body.name == "ghost"):
		body.global_position = Vector2(32,1050/2)
