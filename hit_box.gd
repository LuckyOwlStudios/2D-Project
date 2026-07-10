class_name HitBox
extends Area2D

@export var damage : float = 1.0

func _ready() -> void:
	area_entered.connect(_deal_damage)
	
func _deal_damage(area: Area2D):
	if area is HurtBox:
		area.damage(damage)
		
