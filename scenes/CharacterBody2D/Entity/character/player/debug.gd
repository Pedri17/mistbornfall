extends Node

@onready var health_component = $"../HealthComponent"
@onready var state_machine = $"../StateMachine"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("test_1"):
		health_component.health = 1
		state_machine.change_state("Idle")
