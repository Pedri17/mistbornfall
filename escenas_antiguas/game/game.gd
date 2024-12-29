extends Node2D


@onready var label: Label = $Label
@onready var player: Player = $Player

#var input: InputComponent
#
#func _process(_delta: float) -> void:
	#for child in player.get_children():
		#if child is InputComponent:
			#input = child
	#
	#label.text = (
		#"InputDownPressing: " + str(input.buttons["move_down"].pressing) + "\n" 
		#+ "InputDownPressed: " + str(input.buttons["move_down"].pressed) + "\n" 
		#+ "InputDownReleased: " + str(input.buttons["move_down"].released) + "\n"
		#+ "InputJoystick: " + str(input.joystick) + "\n" 
	#)
