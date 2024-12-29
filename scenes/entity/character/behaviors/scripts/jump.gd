@icon("res://icons/state.png")
class_name JumpCharacterBehavior
extends State

@export var INPUT: StringName = "jump" 
@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export_group("Components")
@export var input: InputComponent
@export var gravity: GravityComponent
@export var horizontal_movement: HorizontalMovement
@export_group("Behaviors")
@export var IDLE: IdleCharacterBehavior
@export var FALL: FallCharacterBehavior
@export var WALL_JUMP: WallJumpCharacterBehavior
@export var WALL_SLIDE: WallSlideCharacterBehavior
@export_group("Movement configuration")
@export var standart_jump_velocity: int = -150
@export var high_jump_max_height: int = -300
@export var high_jump_acceleration: int = -20

@onready var coyote_jump_timer = $CoyoteJumpTimer

var actual_high_jump_height: int = 0
var can_do_coyote_jump: bool = false


func _ready() -> void:
	gravity.floor_changed.connect(_on_floor_changed)


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(name)
	
	character.velocity.y = standart_jump_velocity
	actual_high_jump_height = standart_jump_velocity
	

func physics_update(_delta: float) -> void:
	# Horizontal movement
	if horizontal_movement:
		horizontal_movement.try_move()
	
	# High Jump.
	if (
		actual_high_jump_height > high_jump_max_height
		and input.buttons[INPUT].pressing
	):
		# Make sure just jump the maximun height
		if actual_high_jump_height + high_jump_acceleration < high_jump_max_height:
			character.velocity.y += high_jump_max_height - actual_high_jump_height
			actual_high_jump_height += high_jump_max_height - actual_high_jump_height
		else:
			character.velocity.y += high_jump_acceleration
			actual_high_jump_height += high_jump_acceleration

	## State change.
	if FALL and (not input.buttons[INPUT].pressing and character.velocity.y > 10):
		finished.emit(FALL.name)
	elif WALL_JUMP and (
		WALL_JUMP.wall_raycast.is_colliding()
		and input.buttons[WALL_JUMP.INPUT].pressed
	):
		finished.emit(FALL.name)
	elif WALL_SLIDE and (
		WALL_SLIDE.wall_raycast.is_colliding()
		and character.is_on_wall()
		and not input.left_joystick.horizontal_aprox_zero()
	):
		finished.emit(WALL_SLIDE.name)
	elif IDLE and character.is_on_floor():
		finished.emit(IDLE.name)


func _on_coyote_jump_timer_timeout() -> void:
	can_do_coyote_jump = false


func _on_floor_changed() -> void:
	can_do_coyote_jump = true
	coyote_jump_timer.start()