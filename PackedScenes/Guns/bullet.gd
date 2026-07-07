class_name Bullet
extends Node2D

@export var bullet_speed : float
@onready var hit_box: Area2D = $HitBox


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hit_box.body_entered.connect(func(body: Node2D):
		queue_free()
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction := Vector2.RIGHT.rotated(rotation)
	position += direction * bullet_speed * delta
