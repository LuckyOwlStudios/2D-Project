class_name Chain
extends Line2D

@export var target: Node2D

func _process(delta: float) -> void:
	if target is Player:
		set_point_position(0, target.center.global_position)
