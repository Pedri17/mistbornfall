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
	elif (
		WALL_JUMP 
		and input.left_joystick.get_horizontal_sign() == -direction_controller.direction
		and input.buttons[WALL_JUMP.INPUT].pressed
	):
		finished.emit(WALL_JUMP.name)
	elif JUMP and input.buttons[JUMP.INPUT].pressed:
		finished.emit(JUMP.name)


func exit():
	gravity.gravity_multiplier = 1