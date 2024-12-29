@icon("res://icons/basic_physics_component.png")
class_name BasicPhysicsComponent
extends Node

@export var entity: CharacterBody2D
@export var brake_lateral_acceleration: float = 5
@export var base_gravity_multiplier: float = 1
@export var nailable_component: NailableComponent
@export var floor_sliding: bool = true

@onready var timer_to_start_fall = $TimerToStartFall

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity") * base_gravity_multiplier
var no_gravity: bool = false
var nailed: bool = false


func _ready() -> void:
	entity.velocity = Vector2(0, 0)


func _physics_process(delta: float) -> void:
	if entity and (not nailable_component or not nailable_component.nailed):
		# Set gravity.
		if not entity.is_on_floor() and not no_gravity:
			entity.velocity.y += gravity * delta

		# Brake lateral movement.
		if entity.is_on_floor():
			entity.velocity.x = move_toward(entity.velocity.x, 0, 2 * brake_lateral_acceleration)
		else:
			entity.velocity.x = move_toward(entity.velocity.x, 0, brake_lateral_acceleration)

		# Change rotation on velocity.
		if not entity.velocity.is_zero_approx() and not nailed:
			# Set floor sliding.
			if floor_sliding and entity.is_on_floor():
				if entity.velocity.x > 0:
					entity.rotation_degrees = 0
				else:
					entity.rotation_degrees = 180
			else:	
				if not nailed:
					entity.rotation = entity.get_real_velocity().angle()
		
		# Set gravity again if the projectile is not moving.
		if(
			no_gravity and (
				abs(entity.velocity.x) < 1
				and abs(entity.velocity.y) < 1
			)
		):
			no_gravity = false
		
		entity.move_and_slide()


func make_not_fall(time: float) -> void:
	no_gravity = true
	timer_to_start_fall.start(time)


func _on_timer_to_start_fall_timeout():
	no_gravity = false
