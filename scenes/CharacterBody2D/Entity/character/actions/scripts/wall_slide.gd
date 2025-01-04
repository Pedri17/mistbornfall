@icon("res://icons/state.png")
class_name WallSlideCharacterAction
extends State

@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export var wall_slide_velocity_mult: float = 0.75
@export var wall_raycast: RayCast2D ## RayCast2D used by the character to collide on the wall in front of him.
@export_group("Components")
@export var input: InputComponent
@export_group("Actions")
@export var IDLE: IdleCharacterAction
@export var RUN: RunCharacterAction
@export var FALL: FallCharacterAction
@export var WALL_JUMP: WallJumpCharacterAction
@export var LEDGE_CLING: LedgeClingCharacterAction


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
	if WALL_JUMP and WALL_JUMP.try_enter():
		return
	elif LEDGE_CLING and (
		wall_raycast.is_colliding() 
		and not LEDGE_CLING.face_raycast.is_colliding()
	):
		finished.emit(LEDGE_CLING.name)
		return
	elif IDLE and IDLE.try_enter():
		return
	if RUN and RUN.try_enter():
		return
	elif FALL and not wall_raycast.is_colliding():
		finished.emit(FALL.name)
		return
	
	
