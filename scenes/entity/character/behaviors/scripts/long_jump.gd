@icon("res://icons/state.png")
class_name LongJumpCharacterBehavior
extends State

@export var INPUT: StringName = "jump"
@export var DUCK_ANIMATION: StringName = "Duck"
@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export var duck_jump_velocity: Vector2 = Vector2(400, -130)
@export_group("Components")
@export var input: InputComponent
@export var direction_controller: DirectionController
@export_group("Behaviors")
@export var IDLE: IdleCharacterBehavior
@export var FALL: FallCharacterBehavior
@export var RUN: RunCharacterBehavior
@export var DUCK: DuckCharacterBehavior


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
	if FALL and FALL.try_enter():
		return
	if RUN and RUN.try_enter():
		return
	if IDLE and IDLE.try_enter():
		return
