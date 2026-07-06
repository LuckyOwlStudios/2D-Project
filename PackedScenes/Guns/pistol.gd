class_name Gun
extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var node_path_to_world := get_node("/root/World")
const BULLET = preload("uid://cyftgfviauafs")
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		animated_sprite_2d.play("shoot")
		var new_bullet := BULLET.instantiate() as Node2D
		new_bullet.position = bullet_spawn_point.global_position
		new_bullet.look_at(get_global_mouse_position())
		node_path_to_world.add_child(new_bullet)
