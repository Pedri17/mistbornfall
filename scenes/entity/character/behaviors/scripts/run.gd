@icon("res://icons/state.png")
class_name RunCharacterBehavior
extends State

@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export var input: InputComponent
@export var horizontal_movement: HorizontalMovement
@export_group("Behaviors")
@export var IDLE: IdleCharacterBehavior
@export var FALL: FallCharacterBehavior
@export var JUMP: JumpCharacterBehavior
@export var DUCK: DuckCharacterBehavior
@export var ROLL_JUMP: RollJumpCharacterBehavior


func try_enter() -> bool:
	if character.is_on_floor() and not input.left_joystick.horizontal_aprox_zero():
		finished.emit(name)
		return true
	return false


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(name)


func physics_update(_delta: float) -> void:
	# Horizontal movement
	horizontal_movement.try_move()
	
	# State change.
	if FALL and FALL.try_enter():
		return
	if ROLL_JUMP and ROLL_JUMP.try_enter():
		return
	if JUMP and JUMP.try_enter():
		return
	if IDLE and IDLE.try_enter():
		return
	if DUCK and DUCK.try_enter():
		return
