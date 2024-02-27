extends Area2D

func _on_area_entered(area):
	var body = area.get_parent()
	if(body.is_in_group("Player")):
		body.recieve_damage(1, -body.last_dir)
