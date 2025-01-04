@icon("res://icons/state.png")
class_name FallCharacterAction
extends State

@export var LAND_ANIMATION: StringName = "Land"
@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export var second_animation_player: AnimationPlayer
@export_group("Components")
@export var direction_controller: DirectionController
@export var horizontal_movement: HorizontalMovement
@export_group("Actions")
@export var IDLE: IdleCharacterAction
@export var RUN: RunCharacterAction
@export var JUMP: JumpCharacterAction 
@export var LEDGE_CLING: LedgeClingCharacterAction
@export var WALL_SLIDE: WallSlideCharacterAction
@export var SHOOT: ShootCharacterAction


func try_enter() -> bool:
	if not character.is_on_floor() and character.velocity.y > 15:
		finished.emit(name)
		return true
	return false


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(name)


func physics_update(delta: float) -> void:
	# Horizontal movement
	if horizontal_movement:
		horizontal_movement.try_move()
	
	# Play transformations.
	if character.is_on_floor() or character.velocity.y == 0:
		second_animation_player.play(LAND_ANIMATION)
	
	# State change.
	if WALL_SLIDE and WALL_SLIDE.try_enter():
		return
	elif JUMP and JUMP.can_do_coyote_jump and JUMP.try_enter():
		return
	elif SHOOT and SHOOT.try_enter():
		return
	elif IDLE and IDLE.try_enter():
		return
	elif RUN and RUN.try_enter():
		return
