@icon("res://icons/state.png")
class_name WallSlideCharacterBehavior
extends State

@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export var wall_slide_velocity_mult: float = 0.75
@export var wall_raycast: RayCast2D ## RayCast2D used by the character to collide on the wall in front of him.
@export_group("Components")
@export var input: InputComponent
@export_group("Behaviors")
@export var IDLE: IdleCharacterBehavior
@export var RUN: RunCharacterBehavior
@export var FALL: FallCharacterBehavior
@export var WALL_JUMP: WallJumpCharacterBehavior
@export var LEDGE_CLING: LedgeClingCharacterBehavior


func try_enter() -> bool:
	if (
		character.is_on_wall() 
		and wall_raycast.is_colliding() 
		and not input.left_joystick.horizontal_aprox_zero()
	):
		finished.emit(name)
		return true
	return false

func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(name)


func physics_update(_delta: float) -> void:
	## Reduce gravity.
	if character.velocity.y > 0:
		character.velocity.y = character.velocity.y * wall_slide_velocity_mult
	
	## State change.
	if IDLE and IDLE.try_enter():
		return
	if RUN and RUN.try_enter():
		return
	elif FALL and not wall_raycast.is_colliding():
		finished.emit(FALL.name)
		return
	elif WALL_JUMP and WALL_JUMP.try_enter():
		return
	elif LEDGE_CLING and LEDGE_CLING.try_enter():
		return
