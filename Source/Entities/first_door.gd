extends StaticBody2D

@onready var player = get_parent().get_node("Player")

func _ready():
	if(Data.player_dir == Vector2(0, -1)): 
		player.move_lock = false
		player.process_mode = Node.PROCESS_MODE_INHERIT
		get_tree().paused = false
