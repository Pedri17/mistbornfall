@icon("res://icons/icon_heart.png")
class_name HealthComponent
extends Node

@export var health: int = 1:
	set(value):
		health_lost.emit(health, value)
		health = value
		if value <= 0:
			dead.emit()

signal health_lost(previous_health: int, actual_health: int)
signal dead


func is_dead() -> bool:
	return health <= 0
