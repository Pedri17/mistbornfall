@icon("res://icons/state.png")
class_name FallCharacterBehavior
extends State

@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export var second_animation_player: AnimationPlayer
@export_group("Components")
@export var input: InputComponent
@export var direction_controller: DirectionController
@export var horizontal_movement: HorizontalMovement
@export_group("Behaviors")
@export var IDLE: IdleCharacterBehavior
@export var JUMP: JumpCharacterBehavior 
@export var LEDGE_CLING: LedgeClingCharacterBehavior
@export var WALL_SLIDE: WallSlideCharacterBehavior

var LAND_ANIMATION: StringName = "Land"


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
	if IDLE and (character.is_on_floor() and character.velocity.y == 0):
		finished.emit(IDLE.name)
	elif (
		WALL_SLIDE 
		and character.is_on_wall() 
		and WALL_SLIDE.wall_raycast.is_colliding()
		and not input.left_joystick.horizontal_aprox_zero()
	):
		finished.emit(WALL_SLIDE.name)
	elif JUMP and JUMP.can_do_coyote_jump and input.buttons[JUMP.INPUT].pressed:
		finished.emit(JUMP.name)
