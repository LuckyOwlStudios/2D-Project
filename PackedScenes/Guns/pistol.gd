class_name Gun
extends Node2D

const BULLET = preload("uid://cyftgfviauafs")

const GUN_CHAMBERED = preload("uid://d2ssbsjx0vsni")
const PISTOL_SHOOT = preload("uid://j8s4678gd0ke")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var node_path_to_world := get_node("/root/World")
@onready var ray_cast: RayCast2D = $BulletSpawnPoint/RayCast2D
@onready var flash_point_light: PointLight2D = $BulletSpawnPoint/FlashPointLight2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var ammo_count_label: Label = %AmmoCount

@onready var mouse_anchor: Control = $CanvasLayer/MouseAnchor
@onready var reload_label: Label = %AmmoCount

var magazine_size: int = 12
var ammo_count: int

func _ready() -> void:
	flash_point_light.hide()
	_reload()

func _process(delta: float) -> void:
	mouse_anchor.global_position = get_viewport().get_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot") and ammo_count:
		_fire()
	if event.is_action_pressed("reload"):
		_reload()

func _fire():
	animated_sprite_2d.play("shoot")
	ray_cast.look_at(get_global_mouse_position())
	node_path_to_world.add_child(BulletTrail.create(bullet_spawn_point.global_position, ray_cast.get_collision_point(), Color(18.892, 8.187, 0.0, 1.0), 2))
	_flash()
	_handle_hit()
	ammo_count -= 1
	if ammo_count == 0:
		reload_label.show()

func _reload():
	ammo_count = magazine_size
	audio_stream_player.stream = GUN_CHAMBERED
	audio_stream_player.play()
	await  audio_stream_player.finished
	audio_stream_player.stream = PISTOL_SHOOT
	reload_label.hide()

func _flash() -> void:
	flash_point_light.show()
	for i in 3:
		await get_tree().process_frame
	flash_point_light.hide()
	audio_stream_player.pitch_scale = randf_range(0.95, 1.05)
	audio_stream_player.play()

func _handle_hit():
	if ray_cast.is_colliding():
		var collider := ray_cast.get_collider()
		if collider is HurtBox:
			collider.damage(1)
