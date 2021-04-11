extends KinematicBody2D

export (int) var speed
export (int) var gravity
var velocity = Vector2()
var facing = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	$Sprite.flip_h = velocity.x > 0  # flip the sprite if the velocity x is greater than zero
	velocity.y += gravity * delta # decrease y velocity by gravity times delta 
	velocity.x = facing * speed # set velocity x to facing multiplied by speed 
	velocity = move_and_slide(velocity, Vector2(0,-1)) # set velocity to move along the velocity flip it's direction along the y axis
	
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index) # get an array of all the collision of the enemy
		if collision.collider.name == "Player":
			collision.collider.hurt() # run the hurt function
		if collision.normal.x != 0:
			facing = sign(collision.normal.x) # flip the direction the enemy is facing
		if position.y > 1000:
			queue_free() # destroy enemy

func take_damage():
	$AnimationPlayer.play("death") # play death animation
	set_deferred("$CollisionShape2D.disabled",true) # set disable true
	set_physics_process(false) # shut down set physics process
		
		
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		queue_free() # destroy enemy
