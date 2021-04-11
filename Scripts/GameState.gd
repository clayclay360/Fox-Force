extends Node


var max_levels = 2
var current_level = 0
var game_screen = "res://Scenes/LevelOne.tscn"
var title_screen = "res://Scenes/TitleScreen.tscn"
var level_name = ["LevelOne", "LevelTwo"]

func retstart():
	current_level = 0; # set to zero 
	get_tree().change_scene(title_screen) # load the title screen
	
func next_level():
	current_level += 1 # add one
	var path = level_name[GameState.current_level] # set path to equal the string of one of the level name's array
	
	if current_level <= max_levels:
		get_tree().change_scene("res://Scenes/"+path+".tscn") # load the level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
