@icon("res://icons/horizontal_movement.png")
class_name HorizontalMovement
extends Node

@export var character: CharacterBody2D = owner as CharacterBody2D
@export var input: InputComponent ## Optional, if needs to make movement through joystick input.
@export var decelerate: bool ## Make character decelerate constantly.
@export var mult_deceleration_when_is_on_floor: int = 1
@export var horizontal_max_speed: int = 150
@export var horizontal_acceleration: int = 18 ## For accelerate and decelerate.


func _physics_process(delta):
	if decelerate:
		if character.is_on_floor():
			stop(mult_deceleration_when_is_on_floor)
		else:
			stop()


## Move horizontally according to input and stops when any is triggered.
func try_move() -> void:
	# Horizontal movement
	if input.left_joystick.horizontal_aprox_zero():
		stop()
	else:
		character.velocity.x = move_toward(character.velocity.x, input.left_joystick.get_horizontal_sign() * horizontal_max_speed, horizontal_acceleration)

## Stops horizontal movement.
func stop(mult: float = 1) -> void:
	character.velocity.x = move_toward(character.velocity.x, 0, horizontal_acceleration * mult)
