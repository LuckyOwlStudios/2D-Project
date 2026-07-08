class_name Health
extends Node

## When the health of this object reaches zero.
signal health_depleted

## The maximum health of this object
@export var max_health : int = 3 
## The current health of this object
var current_health : int : set = set_health

func _ready() -> void:
	current_health = max_health

func set_health(amount: int):
	current_health = amount
	if current_health <= 0:
		health_depleted.emit()
