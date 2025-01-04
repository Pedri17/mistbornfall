class_name NailableComponent
extends Node

@export var character: CharacterBody2D
@export var gravity_component: GravityComponent
@export var min_velocity_lenght_to_nail = 150

var nailed: bool = false:
	set(value):
		if value == true:
			_set_as_nailed()
		else:
			_set_as_unnailed()
		nailed = value


func _physics_process(delta) -> void:
	if nailed:
		character.velocity = Vector2.ZERO


func _set_as_nailed() -> void:
	gravity_component.no_gravity = true
	character.collision_mask = 0
	character.velocity = Vector2.ZERO


func _set_as_unnailed() -> void:
	nailed = false
	gravity_component.no_gravity = false
	character.collision_mask = 5
