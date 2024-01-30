extends ColorRect

@onready var hp = $HP

func _ready():
	hp.frame = Data.player_cur_hp

func _input(event):
	if(event.is_action_pressed("Escape")):
		get_tree().quit()
