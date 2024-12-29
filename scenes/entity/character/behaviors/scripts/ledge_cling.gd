@icon("res://icons/state.png")
class_name LedgeClingCharacterBehavior
extends State

@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export var second_animation_player: AnimationPlayer
@export var WALL_SLIDE_ANIMATION = "WallSlide"
@export var face_raycast: RayCast2D ## RayCast2D at the front of the face of the character to check that is on a ledge.
@export_group("Components")
@export var input: InputComponent
@export var direction_controller: DirectionController
@export var gravity: GravityComponent
@export_group("Behaviors")
@export var JUMP: JumpCharacterBehavior
@export var FALL: FallCharacterBehavior
@export var WALL_JUMP: WallJumpCharacterBehavior

var ledge_direction: int = 1


func try_enter() -> bool:
	if character.is_on_wall() and not face_raycast.is_colliding():
		finished.emit(name)
		return true
	return false


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(WALL_SLIDE_ANIMATION)
	second_animation_player.play(name)
	gravity.gravity_multiplier = 0
	character.velocity = Vector2.ZERO
	ledge_direction = direction_controller.direction


func physics_update(_delta: float) -> void:
	character.velocity = Vector2.ZERO

	# State change.
	if FALL and input.left_joystick.get_horizontal_sign() != ledge_direction:
		finished.emit(FALL.name)
		return
	elif WALL_JUMP and WALL_JUMP.try_enter():
		return
	if JUMP and JUMP.try_enter():
		return


func exit():
	gravity.gravity_multiplier = 1
