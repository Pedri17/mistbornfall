@icon("res://icons/state.png")
class_name WallJumpCharacterBehavior
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
@export_group("Behaviors")
@export var IDLE: IdleCharacterBehavior
@export var JUMP: JumpCharacterBehavior
@export var FALL: FallCharacterBehavior


func try_enter() -> void:
	if input.buttons[INPUT].pressed and wall_raycast.is_colliding():
		finished.emit(name)


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(ANIMATION_JUMP)
	
	character.velocity.y += wall_jump_velocity.y
	character.velocity.x += wall_jump_velocity.x * direction_controller.direction
	

func physics_update(_delta: float) -> void:
	## State change.
	if FALL and (not input.buttons[INPUT].pressing and character.velocity.y > 10):
		finished.emit(FALL.name)
	elif IDLE and character.is_on_floor():
		finished.emit(IDLE.name)
