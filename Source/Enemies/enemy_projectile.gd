extends Area2D

@onready var player_dir = Vector2(0,0)

func _physics_process(_delta):
	global_position += (player_dir * 15) # player_dir is the player direction , 50 is the speed its traveling at 

func _on_body_entered(_body):
	queue_free()
	

func _on_area_entered(area):
	print("Hit")
	var body = area.get_parent()
	if(body.is_in_group("Player")): # checks if the hitbox is the player's hitbox (goes through enemies (?)) 
		body.recieve_damage(1, player_dir) # deals 1 damage to player 
	queue_free() 
