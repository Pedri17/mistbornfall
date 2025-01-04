extends Label

@onready var character: CharacterBody2D = $"../Player"
@onready var allomancer = $"../Allomancer"

func _ready() -> void:
	for child in character.get_children():
		if child is StateMachine:
			child.connect_finished_signal(change_state)
			

func change_state(name: String):
	text = name + "\nVelocity: " + str(character.velocity)
