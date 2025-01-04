@icon("res://icons/input_component.png")
class_name InputComponent
extends Node
## Base component for controlling any object.
##
## Provides all the basic controlls that any entity will have, It should be
## extended to be controlled by the player or the AI.

## All the Input Maps that will controll the buttons
@export var action_buttons: Array[StringName] = [] 
@export_group("Left Joystick") ## Left joystick
@export var action_left: StringName ## Input Map for right joystick to left direction
@export var action_right: StringName ## Input Map for right joystick to right direction
@export var action_up: StringName ## Input Map for right joystick to up direction
@export var action_down: StringName ## Input Map for right joystick to down direction
@export_group("Right Joystick") ## Right joystick
@export var second_action_left: StringName ## Input Map for left joystick to left direction
@export var second_action_right: StringName ## Input Map for left joystick to right direction
@export var second_action_up: StringName ## Input Map for left joystick to up direction
@export var second_action_down: StringName ## Input Map for left joystick to down direction

var left_joystick := _VirtualJoystick.new() ## Left joystick axis.
var right_joystick := _VirtualJoystick.new() ## Right joystick axis.
var buttons: Dictionary = {} ## All the recorded buttons.


func _ready() -> void:
	# Buttons.
	for action_button in action_buttons:
		buttons[action_button] = _VirtualButton.new()

	# Joysticks.
	var joystick_action_names: Array[StringName] = [
		action_left,
		action_right,
		action_up,
		action_down,
		second_action_left,
		second_action_right,
		second_action_up,
		second_action_down,
	]

	for this_action: StringName in joystick_action_names:
		if this_action:
			buttons[this_action] = _VirtualButton.new()


func _physics_process(delta):
	# Disable one tap buttons
	for button_name: StringName in buttons.keys():
		if buttons[button_name].released:
			buttons[button_name].released = false
		if buttons[button_name].pressed:
			buttons[button_name].pressed = false
	
	# Set joystick last directions.
	if abs(left_joystick.value.x) + abs(left_joystick.value.y) > 0.3:
		left_joystick.last_direction = left_joystick.value
	if abs(right_joystick.value.x) + abs(right_joystick.value.y) > 0.3:
		right_joystick.last_direction = right_joystick.value


## Information about how a button is pressed.
class _VirtualButton:
	var pressed: bool = false
	var pressing: bool = false
	var released: bool = false
	
	func set_pressed():
		pressed = true
		released = true
	
	func start_pressing():
		pressed = true
		pressing = true
	
	func stop_pressing():
		released = true
		pressing = false


class _VirtualJoystick:
	var value := Vector2.ZERO
	var last_direction := Vector2.ZERO ## Last direction pointing that is not zero.
	var _horizontal_sign: int = 0:
		get():
			return _to_sign(value.x)
	var _vertical_sign: int = 0:
		get():
			return _to_sign(value.y)
	
	## Transforms a float axis to their sign (1, -1, or 0).
	func _to_sign(val: float) -> int:
		if is_zero_approx(val):
			return 0
		elif val > 0:
			return 1
		else:
			return -1
	
	func get_horizontal_sign() -> int:
		return _horizontal_sign

	func get_vertical_sign() -> int:
		return _vertical_sign
	
	func aprox_zero() -> bool:
		return value.is_zero_approx()
	
	func horizontal_aprox_zero() -> bool:
		return get_horizontal_sign() == 0
	
	func vertical_aprox_zero() -> bool:
		return get_vertical_sign() == 0
