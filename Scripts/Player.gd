extends KinematicBody2D

#This script controls all of characters movement

#variables
enum {IDLE, RUN, JUMP, HURT, DEAD} 
var state
var anim
var new_anim
var velocity = Vector2()
export (int) var run_speed
export (int) var jump_speed
export (int) var gravity

signal life_change
signal dead
var life = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func start(pos):
	position = pos # set equal to position
	show() # show player node
	change_state(IDLE) # change state to idle
	life = 3 # set left to 3
	emit_signal("life_change") # emit life change signal 

func change_state(new_state):
	state = new_state # equal new state
	match state:
		IDLE:
			new_anim = "idle" # set idle animation
		RUN:
			new_anim = "run" # set run animation
		HURT:
			new_anim = "hurt"
			velocity.y = -200 # y velocity minus 200
			velocity.x = -100 * sign(velocity.x)  # x velocity minus negative velocity
			life -= 1 # life minus one
			emit_signal("life_change") # emit life change
			yield(get_tree().create_timer(0.5),"timeout") # wait for time
			change_state(IDLE) #change state to idle
			if	life == 0:
				change_state(DEAD)	# change state to dead
		JUMP:
			new_anim = "jump_up" # set jump up animation
		DEAD:
			emit_signal("dead") # emit dead signal
			hide() # hide player
			
func _physics_process(delta):
	velocity.y += gravity * delta # decrease y velocity by gravity times delta 
	get_input() # run get_input function
	if new_anim != anim:
		anim = new_anim # set new animation
		$AnimationPlayer.play(anim) # play animation
		
	velocity = move_and_slide(velocity, Vector2(0,-1)) #
	
	if state == JUMP and velocity.y > 0:
		new_anim = "jump_down" # set jump down animation 
	if state == JUMP and is_on_floor():
		change_state(IDLE) # change state to idle
	if state == HURT:
		return
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)
		if collision.collider.name == "Danger":
			hurt()
		if collision.collider.is_in_group("enemy"):
			var player_feet = (position + $CollisionShape2D.shape.extents).y
			if player_feet < collision.collider.position.y:
				collision.collider.take_damage()
				velocity.y = - 200
			else:
				hurt()
	
func get_input():
	if state == HURT:
		return #return nothing
	velocity.x = 0 # equal zero
	var right = Input.is_action_pressed("right") # get right input
	var left = Input.is_action_pressed("left") # get left input
	var jump = Input.is_action_just_pressed("jump") # get jump input
	
	if right:
		velocity.x += run_speed # increase x velocity by run speed
		$Sprite.flip_h = false # set false
	if left:
		velocity.x -= run_speed # decrease velocity by run speed
		$Sprite.flip_h = true # set true
	if jump and is_on_floor():	
		change_state(JUMP) #change state to jump
		velocity.y = jump_speed # equal jump speed
	if state == IDLE and velocity.x != 0:
		change_state(RUN) # change state to run
	if state == RUN and velocity.x == 0:
		change_state(IDLE) # change state to idle
	if state == IDLE and !is_on_floor() || state == RUN and !is_on_floor():
		change_state(JUMP) #change state to jump
	
func hurt():
	if state != HURT:
		change_state(HURT)
