extends ColorRect

func resume_game():
	get_tree().paused = false
	self.queue_free()

func _input(event):
	if(event.is_action_pressed("Escape")):
		resume_game()

func _on_resume_pressed():
	resume_game()

func _on_quit_menu_pressed():
	Data._init()
	get_tree().paused = false
	get_tree().change_scene_to_file.bind("res://Source/Levels/main_menu.tscn").call_deferred()

func _on_quit_desktop_pressed():
	get_tree().quit()
