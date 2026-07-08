class_name HurtBox
extends Area2D

signal damaged(amount: float)

@export var health : Health

func damage(amount: float):
	if health:
		health.current_health -= amount
