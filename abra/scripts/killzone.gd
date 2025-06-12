extends Area2D

@onready var timer = $Timer

func _on_body_entered(body: Node2D) -> void:
	if (body.name == "player"):
		print("You died.")
		timer.start()
	elif (body.name=="boundary"):
		print("Killzone hit boundary, doing nothing.")
		return
	else:
		print("Body hit killzone: ", body.name)
		$/root/game.remove_child.call_deferred(body.get_parent())
		body.get_parent().queue_free()
	
func _on_timer_timeout():
	get_tree().reload_current_scene()

func _on_area_entered(area: Area2D) -> void:
	if (area.name=="boundary"):
		print("Killzone hit boundary, doing nothing.")
		return
		
	print("Killzone hit, removing area: ", area.get_parent().name)
	$/root/game.remove_child.call_deferred(area.get_parent())
	area.get_parent().queue_free()
