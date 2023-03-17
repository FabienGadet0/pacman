extends CharacterBody2D

var speed := 150

@export var path_to_target : Array
@onready var map = get_node("../background")
@onready var utils = get_node("../utils")
@onready var anim = $AnimationPlayer

var is_frightened := false
var is_dead := false
#var local_position = Vector2.ZERO
var current_direction := direction.NONE

enum direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	NONE
}

func _ready():
	pass

	
func set_direction() -> void:
	if(abs(velocity.x) > abs(velocity.y)):
		if(velocity.x > 1):
			current_direction = direction.RIGHT
		else:
			current_direction = direction.LEFT
	else:
		if(velocity.y > 1):
			current_direction = direction.DOWN
		else:
			current_direction = direction.UP

func set_animation() -> void:
	if is_frightened:
		anim.play("white_blue_mode")
	else:
		match current_direction:
			direction.UP:
				if is_dead:
					anim.play("dead_up")
				else:
					anim.play("move_up")
			direction.LEFT:
				if is_dead:
					anim.play("dead_left")
				else:
					anim.play("move_left")
			direction.RIGHT:
				if is_dead:
					anim.play("dead_right")
				else:
					anim.play("move_right")
			direction.DOWN:
				if is_dead:
					anim.play("dead_down")
				else:
					anim.play("move_down")

		
func flee() -> void:
	pass
	
func try_reset() -> void:
	print(utils.draw_to_cell_id(position))
	if(utils.draw_to_cell_id(position) == Vector2i(15,8)):
		is_dead = false
		is_frightened = false
		speed = 150
	
func target_reached(target: Vector2i) -> bool:
	return abs(target.x - position.x) <= utils.CELL_OFFSET and abs(target.y - position.y) <= utils.CELL_OFFSET
	
func go_straight_to_target() -> void:
	if(path_to_target):
		velocity = position.direction_to(path_to_target[0]) * speed
		if target_reached(path_to_target[0]):
			path_to_target.pop_front()
	else:
		velocity = Vector2.ZERO

func _handle_collision() -> void:
	var col = get_last_slide_collision()
	if(col and col.get_collider().is_in_group("PacMan")):
		if(is_frightened):
			is_dead = true
			is_frightened = false


func ai() -> void:
	if is_dead:
		speed = 300
		try_reset()
	
	if is_frightened and !is_dead:
		flee()
	else:
		go_straight_to_target()

func _process(_delta) -> void:
	_handle_collision()
	ai()
	set_direction()
	set_animation()

func _physics_process(delta) -> void:
	move_and_slide()

func set_target_path(path) -> void:
	path_to_target.clear()
	path_to_target = path

func _on_world_power_up(enabled):
	is_frightened = enabled
