class_name AllomancyPower
extends Node


@onready var allomancy_component: AllomancyComponent = get_parent()


func use_power() -> bool:
	return false


func using_power() -> bool:
	return false


func release_power() -> bool:
	return false
