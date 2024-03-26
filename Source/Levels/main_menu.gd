extends ColorRect

func _on_play_pressed():
	Data.player_dir = Vector2(0, -1)
	get_tree().change_scene_to_file.bind("res://Source/Levels/face_level.tscn").call_deferred()

func _on_credits_pressed():
	print("... credits?")

func _on_quit_pressed():
	get_tree().quit()
