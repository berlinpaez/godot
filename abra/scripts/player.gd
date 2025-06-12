extends CharacterBody2D

const kSpeed = 125.0
const kAccel = 10

var bullet_preload = preload("res://scenes/bullet.tscn")
var bullet_texture = preload("res://assets/bullet.png")
@onready var bullet_spawn_pos = $bullet_spawn_position

var input: Vector2

func get_input():
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input.normalized()
	
func _process(delta):
	# Move player
	var player_input = get_input()
	velocity = lerp(velocity, player_input * kSpeed, delta*kAccel)
	move_and_slide()	

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			var bullet_instance = bullet_preload.instantiate()
			bullet_instance.global_position = bullet_spawn_pos.global_position
			var mouse_position = get_global_mouse_position()
			bullet_instance.rotation = atan2(mouse_position.y-global_position.y, 
				mouse_position.x-global_position.x)

			var killzone = bullet_instance.get_node("killzone")
			# Set bullet killzone to layer 5 (player bullet layer)
			killzone.collision_layer = 0b10000
			# Detect collisions on layer 3 (enemies) and 4 (enemy bullet layer)
			killzone.collision_mask = 0b1100  
			
			bullet_instance.get_node("sprite").set_texture(bullet_texture)
			get_parent().add_child(bullet_instance)
