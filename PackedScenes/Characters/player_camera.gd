class_name PlayerCamera
extends Camera2D

@export_range(0.0, 1.0) var lean_factor: float = 0.25

@export var max_lean: float = 120.0

@export var smoothing_speed: float = 8.0

func _process(delta: float) -> void:
	var to_mouse: Vector2 = get_global_mouse_position() - global_position
	var target: Vector2 = (to_mouse * lean_factor).limit_length(max_lean)
	offset = offset.lerp(target, 1.0 - exp(-smoothing_speed * delta))
