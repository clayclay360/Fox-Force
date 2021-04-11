extends Area2D

# this function is called when a node has entered the area 2D
func _on_Ladder_body_entered(body):
	if body.name == "Player":
			body.climb() # run the climb function

# this function is called when a node has exited the area 2D
func _on_Ladder_body_exited(body):
	if body.name == "Player":
			body.climb() # run the climb function 
