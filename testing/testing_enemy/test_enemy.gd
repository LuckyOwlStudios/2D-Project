class_name TestEnemy 
extends CharacterBody2D


@export var speed := 300.0

@onready var health: Health = $Health
# gets reference to player node in WORLD scene
@onready var player := $"/root/TestWorld/TestPlayer"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var line_of_sight: RayCast2D = $Sprite2D/LineOfSight

var flipped_left := -1.0
var flipped_right := 1.0

func _ready() -> void:
	health.health_depleted.connect(queue_free)

func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(player.global_position)
	var desired_velocity := direction * speed
	velocity = velocity.move_toward(desired_velocity, speed * delta)
	
	#if global_position.x > player.global_position.x:
	#	sprite_2d.flip_h = true
	#	line_of_sight.target_position.x *= -1
		# constantly flipping ever frame 
		
	#elif player.global_position.x > global_position.x:
	#	scale.x *= 1
	
	
	move_and_slide()
