@icon("res://icons/basic_physics_component.png")
class_name GravityComponent
extends Node
## Apply gravity velocity to a CharacterBody2D, executes move_and_slide() and
## emits a signal when character is not in floor.
@export var character: CharacterBody2D
@export var restore_gravity_when_is_not_moving: bool = false
@export var gravity_multiplier: float = 1
@export var movement_updater: MovementUpdater

@onready var no_gravity_timer: Timer = $NoGravityTimer

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var no_gravity: bool = false
var _was_on_floor: bool = false

signal floor_changed ## Signal emitted when the character stops being on the floor.


func _ready():
	if movement_updater:
		movement_updater.pre_movement_updated.connect(on_pre_move_updated)


func _physics_process(delta: float) -> void:
	# Gravity
	if not character.is_on_floor() and not no_gravity:
		character.velocity.y += gravity * delta * gravity_multiplier
	
	# Check if character is not longer on the floor.
	if _was_on_floor != character.is_on_floor():
		floor_changed.emit()
	
	# Set gravity again if the projectile is not moving.
	if no_gravity and restore_gravity_when_is_not_moving and (
		abs(character.velocity.x) < 1
		and abs(character.velocity.y) < 1
	):
		no_gravity = false


func on_pre_move_updated() -> void:
	_was_on_floor = character.is_on_floor()


func make_not_fall(time: float) -> void:
	no_gravity = true
	no_gravity_timer.start(time)


func _on_no_gravity_timer_timeout() -> void:
	no_gravity = false
