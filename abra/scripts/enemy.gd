extends Node2D

var kMaxLookAheadSeconds = 0.1
var kAngleClampRadians = 30 * PI/180
var kTargetDistanceToPlayer = 100
var kSpeed = 70
var kTargetDistanceBuffer = 30

var bullet_preload = preload("res://scenes/bullet.tscn")
@onready var bullet_spawn_pos = $bullet_spawn_position
@onready var player = $/root/game/player

@onready var last_player_position = player.global_position
var predicted_player_position = Vector2(0.0,0.0)
var current_delta = 0
var distance_to_player = 0

func _on_shoot_timer_timeout() -> void:
	shoot()
	$shoot_timer.start()
	
func determine_bullet_rotation(bullet_speed: float) -> float:
	# Use bullet speed and player distance away to determine how far ahead to look ahead
	var current_player_position = player.global_position
	var seconds_to_hit = distance_to_player/bullet_speed
	var clamped_seconds_to_hit = clamp(seconds_to_hit, 0.0, kMaxLookAheadSeconds)
	
	# Use player velocity to determine predicted player position within the seconds to hit
	var current_player_velocity = Vector2()
	current_player_velocity.x = (current_player_position.x - last_player_position.x)/current_delta
	current_player_velocity.y = (current_player_position.y - last_player_position.y)/current_delta
	predicted_player_position.x = current_player_position.x + current_player_velocity.x*clamped_seconds_to_hit
	predicted_player_position.y = current_player_position.y + current_player_velocity.y*clamped_seconds_to_hit
	last_player_position = current_player_position

	var angle_to_predicted = atan2(predicted_player_position.y - global_position.y, 
		predicted_player_position.x - global_position.x)
	var angle_to_current = atan2(current_player_position.y - global_position.y, 
		current_player_position.x - global_position.x)
	var clamped_angle = clamp(angle_to_predicted, angle_to_current-kAngleClampRadians, 
	angle_to_current+kAngleClampRadians)
	return clamped_angle
	
func _physics_process(delta: float) -> void:
	current_delta = delta
	
	distance_to_player = sqrt(pow(player.global_position.x - global_position.x,2) + 
		pow(player.global_position.y - global_position.y,2))
	var angle_to_player = atan2(player.global_position.y - global_position.y, 
		player.global_position.x - global_position.x)
	var weight = 1 if distance_to_player > kTargetDistanceToPlayer else -1
	weight = 0 if abs(distance_to_player - kTargetDistanceToPlayer) < kTargetDistanceBuffer else weight
	position.x += weight*delta*kSpeed*cos(angle_to_player)
	position.y += weight*delta*kSpeed*sin(angle_to_player)

func shoot() -> void:
	var bullet_instance = bullet_preload.instantiate()
	bullet_instance.position = bullet_spawn_pos.global_position
	bullet_instance.rotation = determine_bullet_rotation(bullet_instance.kSpeed)
	get_parent().add_child(bullet_instance)
