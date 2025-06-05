extends Node2D

var kSpeed = 100

func _physics_process(delta: float) -> void:
	position.x += delta*kSpeed*cos(rotation)
	position.y += delta*kSpeed*sin(rotation)
