extends Node2D

onready var pickups = $PowerUps
var score
signal score_changed


# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0
	emit_signal("score_changed")
	pickups.hide()
	$Player.start($PlayerSpawn.position)
	set_camera_limits()
	
func set_camera_limits():
	var map_size = $Environment.get_used_rect()
	var cell_size = $Environment.cell_size
	$Player/Camera2D.limit_left = map_size.position.x * cell_size.x
	$Player/Camera2D.limit_right = map_size.end.x * cell_size.x
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
