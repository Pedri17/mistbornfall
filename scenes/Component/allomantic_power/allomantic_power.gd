extends Node2D

@export var entity: Node2D
@export var INPUT_PUSH: StringName = "push"
@export var INPUT_PULL: StringName = "pull"
@export var input: InputComponent

@onready var area: Area2D = $Area2D
@onready var select_bodies_timer: Timer = $SelectBodiesTimer
@onready var collision_polygon: CollisionPolygon2D = $Area2D/CollisionPolygon2D

var selected_metal_bodies: Array[MetalBodyComponent]


func _physics_process(delta: float) -> void:
	# User inputs.
	if input.buttons[INPUT_PUSH].pressed:
		use_power()
	if input.buttons[INPUT_PUSH].pressing:
		using_power(1)
	if input.buttons[INPUT_PUSH].released:
		release_power()
	if input.buttons[INPUT_PULL].pressed:
		use_power()
	if input.buttons[INPUT_PULL].pressing:
		using_power(-1)
	if input.buttons[INPUT_PULL].released:
		release_power()


func use_power() -> void:
	collision_polygon.rotation = input.left_joystick.last_direction.angle()
	_clear_selected_metal_bodies()
	collision_polygon.disabled = false
	area.visible = true
	select_bodies_timer.start()
	await select_bodies_timer.timeout


func release_power() -> void:
	_clear_selected_metal_bodies()


func using_power(direction: int) -> void:
	for metal_body in selected_metal_bodies:
		if is_instance_valid(metal_body):
			metal_body.move(global_position, direction)


func _clear_selected_metal_bodies() -> void:
	for body: MetalBodyComponent in selected_metal_bodies:
		if is_instance_valid(body):
			body.unselect()
	selected_metal_bodies.clear()


func _on_area_2d_body_entered(body: Node) -> void:
	for component in body.get_children():
		if component is MetalBodyComponent:
			component.select(entity)
			selected_metal_bodies.append(component)


func _on_select_bodies_timer_timeout() -> void:
	collision_polygon.disabled = true
	area.visible = false
