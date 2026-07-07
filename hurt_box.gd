class_name HurtBox
extends Area2D


@export var health : Health

func _ready() -> void:
	area_entered.connect(func(area: Area2D):
		if area is HitBox:
			health.current_health -= area.damage
		)
