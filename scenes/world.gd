extends Node2D

signal power_up(enabled)

@export var points : int = 0
@onready var score = $HUD/score
#@onready var map = get_node("../background")
#@onready var ghost = get_node("../ghost")
#@onready var utils = get_node("../utils")

func game_over() -> void:
	$sounds/game_over.play()
	$HUD/gameoverlabel.visible = true
	get_tree().paused = true

func handle_collisions(data):
	match data:
		"food": collide_with_points()
		"powerup": collide_with_power_up()

func collide_with_points() -> void:
	$sounds/eat_fruit.play()	
	points += 10
	score.text = str(points)

func collide_with_power_up() -> void:
	$sounds/eat_powerup.play()	
	points += 100
	score.text = str(points)
	$power_up_timer.start()
	emit_signal("power_up", true)
	$sounds/frightened_ghosts.play()

func _on_power_up_timer_timeout():
	emit_signal("power_up", false)
	$sounds/frightened_ghosts.stop()


func _on_pacman_game_over():
	game_over()
