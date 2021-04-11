extends MarginContainer


onready var life_counter = [$HBoxContainer/HBoxContainer2/L1, $HBoxContainer/HBoxContainer2/L2, $HBoxContainer/HBoxContainer2/L3] 

func _on_Player_life_changed(value):
	for heart in range(life_counter.size()):
		if value - heart <= 0:
			life_counter[heart].visible = false # set to false
		
		
func _on_Score_changed(value):
	$HBoxContainer/ScoreLabel.text = str(value) # set the score label text to equal the value (covert to string)

