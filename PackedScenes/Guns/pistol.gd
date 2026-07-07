class_name Gun
extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var node_path_to_world := get_node("/root/World")
const BULLET = preload("uid://cyftgfviauafs")
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		animated_sprite_2d.play("shoot")
		audio_stream_player_2d.play(0.0)
		var new_bullet := BULLET.instantiate()
		new_bullet.position = bullet_spawn_point.global_position
		new_bullet.rotation = bullet_spawn_point.global_rotation
		node_path_to_world.add_child(new_bullet)
