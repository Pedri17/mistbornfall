@icon("res://icons/state.png")
class_name IdleCharacterBehavior
extends State

@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export_group("Components")
@export var input: InputComponent
@export var horizontal_movement: HorizontalMovement
@export_group("Behaviors")
@export var FALL: FallCharacterBehavior
@export var RUN: RunCharacterBehavior
@export var JUMP: JumpCharacterBehavior
@export var ROLL_JUMP: RollJumpCharacterBehavior
@export var DUCK: DuckCharacterBehavior
@export var SHOOT: ShootCharacterBehavior


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(name)


func physics_update(_delta: float) -> void:
	# Horizontal movement
	if horizontal_movement:
		horizontal_movement.try_move()
	
	# State change.
	if FALL and (not character.is_on_floor() and character.velocity.y > 10):
		finished.emit(FALL.name)
	elif RUN and not input.left_joystick.horizontal_aprox_zero():
		finished.emit(RUN.name)
	elif (
		ROLL_JUMP 
		and ROLL_JUMP.can_do_roll_jump 
		and input.buttons[ROLL_JUMP.INPUT].pressed
	):
		finished.emit(ROLL_JUMP.name)
	elif JUMP and input.buttons[JUMP.INPUT].pressed:
		finished.emit(JUMP.name)
	elif DUCK and input.buttons[DUCK.INPUT].pressing:
		finished.emit(DUCK.name)
	elif SHOOT and input.buttons[SHOOT.INPUT].pressing:
		SHOOT.try_enter()
