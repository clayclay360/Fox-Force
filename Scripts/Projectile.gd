extends Area2D

export (float) var speed

func _physics_process(delta):
	position.x += speed * delta
	

func _on_Acorn_body_entered(body):
	if body.is_in_group("enemy"):
		body.take_damage()
		queue_free()
	elif body.is_in_group("player"):
		return
	else:
		queue_free()
