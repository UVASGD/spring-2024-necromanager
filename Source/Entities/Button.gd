extends Area2D
#@onready var player = get_parent().get_node("Player")
@onready var sprite = $Sprite2D
@onready var pressed = false
@export var door: Node2D

func _ready():
	add_to_group("buttons")

func is_pressed():
	if !pressed:
		door.buttons_pressed = false


func _on_body_entered(body):
	if !pressed:
		sprite.frame = 1
		pressed = true
		door.buttons_pressed = true
		get_tree().call_group("buttons", "is_pressed")
		if door.buttons_pressed:
			door.open_door()

func _on_body_exited(body):
	if pressed:
		sprite.frame = 0
		pressed = false
		door.close_door()
