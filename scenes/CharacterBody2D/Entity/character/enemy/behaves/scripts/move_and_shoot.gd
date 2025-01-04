class_name MoveAndShootBehavior
extends State

@export var input: InputComponent
@export var wall_raycast: RayCast2D
@export var enemy_raycast: RayCast2D
@export var shoot_input_name: StringName = "shoot"
@export var SHOOT_BEHAVIOR: ShootAllomancerBehavior

@onready var timer = $Timer

var shoot_delay: float = 1
var can_shoot: bool = true

func enter(previous_state_path: String, data := {}) -> void:
	input.left_joystick.value.x = 1


func physics_update(_delta: float) -> void:
	if wall_raycast.is_colliding():
		input.left_joystick.value.x *= -1
	if SHOOT_BEHAVIOR and enemy_raycast.is_colliding() and can_shoot:
		timer.start(shoot_delay)
		can_shoot = false
		finished.emit(SHOOT_BEHAVIOR.name)


func _on_timer_timeout():
	can_shoot = true
