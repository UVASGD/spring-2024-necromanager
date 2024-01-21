extends CharacterBody2D

#variables
@onready var speed = 300.0
@onready var dir = Data.player_dir
@onready var max_hp = 6
@onready var cur_hp = Data.player_cur_hp
@onready var move_lock = true
@onready var charged: bool = false
@onready var proj_inst
@onready var melee_inst
@onready var last_dir = dir #this can be changed when we work out animations
@onready var boost = 0

#nodes and scenes
@onready var hurtbox = $Hurtbox
@onready var ranged_timer = $RangedCharge
@onready var hud = get_parent().get_node("CanvasLayer/hud/HP")
@onready var projectile : PackedScene = preload("res://Source/Player/projectile.tscn")
@onready var melee : PackedScene = preload("res://Source/Player/melee.tscn")

func _ready():
	add_to_group("Player")
	hud.frame = Data.player_cur_hp

func _physics_process(_delta):
	if(!move_lock): dir = Vector2(Input.get_axis("Left", "Right"), Input.get_axis("Up", "Down"))
	velocity = dir * (speed+boost)
	if(dir != Vector2(0,0) && boost == 0): 
		if(dir.x && dir.y): last_dir = Vector2(dir.x, 0)
		else: last_dir = dir
	if(abs(dir.x)+abs(dir.y) == 2): velocity *= 1/sqrt(2)
	move_and_slide()
	if(boost != 0):
		boost *= 0.9
		if(boost >= -speed):
			boost = 0
			move_lock = false

func _input(event):
	if(event.is_action_pressed("Escape")):
		get_tree().quit()
	if(!move_lock):
		if(event.is_action_pressed("Charge") and !proj_inst): 
			ranged_timer.start()
			modulate.a = 0.3
		if(event.is_action_released("Charge")):
			if(charged): 
				proj_inst = projectile.instantiate()
				get_parent().add_child(proj_inst)
				proj_inst.global_position = self.global_position + (last_dir * 75)
				proj_inst.player_dir = last_dir
				charged = false
			else:
				ranged_timer.stop()
			modulate.a = 1
		if(event.is_action_pressed("Melee")):
			move_lock = true
			dir = Vector2(0,0)
			melee_inst = melee.instantiate()
			get_parent().add_child(melee_inst)
			melee_inst.global_position = self.global_position + (last_dir * 100)
			melee_inst.global_position = self.global_position + (melee_inst.global_position - self.global_position).rotated(-PI/4)
			melee_inst.look_at(self.global_position)

func _on_ranged_charge_timeout():
	modulate.a = 0.6
	charged = true

func recieve_damage(damage, knockback):
	if((cur_hp - damage) <= 0):
		cur_hp = 0
		die()
	else:
		cur_hp -= damage
	Data.player_cur_hp = cur_hp
	hud.frame = Data.player_cur_hp
	
	move_lock = true
	boost = -1500
	dir = -knockback

func die():
	print("player died")
	get_tree().paused = true
