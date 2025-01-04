@icon("res://icons/rotation.png")
class_name RotationComponent
extends Node

@export var character: CharacterBody2D = owner as CharacterBody2D
@export var sync_rotation_with_velocity: bool = true

func _physics_process(delta: float) -> void:
	if sync_rotation_with_velocity and not character.velocity.is_zero_approx(): 
		character.rotation = character.velocity.angle()
