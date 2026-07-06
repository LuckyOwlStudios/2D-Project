class_name Player
extends CharacterBody2D

enum POS_STATE {
	STANDING,
	CROUCHING,
	WALKING,
	RUNNING,
	RAGDOLL
}

## Horizontal movement speed, in pixels per second.
@export var movement_speed: float = 1.0

## How high the player jumps, in pixels.
@export var jump_height: float = 1.0

## How quickly the player reaches top speed, in pixels per second squared.
@export var acceleration: float = 2000.0

@export var look_nodes: Array[Node2D]

@onready var camera: Camera2D = $Camera2D
@onready var sprite_root: Node2D = $SpriteRoot
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var center: Marker2D = $Center

## Grace period (seconds) after leaving a ledge where a jump still counts.
var coyote_time: float = 0.1
var _coyote_timer: float = 0.0

var is_left: bool

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_height * 250

func _process(delta: float) -> void:
	var mouse_location: Vector2 = get_global_mouse_position()
	is_left = mouse_location.x <= global_position.x
	sprite_root.scale.x = -1 if is_left else 1
	_handle_look_nodes()
	
func _physics_process(delta: float) -> void:
	
	# Coyote time: refill while grounded, drain once airborne.
	if is_on_floor():
		_coyote_timer = coyote_time
	else:
		_coyote_timer -= delta
	
	# Apply gravity while airborne.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Horizontal movement, eased in/out by acceleration.
	var direction: float = Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, direction * movement_speed * 100, acceleration * delta)
	
	move_and_slide()

func _handle_look_nodes() -> void:
	var mouse: Vector2 = get_global_mouse_position()
	for node in look_nodes:
		node.look_at(mouse)
