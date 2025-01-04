@icon("res://icons/metal_body.png")
class_name MetalBodyComponent
extends Node

@export var entity: CharacterBody2D
@export var weight: float = 1
@export var is_movable: bool = true
@export var damage_on_acceleration: bool = false
@export var nailable_on_acceleration: bool = false
@export var max_move_velocity: int = 1000

var touching_wall: bool = false
var on_acceleration: bool = false
