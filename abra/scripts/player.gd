extends CharacterBody2D

const kSpeed = 200.0
const kAccel = 10

var input: Vector2

func get_input():
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input.normalized()
	
func _process(delta):
	var player_input = get_input()
	velocity = lerp(velocity, player_input * kSpeed, delta*kAccel)
	move_and_slide()
