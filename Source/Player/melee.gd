extends Area2D

@onready var player = get_parent().get_node("Player")
@onready var count = 0

func _physics_process(_delta):
	global_position = player.global_position + (global_position - player.global_position).rotated(PI/24)
	look_at(player.global_position)
	count += 1
	if(count == 12):
		queue_free()
		player.move_lock = false

func _on_area_entered(area):
	var body = area.get_parent()
	if(body.is_in_group("Enemy")):
		body.recieve_damage(2)
