extends CanvasLayer

@onready var ai = $"../AI"
@onready var ghost = $"../ghost"
@onready var l = $Line2D
@onready var map = $"../background"
@onready var pacman = $"../pacman"
@onready var utils = $"../utils"


func draw_obstacles():
	for ob_id in ai.obs_id:
		var debug = Label.new()
		var cell_pos = utils.cell_id_to_draw(ob_id)
		debug.set_position(Vector2(cell_pos.x - utils.CELL_OFFSET, cell_pos.y - utils.CELL_OFFSET)) 
		debug.text = "1"
		add_child(debug)
		
func _ready():
	pass
#	draw_obstacles()

func _process(delta):
	pass

func _on_ai_path_changed(path):
	pass
#	l.clear_points()
#	for p in ghost.path_to_target:
#		l.add_point(p)
