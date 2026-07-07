class_name Enemy 
extends CharacterBody2D


@export var speed := 300.0

@onready var health: Health = $Health
# gets reference to player node in WORLD scene
@onready var player := $"/root/World/Player"


func _ready() -> void:
	health.health_depleted.connect(queue_free)

func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(player.global_position)
	var desired_velocity := direction * speed
	velocity = velocity.move_toward(desired_velocity, speed * delta)
	
	move_and_slide()
