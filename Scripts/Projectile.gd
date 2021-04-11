extends Area2D

export (float) var speed

func _physics_process(delta):
	position.x += speed * delta # increase the position x by speed multiplied by delta
	
# this function is called when the acorn hit's another node's body collision
func _on_Acorn_body_entered(body):
	if body.is_in_group("enemy"):
		body.take_damage() # run the take damage function
		queue_free() # destroy projectile
	elif body.is_in_group("player"):
		return
	else:
		queue_free() # destroy projectile 
