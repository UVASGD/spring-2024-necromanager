extends CharacterBody2D

@onready var player = get_parent().get_node("Player")
@onready var dir
@onready var state = 0 #0 unressurected, 1 is mirror, 2 is follow
@onready var assembling = false
@onready var target_pos = Vector2(0,0)
@onready var skel_num = 0

@onready var col = $CollisionShape2D

func _ready():
	modulate.a = 0.5
	add_to_group("Skeleton")

func _physics_process(_delta):
	if(!player.move_lock):
		if(state == 1):
			velocity = (player.dir * player.speed)
			if(abs(player.dir.x)+abs(player.dir.y) == 2): velocity *= 1/sqrt(2)
			move_and_slide()
		elif(state == 2 && assembling):
			var pos = Vector2(0,0)
			target_pos = player.global_position
			match skel_num:
				0:
					pos = Vector2(115, 0)
				1:
					pos = Vector2(0, 115)
				2:
					pos = Vector2(115, 115)
			target_pos += pos
			dir = Vector2(target_pos.x - self.global_position.x, target_pos.y - self.global_position.y).normalized()
			velocity = (dir * player.speed)
			move_and_slide()
			if(global_position > target_pos-Vector2(1,1) && global_position < target_pos+Vector2(1,1)):
				assembling = false
				set_collision_mask_value(6, true)
				reparent(player, true)
				position = pos
				col.reparent(player, true)
			else: global_position += Vector2(.1,.1)
				
func _input(event):
	if(event.is_action_pressed("Click")):
		var pos_diff = abs(get_global_mouse_position() - global_position)
		if(pos_diff.x <= 50 and pos_diff.y <= 50):
			if(state == 0):
				add()
				modulate.a = 1
				state = -1
				change_state(player.skel_state)
			elif (state == 1):
				modulate.a = 0.5
				state = 0
				for i in range(3):
					if(player.skeletons[i] == self):
						player.skeletons[i] = null
						player.shuffle()
			
func change_state(num):
	if(state != 0):
		state = num
		if(num == 1): 
			col.reparent(self, true)
			reparent(player.get_parent(), true)
		elif(num == 2): 
			assembling = true
			set_collision_mask_value(6, false)
			for i in range(3):
				if(player.skeletons[i] == self):
					skel_num = i
		
func add():
	for i in range(3):
		if(player.skeletons[i] == null):
			player.skeletons[i] = self
			skel_num = i
			player.shuffle()
			break
