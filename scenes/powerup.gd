extends Area2D

signal collide_point(data)

func _on_body_entered(body):
	if(body.name == "pacman"):
		emit_signal("collide_point", "powerup")
		queue_free()
