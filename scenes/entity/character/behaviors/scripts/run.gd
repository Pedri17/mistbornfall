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


func try_enter() -> void:
	if character.is_on_floor() and not input.left_joystick.horizontal_aprox_zero():
		finished.emit(name)

func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(name)


func physics_update(_delta: float) -> void:
	# Horizontal movement
	horizontal_movement.try_move()
	
	# State change.
	if FALL and (not character.is_on_floor() and character.velocity.y > 10):
		finished.emit(FALL.name)
	elif (
		ROLL_JUMP 
		and ROLL_JUMP.can_do_roll_jump 
		and input.buttons[ROLL_JUMP.INPUT].pressed
	):
		finished.emit(ROLL_JUMP.name)
	elif JUMP and input.buttons[JUMP.INPUT].pressed:
		finished.emit(JUMP.name)
	elif IDLE and input.left_joystick.horizontal_aprox_zero():
		finished.emit(IDLE.name)
	elif DUCK and input.buttons[DUCK.INPUT].pressing:
		finished.emit(DUCK.name)
