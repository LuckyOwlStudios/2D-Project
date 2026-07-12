class_name Gun
extends Node2D

const BULLET = preload("uid://cyftgfviauafs")

const GUN_CHAMBERED = preload("uid://d2ssbsjx0vsni")
const PISTOL_SHOOT = preload("uid://j8s4678gd0ke")
const CROSS = preload("uid://b3hermfjhtm5m")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var node_path_to_world := get_node("/root/TestWorld")
@onready var ray_cast: RayCast2D = $BulletSpawnPoint/RayCast2D
@onready var flash_point_light: PointLight2D = $BulletSpawnPoint/FlashPointLight2D
@onready var audio_stream_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var ammo_count_label: Label = %AmmoCount

@onready var mouse_anchor: Control = $CanvasLayer/MouseAnchor
@onready var reload_label: Label = %AmmoCount
@onready var progress_bar: ProgressBar = $CanvasLayer/MouseAnchor/ProgressBar

## How many shots before needing to reload
var magazine_size: int = 24
## Shots per second
var fire_rate: float = 8.0 # Good starter weapon can be 8, better AR will be 12
var ammo_count: int:
	set(value):
		ammo_count = value
		if progress_bar.is_node_ready():
			progress_bar.value = ammo_count
## Time until the gun can fire again
var _cooldown: float = 0.0
var _reloading: bool = false
## Max spread in degrees, applied to each side
var spread: float = 1.5

func _ready() -> void:
	flash_point_light.hide()
	progress_bar.max_value = magazine_size
	progress_bar.value = magazine_size
	_reload()
	#Input.set_custom_mouse_cursor(CROSS, Input.CURSOR_ARROW, CROSS.get_size() * 0.5)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta: float) -> void:
	if _cooldown > 0.0:
		_cooldown -= delta
	if Input.is_action_pressed("shoot") and ammo_count > 0 and _cooldown <= 0.0 and not _reloading:
		_fire()

func _physics_process(delta: float) -> void:
	mouse_anchor.global_position = get_viewport().get_mouse_position() - mouse_anchor.size * 0.5

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"):
		_reload()

func _fire():
	_cooldown = 1.0 / fire_rate
	animated_sprite_2d.play("test_shoot")
	ray_cast.look_at(get_global_mouse_position())
	ray_cast.rotation += deg_to_rad(randf_range(-spread, spread))
	node_path_to_world.add_child(BulletTrail.create(bullet_spawn_point.global_position, ray_cast.get_collision_point(), Color(18.892, 8.187, 0.0, 1.0), 2))
	_flash()
	_handle_hit()
	ammo_count -= 1
	if ammo_count == 0:
		reload_label.show()
		progress_bar.hide()

func _reload():
	if _reloading:
		return
	_reloading = true
	audio_stream_player.stream = GUN_CHAMBERED
	audio_stream_player.play()
	await audio_stream_player.finished
	audio_stream_player.stream = PISTOL_SHOOT
	ammo_count = magazine_size
	reload_label.hide()
	progress_bar.show()
	_reloading = false

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
		#if collider is HurtBox:
		#	collider.damage(1.0)
		if collider is HurtBox:
			if collider.has_method("damage_from_ray"):
				collider.damage_from_ray()
			
		
