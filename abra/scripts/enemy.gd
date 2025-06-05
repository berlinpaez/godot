extends Node2D

var bullet = preload("res://scenes/bullet.tscn")

@onready var bullet_spawn_pos = $bullet_spawn_position
@onready var player = $/root/Game/player

func _on_shoot_timer_timeout() -> void:
	shoot()
	$shoot_timer.start()
	
func determine_bullet_rotation() -> float:
	var player_position = player.position
	var angle_to_player = atan2(player_position.y - position.y, player_position.x - position.x)
	return angle_to_player
	
func shoot() -> void:
	var bullet_instance = bullet.instantiate()
	bullet_instance.position = bullet_spawn_pos.global_position
	bullet_instance.rotation = determine_bullet_rotation()
	get_parent().add_child(bullet_instance)
