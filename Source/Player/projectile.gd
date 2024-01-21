extends Area2D

@onready var player_dir = Vector2(0,0)

func _physics_process(_delta):
	global_position += (player_dir * 50)

func _on_body_entered(_body):
	queue_free()

func _on_area_entered(area):
	var body = area.get_parent()
	if(body.is_in_group("Enemy")):
		body.recieve_damage(2)
	queue_free()
