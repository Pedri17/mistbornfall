class_name PlatformAreaComponent
extends AnimatableBody2D


@export var enable: bool = true
@export var enable_on_nail: bool = false
@export var nailable_component: NailableComponent

var default_collision_layer: int
var col_shape: CollisionShape2D

@onready var raycast_left: RayCast2D = $RaycastLeft
@onready var raycast_right: RayCast2D = $RaycastRight


func _ready() -> void:
	default_collision_layer = collision_layer
	
	for child in get_children():
		if child is CollisionShape2D:
			col_shape = child
	
	# Raycast size to shape size.
	var size: float = col_shape.shape.get_rect().size.x / 2 + 2
	raycast_left.target_position.x = -1 * size
	raycast_right.target_position.x = size
	
	if not enable:
		collision_layer = 0


func _process(_delta: float) -> void:
	# Change enable/disable mode.
	if enable:
		collision_layer = default_collision_layer
	else:
		collision_layer = 0
	
	
	if not enable and enable_on_nail and nailable_component and nailable_component.nailed:
		enable = true
		if col_shape.one_way_collision:
			# Rotate to be always one way to down.
			if abs(global_rotation_degrees) > 90 and col_shape.rotation_degrees != 180:
				col_shape.rotation_degrees = 180
			
			# Disable if there's not a wall at right and left.
			raycast_left.global_rotation_degrees = 0
			raycast_right.global_rotation_degrees = 0
			raycast_left.force_raycast_update()
			raycast_right.force_raycast_update()
			if not raycast_left.is_colliding() and not raycast_right.is_colliding():
				enable = false
