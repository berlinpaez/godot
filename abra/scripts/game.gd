extends Node2D

var enemy_preload = preload("res://scenes/enemy.tscn")
@onready var spawn_array = [$spawn_1, $spawn_2, $spawn_3, $spawn_4]

func _on_despawn_area_area_exited(area: Area2D) -> void:
	print("Despawner hit, removing node from game: ", area.get_parent().name)
	remove_child.call_deferred(area.get_parent())
	area.get_parent().queue_free()

func _on_enemy_spawner_timeout() -> void:
	var enemy = enemy_preload.instantiate()
	var spawn_marker = int(randf()*4)
	enemy.global_position = spawn_array[spawn_marker].global_position
	add_child(enemy)
