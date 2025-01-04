@icon("res://icons/state.png")
class_name IdleCharacterAction
extends State

@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export_group("Components")
@export var input: InputComponent
@export var horizontal_movement: HorizontalMovement
@export_group("Actions")
@export var FALL: FallCharacterAction
@export var RUN: RunCharacterAction
@export var JUMP: JumpCharacterAction
@export var ROLL_JUMP: RollJumpCharacterAction
@export var DUCK: DuckCharacterAction
@export var SHOOT: ShootCharacterAction


func try_enter() -> bool:
	if (
		character.is_on_floor() 
		and character.velocity.y == 0 
		and input.left_joystick.horizontal_aprox_zero()
	):
		finished.emit(name)
		return true
	return false


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(name)


func physics_update(_delta: float) -> void:
	# Horizontal movement
	if horizontal_movement:
		horizontal_movement.try_move()
	
	# State change.
	if ROLL_JUMP and ROLL_JUMP.try_enter():
		return
	elif JUMP and JUMP.try_enter():
		return
	elif DUCK and DUCK.try_enter():
		return
	elif SHOOT and SHOOT.try_enter():
		return
	elif FALL and FALL.try_enter():
		return
	elif RUN and RUN.try_enter():
		return
	
