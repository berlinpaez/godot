extends Node2D

func _on_despawn_area_area_exited(area: Area2D) -> void:
	remove_child.call_deferred(area.get_parent())
	area.get_parent().queue_free()
