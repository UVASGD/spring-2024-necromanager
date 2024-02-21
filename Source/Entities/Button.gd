extends Area2D
@onready var player = get_parent().get_parent().get_node("Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_area_entry(body):
	pass

func _on_area_entered(area):
	print("entered")
	var knockback = Vector2(20, 0)
	player.recieve_damage(1, knockback);
	print("Button is pressed. Button is agro.")
	pass # Replace with function body.
