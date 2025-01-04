class_name ShootAllomancerBehavior
extends State

@export var input: InputComponent
@export var shoot_input_name: StringName = "shoot"

var previous_state: String


func enter(previous_state_path: String, data := {}) -> void:
	input.buttons[shoot_input_name].start_pressing()
	previous_state = previous_state_path


func physics_update(_delta: float) -> void:
	# Go to last state
	finished.emit(previous_state)


func exit() -> void:
	input.buttons[shoot_input_name].stop_pressing()
