@icon("res://icons/state.png")
class_name RollJumpCharacterBehavior
extends State

@export var INPUT: StringName = "jump"
@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export var roll_jump_velocity: int = -250
@export_group("Components")
@export var input: InputComponent
@export var direction_controller: DirectionController
@export var horizontal_movement: HorizontalMovement
@export_group("Behaviors")
@export var IDLE: IdleCharacterBehavior
@export var FALL: FallCharacterBehavior
@export var WALL_JUMP: WallJumpCharacterBehavior

@onready var timer = $Timer

var can_do_roll_jump: bool = false


func _ready() -> void:
	direction_controller.direction_changed.connect(on_changed_direction)


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(name)
	
	character.velocity.y += roll_jump_velocity


func physics_update(_delta: float) -> void:
	# Horizontal movement
	if horizontal_movement:
		horizontal_movement.try_move()
	
	# State change
	if FALL and (not character.is_on_floor() and character.velocity.y > 10):
		finished.emit(FALL.name)
	elif (
		WALL_JUMP
		and (
			(WALL_JUMP.wall_raycast.is_colliding() or character.is_on_wall())
			and input.buttons[WALL_JUMP.INPUT].pressed
		)
	):
		finished.emit(WALL_JUMP.name)
	elif IDLE and character.is_on_floor():
		finished.emit(IDLE.name)


func on_changed_direction(_last_direction: int, _new_direction: int):
	if abs(character.velocity.x) >= horizontal_movement.run_max_speed * 0.5:
		can_do_roll_jump = true
		timer.start()


func _on_timer_timeout() -> void:
	can_do_roll_jump = false
