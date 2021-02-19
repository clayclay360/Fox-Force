extends KinematicBody2D

#This script controls all of characters movement

#variables
enum {IDLE, RUN, JUMP, HURT, DEAD, CLIMB} 
var state
var anim
var new_anim
var velocity = Vector2()
export (int) var run_speed
export (int) var jump_speed
export (int) var climbing_speed
export (int) var gravity
const acorn = preload("res://Scenes/Projectile.tscn")

var max_jumps = 2
var jump_count = 0
var direction = 1
var life = 3
var is_climbing = false;
var is_hugging = false;

signal life_change
signal dead


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
			jump_count = 0
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
			jump_count = 0
		DEAD:
			emit_signal("dead") # emit dead signal
			hide() # hide player
		CLIMB:
			new_anim = "climb"
			
func _physics_process(delta):
	if !is_climbing || !is_hugging:
		velocity.y += gravity * delta # decrease y velocity by gravity times delta 
	get_input() # run get_input function
	if new_anim != anim:
		anim = new_anim # set new animation
		$AnimationPlayer.play(anim) # play animation
		
	velocity = move_and_slide(velocity, Vector2(0,-1)) # move and slide by the velocity and direction
	if state == JUMP and velocity.y > 0:
		new_anim = "jump_down" # set jump down animation		 
	if state == JUMP and is_on_floor():
		change_state(IDLE) # change state to idle
	if state == HURT:
		return
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index) # get each of the slide collision's
		if collision.collider.name == "Danger":
			hurt() # run hurt function
		if collision.collider.is_in_group("enemy"):
			var player_feet = (position + $CollisionShape2D.shape.extents).y # get players feet position plus collision shape's y position
			if player_feet < collision.collider.position.y:
				collision.collider.take_damage() # run take damage function from collider
				velocity.y = - 200 # decrease by 200
			else:
				hurt()
	if position.y > 1000:
		change_state(DEAD) # change state to dead
	
func get_input():
	if state == HURT:
		return #return nothing
	velocity.x = 0 # equal zero
	var right = Input.is_action_pressed("right") # get right input
	var left = Input.is_action_pressed("left") # get left input
	var jump = Input.is_action_just_pressed("jump") # get jump input
	var throw = Input.is_action_just_pressed("throw") # get throw input
	var up = Input.is_action_pressed("up")
	var down = Input.is_action_pressed("down")
	
	if right:
		velocity.x += run_speed # increase x velocity by run speed
		$Sprite.flip_h = false # set false
		direction = 1
	if left:
		velocity.x -= run_speed # decrease velocity by run speed
		$Sprite.flip_h = true # set true
		direction = -1
	if jump and is_on_floor():	
		change_state(JUMP) #change state to jump
		velocity.y = jump_speed # equal jump speed
	if jump and state == JUMP and jump_count < max_jumps:
		print(jump_count)
		new_anim = "jump_up" # equal jump_up
		velocity.y = jump_speed / 1.5 # equal jump speed
		jump_count += 1 # plus equal one
	if state == IDLE and velocity.x != 0:
		change_state(RUN) # change state to run
	if state == RUN and velocity.x == 0:
		change_state(IDLE) # change state to idle
	if state == IDLE and !is_on_floor() || state == RUN and !is_on_floor():
		change_state(JUMP) #change state to jump
	if state == IDLE and throw:
		var particle_instance = acorn.instance()
		get_tree().current_scene.add_child(particle_instance)
		particle_instance.global_transform = $ProjectileSpawn.global_transform
		particle_instance.speed *= direction
	if is_climbing and up:
		velocity.y -= climbing_speed
		clamp(velocity.y,0,climbing_speed)
	if is_climbing and down:
		velocity.y += climbing_speed
		clamp(velocity.y,0,climbing_speed)
	
func hurt():
	if state != HURT:
		change_state(HURT) # change state to hurt

func climb():
	is_climbing = ! is_climbing
	if is_climbing:
		change_state(CLIMB)
	else:
		change_state(RUN)
		
func hug():
	is_hugging != is_hugging
