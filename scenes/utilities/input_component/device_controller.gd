@icon("res://icons/device_controller.png")
class_name DeviceController
extends InputComponent
## Component that allows the player to control any entity. It needs to be at the final of the sibling nodes.

## Specific device that is controlling this component. -2 is the keyboard.
@export var device: int = -2

func _physics_process(_delta: float) -> void:
	# Disable one tap buttons
	for button_name: StringName in buttons.keys():
		if buttons[button_name].released:
			buttons[button_name].released = false
		if buttons[button_name].pressed:
			buttons[button_name].pressed = false


func _input(event: InputEvent) -> void:
	# Select the specific device.
	if (
		(event.device == device and not event is InputEventKey)
		or (device == -2 and event is InputEventKey)
	):
		# Buttons.
		for action in action_buttons:
			if event.is_action(action):
				if event.is_pressed():
					if not buttons[action].pressing:
						buttons[action].pressed = true
						buttons[action].pressing = true
				if event.is_released():
					buttons[action].released = true
					buttons[action].pressing = false

		# Joysticks.
		left_joystick.value.x = _update_direction(event, left_joystick.value.x, action_left, action_right)
		left_joystick.value.y = _update_direction(event, left_joystick.value.y, action_up, action_down)
		right_joystick.value.x = _update_direction(event, right_joystick.value.x, second_action_left, second_action_up)
		right_joystick.value.y = _update_direction(event, right_joystick.value.y, second_action_up, second_action_down)


## Update a axis.
func _update_direction(event: InputEvent, actual_value: float, negative_action: StringName, positive_action: StringName) -> float:
	var value: float = actual_value
	if positive_action and negative_action:
		# Change axis value.
		if event.get_action_strength(negative_action) > 0:
			value = -1 * event.get_action_strength(negative_action)
			buttons[negative_action].pressed = true
			buttons[negative_action].pressing = true
		elif event.get_action_strength(positive_action) > 0:
			value = event.get_action_strength(positive_action)
			buttons[positive_action].pressed = true
			buttons[positive_action].pressing = true
		
		# Set release action.
		if event.is_action_released(negative_action) and value < 0:
			value = 0
			buttons[negative_action].released = true
			buttons[negative_action].pressing = false
		if event.is_action_released(positive_action) and value > 0:
			value = 0
			buttons[positive_action].released = true
			buttons[positive_action].pressing = false
	return value
