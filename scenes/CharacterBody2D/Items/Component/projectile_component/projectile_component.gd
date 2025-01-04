@icon("res://icons/icon_bullet.png")
class_name ProjectileComponent
extends Node
## Adds to a node the capacity to being shot.
##
## It needs a RigidBody2D to control the physics and a Item that defines
## its characteristics in a inventory.
@export var entity: CharacterBody2D
@export var item: Item ## Item node that defines its characteristics in a inventory.
@export var gravity_component: GravityComponent
@export_range(0,10) var no_gravity_time: float = 0.3  ## Time until starts falling after being shot.
@export var shoot_velocity: int = 300

var is_shot: bool = false
var shot_by: Node
var time_to_visible: int = -1


func _ready() -> void:
	if entity == null and get_parent() is CharacterBody2D:
		entity = get_parent()
	
	if entity == null:
		printerr(owner.name + "." + name + ": CharacterBody2D not found.")


func _physics_process(_delta: float) -> void:
	if entity:
		if time_to_visible > 0:
			time_to_visible -= 1
		
		if time_to_visible == 0:
			entity.visible = true
			time_to_visible = -1


func shoot(shooter_entity: Node, position: Vector2, direction: Vector2, impulse: Vector2) -> void:
	is_shot = true
	shot_by = shooter_entity
	entity.position = position
	
	# Use character motion velocity when is higher than shoot_velocity.
	var base_velocity := Vector2(direction * shoot_velocity)
	var motion_velocity := Vector2((direction + impulse) * shoot_velocity)
	if base_velocity.length() > motion_velocity.length():
		entity.velocity = base_velocity
	else:
		entity.velocity = motion_velocity
	
	entity.rotate(entity.velocity.angle())
	time_to_visible = 2
	
	if gravity_component:
		gravity_component.make_not_fall(no_gravity_time)
