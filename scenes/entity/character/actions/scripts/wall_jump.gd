@icon("res://icons/state.png")
class_name WallJumpCharacterAction
extends State

@export var INPUT: StringName = "jump"
@export var ANIMATION_JUMP: StringName = "Jump"
@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export var wall_raycast: RayCast2D ## RayCast2D used by the character to collide on the wall in front of him.
@export var wall_jump_velocity: Vector2 = Vector2(-100, -300)
@export_group("Components")
@export var input: InputComponent
@export var direction_controller: DirectionController
@export_group("Actions")
@export var IDLE: IdleCharacterAction
@export var RUN: RunCharacterAction
@export var JUMP: JumpCharacterAction
@export var FALL: FallCharacterAction


func try_enter() -> bool:
	if input.buttons[INPUT].pressed and wall_raycast.is_colliding():
		finished.emit(name)
		return true
	return false


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(ANIMATION_JUMP)
	
	character.velocity.y += wall_jump_velocity.y
	character.velocity.x += wall_jump_velocity.x * direction_controller.direction
	

func physics_update(_delta: float) -> void:
	## State change.
	if FALL and not input.buttons[INPUT].pressing:
		finished.emit(FALL.name)
		return
	elif FALL and FALL.try_enter():
		return
	elif RUN and RUN.try_enter():
		return
	elif IDLE and IDLE.try_enter():
		return
