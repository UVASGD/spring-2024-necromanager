extends CharacterBody2D

@onready var resurrected: bool = false
@onready var player = get_parent().get_node("Player")

func _ready():
	modulate.a = 0.5

func _physics_process(_delta):
	if(resurrected and !player.move_lock):
		velocity = (player.dir * player.speed)
		if(abs(player.dir.x)+abs(player.dir.y) == 2): velocity *= 1/sqrt(2)
		move_and_slide()

func _input(event):
	if(!resurrected and event.is_action_pressed("Click")):
		var pos_diff = abs(get_global_mouse_position()) - abs(global_position)
		if(pos_diff.x <= 25 and pos_diff.x <= 25):
			modulate.a = 1
			resurrected = true
