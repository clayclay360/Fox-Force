extends RigidBody2D


func _on_Climbable_Wall_body_entered(body):
	print("I'm hit")
	if body.name == "Player":
			print("player hit me")


func _on_Climbable_Wall_body_exited(body):
	if body.name == "Player":
			pass
