class_name DirectionController
extends Node
## Used for a controlled entity to determine the direction where is facing.
@export var input: InputComponent

signal direction_changed(last_direction: int, new_direction: int)

var direction: int = 1


func _physics_process(delta) -> void:
	if (
		input.left_joystick.get_horizontal_sign() != 0 
		and direction != input.left_joystick.get_horizontal_sign()
	):
		direction_changed.emit(direction, -direction)
		direction = input.left_joystick.get_horizontal_sign()
