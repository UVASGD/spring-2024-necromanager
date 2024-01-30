extends Node

#data.gd always runs even between scene transitions
#This file helps to save different values during these scene transitions
var player_dir: Vector2
var player_cur_hp: int
var is_door_open

func _init():
	player_dir = Vector2(0, -1)
	player_cur_hp = 6
	is_door_open = [1]
