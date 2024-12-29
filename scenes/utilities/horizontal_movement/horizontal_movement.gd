class_name HorizontalMovement
extends Node

@export var input: InputComponent
@export var character: CharacterBody2D = owner as CharacterBody2D
@export var run_max_speed: int = 150
@export var run_acceleration: int = 18


## Move horizontally according to input and stops when any is triggered.
func try_move() -> void:
	# Horizontal movement
	if input.left_joystick.horizontal_aprox_zero():
		stop()
	else:
		character.velocity.x = move_toward(character.velocity.x, input.left_joystick.get_horizontal_sign() * run_max_speed, run_acceleration)

## Stops horizontal movement.
func stop() -> void:
	character.velocity.x = move_toward(character.velocity.x, 0, run_acceleration)
