extends CharacterBody2D

@onready var hp: int = 4
@onready var damage: int = 1
@onready var target_pos = Vector2(0,0)
@onready var speed = 150
@onready var boost = 0
@onready var paused = true
@onready var proj_inst # instantialize a projectile object in godot 
@onready var player = get_parent().get_node("Player") # pulling the "player" to be referenced in the code
@onready var skeleton : PackedScene = preload("res://Source/Enemies/skeleton_test.tscn") # path for the skeleton test 
@onready var projectile : PackedScene = preload("res://Source/Enemies/enemy_projectile.tscn") #path for the enemy projectile
@onready var player_dir = Vector2(0, 0) # vector holding the player's current direction 

func _ready():
	add_to_group("Enemy") # adds THIS enemy to the class of enemy 

func _physics_process(_delta):
	if(!paused):
		if(boost == 0): target_pos = Vector2(player.global_position.x + 300 - self.global_position.x, player.global_position.y + 300 - self.global_position.y).normalized() # the +300 gives the player essentially a radius that the ranged enemies don't want to get in (kinda circle around like a ring) 
		velocity = target_pos * (speed-boost)
		move_and_slide()
		boost *= 0.3 # want enemy to be slower than the player (spamming projectiles at same speed is annoying)
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
	
func enemy_shoot_projectile(): #lowkey just put this onto timer/time out function (will be added later)
	proj_inst = projectile.instantiate()
	player_dir = Vector2(player.global_position.x - self.global_position.x, player.global_position.y - self.global_position.y).normalized() #updates the player_dir to be the actual player direction lol.
	get_parent().add_child(proj_inst)
	proj_inst.global_position = self.global_position + (player_dir * 75)
	proj_inst.player_dir = player_dir

func die():
	var skel_inst = skeleton.instantiate()
	get_parent().add_child(skel_inst)
	skel_inst.global_position = self.global_position
	queue_free()

func _on_timer_timeout():
	enemy_shoot_projectile() # Replace with function body.


func _on_h_box_area_entered(area): # connect area2D node to actually implement a hitbox (prebuilt into godot, code in the bottom is our's tho to indicate that the player should be hit
	var body = area.get_parent()
	if(body.is_in_group("Player")):
		body.recieve_damage(damage, target_pos)
		boost = 300
