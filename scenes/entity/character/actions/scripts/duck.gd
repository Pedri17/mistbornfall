@icon("res://icons/state.png")
class_name DuckCharacterAction
extends State

@export var INPUT: StringName = "down"
@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export var second_animation_player: AnimationPlayer
@export var duck_jump_velocity: Vector2 = Vector2(350, -180)
@export_group("Components")
@export var input: InputComponent
@export var direction_controller: DirectionController
@export var horizontal_movement: HorizontalMovement
@export_group("Actions")
@export var IDLE: IdleCharacterAction
@export var RUN: RunCharacterAction
@export var FALL: FallCharacterAction
@export var LONG_JUMP: LongJumpCharacterAction


func _ready() -> void:
	direction_controller.direction_changed.connect(_on_direction_changed)


func try_enter() -> bool:
	if input.buttons[INPUT].pressing:
		finished.emit(name)
		return true
	return false


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(name)
	second_animation_player.play(name)


func physics_update(_delta: float) -> void:
	# Horizontal movement
	if horizontal_movement:
		horizontal_movement.stop()
	
	## Change state.
	if not input.buttons[INPUT].pressing:
		if RUN and RUN.try_enter():
			return
		elif IDLE and IDLE.try_enter():
			return
	if FALL and FALL.try_enter():
		return
	if LONG_JUMP and LONG_JUMP.try_enter():
		return


func _on_direction_changed(_last_direction: int, _new_direction: int) -> void:
	if get_parent().state == self:
		second_animation_player.play(name)
