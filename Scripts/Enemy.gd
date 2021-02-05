extends KinematicBody2D

export (int) var speed
export (int) var gravity
var velocity = Vector2()
var facing = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	$Sprite.flip_h = velocity.x > 0
	velocity.y += gravity * delta # decrease y velocity by gravity times delta 
	velocity.x = facing * speed
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if collision.collider.name == "Player":
			collision.collider.hurt()
		if collision.normal.x != 0:
			facing = sign(collision.normal.x)
		if position.y > 1000:
			queue_free()

func take_damage():
	$AnimationPlayer.play("death") # play death animation
	$CollisionShape2D.disabled = true # set disable true
	set_physics_process(false) # shut down set physics process
		
		



func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
