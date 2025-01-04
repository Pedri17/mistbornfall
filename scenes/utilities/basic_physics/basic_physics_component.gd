@icon("res://icons/basic_physics_component.png")
class_name BasicPhysicsComponent
extends Node

@export var entity: CharacterBody2D
@export var brake_lateral_acceleration: float = 5
@export var nailable_component: NailableComponent
@export var floor_sliding: bool = true

@onready var timer_to_start_fall: Timer = $TimerToStartFall

var nailed: bool = false


func _ready() -> void:
	entity.velocity = Vector2(0, 0)
