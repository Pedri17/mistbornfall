@icon("res://icons/metal_body.png")
class_name MetalBodyComponent
extends Node2D

@export var entity: CharacterBody2D
@export var entity_sprite: Sprite2D
@export var gravity_component: GravityComponent

@export var weight: float = 1
@export var is_movable: bool = true
@export var damage_on_acceleration: bool = false
@export var nailable_on_acceleration: bool = false


@onready var sprite: Sprite2D = $Sprite2D

var move_velocity: int = 25
@export var max_move_velocity: int = 1000

var touching_wall: bool = false
var on_acceleration: bool = false
var selected_by: Array[Node2D]


func select(selected_by_entity: Node2D) -> void:
	# Append entity that is selecting this metal body.
	selected_by.append(selected_by_entity)
	
	# Change color for selection.
	for component in selected_by_entity.get_children():
		if component is ColorComponent:
			entity_sprite.material.set("shader_parameter/outline_color", component.main_color)
	
	gravity_component.no_gravity = true


func unselect() -> void:
	entity_sprite.material.set("shader_parameter/outline_color", Color.BLACK)
	gravity_component.no_gravity = false


func move(from_entity_center_position: Vector2, direction: int = 1) -> void:
	var velocity_to_add: Vector2 = (
		from_entity_center_position.direction_to(entity.position) 
		* move_velocity
		* direction
	)
	entity.velocity.x = move_toward(entity.velocity.x, max_move_velocity, velocity_to_add.x)
	entity.velocity.y = move_toward(entity.velocity.y, max_move_velocity, velocity_to_add.y)
	
