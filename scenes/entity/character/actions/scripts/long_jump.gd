@icon("res://icons/state.png")
class_name LongJumpCharacterAction
extends State

@export var INPUT: StringName = "jump"
@export var DUCK_ANIMATION: StringName = "Duck"
@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export var duck_jump_velocity: Vector2 = Vector2(400, -130)
@export_group("Components")
@export var input: InputComponent
@export var direction_controller: DirectionController
@export_group("Actions")
@export var IDLE: IdleCharacterAction
@export var FALL: FallCharacterAction
@export var RUN: RunCharacterAction
@export var DUCK: DuckCharacterAction
@export var SHOOT: ShootCharacterAction


func try_enter() -> bool:
	if input.buttons[INPUT].pressed:
		finished.emit(name)
		return true
	return false


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(DUCK_ANIMATION)
	
	character.velocity.x = direction_controller.direction * duck_jump_velocity.x
	character.velocity.y = duck_jump_velocity.y


func physics_update(_delta: float) -> void:
	## State change.
	if SHOOT and SHOOT.try_enter():
		return
	elif FALL and FALL.try_enter():
		return
	elif RUN and RUN.try_enter():
		return
	elif IDLE and IDLE.try_enter():
		return
