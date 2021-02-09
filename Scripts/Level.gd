extends Node2D

onready var pickups = $PowerUps
var score
signal score_changed


# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0 # equal zero
	emit_signal("score_changed") # emit score changed 
	pickups.hide() # hide pickup
	$Player.start($PlayerSpawn.position) # position the player 
	set_camera_limits() # run this method
	spawn_pickups()  # run this method
	
func set_camera_limits():
	var map_size = $Environment.get_used_rect() # get the rect of the environment tileset
	var cell_size = $Environment.cell_size # get the cell size
	$Player/Camera2D.limit_left = map_size.position.x * cell_size.x # equal map size x position
	$Player/Camera2D.limit_right = map_size.end.x * cell_size.x # equal map size x's end position
	
func spawn_pickups():
	for cell in pickups.get_used_cells():
		var id = pickups.get_cellv(cell) # get every cell's vector 2 in pickups
		var type = pickups.tile_set.tile_get_name(id) # get every cell's tile name in pickups
		if type in "cherry_spawn":
			var c = load("res://Scenes/Collectible.tscn").instance() # load the collectable scene
			var pos = pickups.map_to_world(cell) # 
			c.init(type, pos + pickups.cell_size / 2) # call the collectable method init
			add_child(c) # add the local collectable
			c.connect("pickup", self, "_on_Collectable_pickup") # connect the signal pickup to on_Collectable_pickup

func _on_Collectable_pickup():
	score += 1 # increase score by one
	emit_signal("score_changed") # emit score_changed


func _on_Level_score_changed():
	$CanvasLayer/HUD._on_Score_changed(score)
	

func _on_Player_life_change():
	$CanvasLayer/HUD._on_Player_life_changed($Player.life)
	
func _on_Player_dead():
	print("Dead")
	GameState.retstart()

func _on_Door_body_entered(body):
	print("YO")
	GameState.next_level()
