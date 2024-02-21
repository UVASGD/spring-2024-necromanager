extends StaticBody2D

#export variables
@export var next_room: String = "" #path to the scene of the room the door leads to
@export var dir: Vector2 #direction the player is going when they enter they door -- (0, -1) = North, (0, 1) = South, (-1, 0) = West, (1, 0) = East
@export var door_num: int #index of the door in the is_door_open variable in data.gd. Doors that are connected have the same index

#variables
@onready var entered: bool = false
@onready var open: bool = Data.is_door_open[door_num]

#nodes
@onready var player = get_parent().get_node("Player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var exit_trigger = $ExitTrigger
@onready var exit_timer = $ExitTimer
@onready var enter_timer = $EnterTimer

func _ready():
	sprite.frame = Data.is_door_open[door_num] 
	if(Data.player_dir == -dir):
		player.global_position = self.global_position
		enter_timer.start()
	else:
		collision.set_deferred("disabled", false)

func _physics_process(_delta):
	if(open and player.dir == dir and exit_trigger.overlaps_area(player.hurtbox)): scene_transition()
	
func open_door():
	open = true
	sprite.frame = 1
	
func close_door():
	open = false
	sprite.frame = 0

func scene_transition():
	get_tree().call_group("Skeleton", "change_state", 1)
	exit_trigger.set_deferred("disabled", true)
	collision.set_deferred("disabled", true)
	Data.player_dir = dir
	player.move_lock = true
	player.dir = dir
	get_tree().call_group("Enemy", "pause_unpause")
	exit_timer.start()
	entered = true



func _on_enter_timer_timeout():
	player.move_lock = false
	collision.set_deferred("disabled", false)
	get_tree().call_group("Enemy", "pause_unpause")


func _on_exit_timer_timeout():
	get_tree().change_scene_to_file.bind(next_room).call_deferred()
