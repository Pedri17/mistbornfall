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
@export var FALL: FallCharacterBehavior
@export var WALL_JUMP: WallJumpCharacterBehavior
@export var LEDGE_CLING: LedgeClingCharacterBehavior


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(name)


func physics_update(_delta: float) -> void:
	## Reduce gravity.
	if character.velocity.y > 0:
		character.velocity.y = character.velocity.y * wall_slide_velocity_mult
	
	## State change.
	if IDLE and character.is_on_floor():
		finished.emit(IDLE.name)
	elif FALL and not wall_raycast.is_colliding():
		finished.emit(FALL.name)
	elif WALL_JUMP and input.buttons[WALL_JUMP.INPUT].pressed:
		finished.emit(WALL_JUMP.name)
	elif LEDGE_CLING and (character.is_on_wall() and not LEDGE_CLING.face_raycast.is_colliding()):
		finished.emit(LEDGE_CLING.name)
