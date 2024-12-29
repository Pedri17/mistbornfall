@icon("res://icons/basic_physics_component.png")
class_name GravityComponent
extends Node
## Apply gravity velocity to a CharacterBody2D, executes move_and_slide() and
## emits a signal when character is not in floor.
@export var character: CharacterBody2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_multiplier: float = 1

var _was_on_floor: bool = false

signal floor_changed ## Signal emitted when the character stops being on the floor.

func _physics_process(delta):
	_was_on_floor = character.is_on_floor()
	# Gravity and apply movement
	if not character.is_on_floor():
		character.velocity.y += gravity * delta * gravity_multiplier
	character.move_and_slide()
	if _was_on_floor != character.is_on_floor():
		floor_changed.emit()
