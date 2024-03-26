extends ColorRect

@onready var hp = $HP
@onready var pause_menu : PackedScene = preload("res://Source/Levels/pause_menu.tscn")

func _ready(): #maybe unneccessary?
	hp.frame = Data.player_cur_hp

func _input(event):
	if(event.is_action_pressed("Escape") && !get_tree().paused):
		var inst = pause_menu.instantiate()
		get_parent().add_child(inst)
		get_tree().paused = true
