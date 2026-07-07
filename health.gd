class_name Health
extends Node


signal health_depleted

@export var max_health : int = 3 
var current_health : int : set = set_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_health(amount: int):
	current_health = amount
	if current_health <= 0:
		health_depleted.emit()
