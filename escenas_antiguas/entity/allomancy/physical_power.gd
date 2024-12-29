class_name PhysicalPower
extends AllomancyPower

@export var is_steel_power: bool = false
@export var move_velocity: int = 25

var move_direction: int = 1

func _ready() -> void:
	if is_steel_power:
		move_direction = 1
	else:
		move_direction = -1


func use_power() -> bool:
	return await allomancy_component.get_metal_bodies()


func using_power() -> bool:
	var has_used_power: bool = false
	for metal_body: Node2D in allomancy_component.metal_bodies_found:
		if metal_body and is_instance_valid(metal_body):
			var metal_component: MetalBodyComponent
			var velocity_to_add: Vector2 = (
				metal_body.position.direction_to(allomancy_component.entity.position) 
				* move_velocity
				* move_direction
			)
			# Get metal component.
			for child in metal_body.get_children():
				if child is MetalBodyComponent:
					metal_component = child
			
			has_used_power = true
			metal_component.on_acceleration = true
			metal_body.velocity.x = move_toward(metal_body.velocity.x, metal_component.max_move_velocity, velocity_to_add.x)
			metal_body.velocity.y = move_toward(metal_body.velocity.y, metal_component.max_move_velocity, velocity_to_add.y)
	return has_used_power

func release_power() -> bool:
	# Get all saved metal bodies.
	for metal_body in allomancy_component.metal_bodies_found:
		if metal_body and is_instance_valid(metal_body):
			# Get metal component.
			var metal_component: MetalBodyComponent
			for child in metal_body.get_children():
				if child is MetalBodyComponent:
					metal_component = child
			# Set acceleration as false.
			metal_component.on_acceleration = false
	return true
