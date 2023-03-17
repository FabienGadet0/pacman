extends Node2D

signal path_changed(path)

#@onready var nav_agent = $NavigationAgent2D
@onready var pacman = get_node("../pacman")
@onready var map = get_node("../background")
@onready var ghost = get_node("../ghost")
@onready var utils = get_node("../utils")

@onready var astar_grid :AStarGrid2D

var window_size : Vector2i = DisplayServer.window_get_size()
var map_scale : int = 4
var clicked_cell = Vector2.ZERO

func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.diagonal_mode = 1 # disable diagonals
	astar_grid.size = map.get_used_rect().size
	astar_grid.cell_size = map.tile_set.tile_size
	astar_grid.update()
	set_obstacles()

func set_obstacles():
	var obstacles = []
	for y in range(astar_grid.size.y):
		for x in range(astar_grid.size.x):
			if map.get_cell_source_id(0, Vector2(x,y)) >= 0:
				var cell = map.get_cell_tile_data(0, Vector2(x,y))
				if !(map.get_cell_tile_data(0, Vector2(x,y)).get_navigation_polygon(0)):
					astar_grid.set_point_solid(Vector2i(x, y),true)
	return obstacles
	
func _physics_process(delta):
	pass


func get_cell_id(pos: Vector2i):
	return map.local_to_map(map.to_local(pos))

func _process(delta):
	if astar_grid.is_dirty():
		astar_grid.update()

func create_path_to(from,target) -> void:
		var path_id = astar_grid.get_id_path(from,target)
		var path: Array
		
		for point in path_id:
			var p = utils.cell_id_to_draw(point)
			path.append(Vector2(p.x - utils.CELL_OFFSET, p.y - utils.CELL_OFFSET))

		path.pop_front() #delete first because it's too close to ghost
		get_tree().call_group("Enemy","set_target_path",path)
		emit_signal("path_changed", path)

func _on_navigation_timer_timeout():
	if(pacman and ghost): #wait for pacman and ghost instances to be loaded
		var ghost_pos = utils.draw_to_cell_id(ghost.position)
		if(ghost.is_dead):
			create_path_to(ghost_pos,Vector2(15,8))
		else:
			create_path_to(ghost_pos,utils.draw_to_cell_id(pacman.position))
