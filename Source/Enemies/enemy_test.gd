extends CharacterBody2D

@onready var hp: int = 4
@onready var damage: int = 1
@onready var target_pos = Vector2(0,0)
@onready var speed = 150
@onready var boost = 0
@onready var paused = true

@onready var player = get_parent().get_node("Player")
@onready var skeleton : PackedScene = preload("res://Source/Enemies/skeleton_test.tscn")

func _ready():
	add_to_group("Enemy")

func _physics_process(_delta):
	if(!paused):
		if(boost == 0): target_pos = Vector2(player.global_position.x - self.global_position.x, player.global_position.y - self.global_position.y).normalized()
		velocity = target_pos * (speed-boost)
		move_and_slide()
		boost *= 0.9
		if(boost <= speed): boost = 0
		
func pause_unpause():
	if(paused): paused = false
	else: paused = true
	
func recieve_damage(dmg):
	if((hp - dmg) <= 0):
		hp = 0
		call_deferred("die")
	else:
		hp -= dmg
	boost = 1000
	
func die():
	var skel_inst = skeleton.instantiate()
	get_parent().add_child(skel_inst)
	skel_inst.global_position = self.global_position
	queue_free()

func _on_hbox_area_entered(area):
	var body = area.get_parent()
	if(body.is_in_group("Player")):
		body.recieve_damage(damage, target_pos)
		boost = 300
