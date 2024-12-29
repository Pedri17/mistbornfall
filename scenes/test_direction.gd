extends Label

@onready var character: CharacterBody2D = $"../Player"

func _process(delta):
	pass
	#text = str(character.velocity.y)

func _physics_process(delta) -> void:
	for child in character.get_children():
		if child is StateMachine:
			for state in child.get_children():
				if state is RollJumpCharacterBehavior:
					text = str(state.can_do_roll_jump)
