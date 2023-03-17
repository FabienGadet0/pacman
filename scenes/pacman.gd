extends CharacterBody2D

signal changed_direction(old_direction, new_direction)

signal game_over

var power_up := false

const SPEED := 270

var current_direction : direction = direction.NONE

enum direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	NONE
}

func update_velocity_from_direction() -> void:
	match current_direction:
		direction.NONE:
			$AnimationPlayer.play("idle")
			velocity = Vector2.ZERO
		direction.UP: 
			$AnimationPlayer.play("move_up")
			velocity =  Vector2.UP
		direction.DOWN: 
			$AnimationPlayer.play("move_down")
			velocity = Vector2.DOWN
		direction.LEFT: 
			$AnimationPlayer.play("move_left")
			velocity = Vector2.LEFT
		direction.RIGHT: 
			$AnimationPlayer.play("move_right")
			velocity = Vector2.RIGHT
	velocity = (velocity * SPEED)

func movement_bindings() -> void:
	var new_direction
	if Input.is_action_pressed("move_up"):
		new_direction = direction.UP
	elif Input.is_action_pressed("move_down"):
		new_direction = direction.DOWN
	elif Input.is_action_pressed("move_left"):
		new_direction = direction.LEFT
	elif Input.is_action_pressed("move_right"):
		new_direction = direction.RIGHT
	else: # allow to not emit signal if any other Input is done.
		return
		
	current_direction = new_direction

func _process(_delta) -> void:
	movement_bindings()

func _handle_collision() -> void:
	var col = get_last_slide_collision()
	if(col and col.get_collider().is_in_group("Enemy")):
		if(power_up):
			pass
		else:
			emit_signal("game_over")


func _physics_process(delta) -> void:
	update_velocity_from_direction()
	_handle_collision()
#	velocity *= delta
	move_and_slide()


func _on_world_power_up(enabled):
	power_up = enabled
