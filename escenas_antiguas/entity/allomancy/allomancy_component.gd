class_name AllomancyComponent
extends Node2D

enum Power {
	IRON,
	STEEL
}

@export var entity: CharacterBody2D
@export var first_power: AllomancyPower
@export var second_power: AllomancyPower
@export var input: InputComponent
@export var entity_weight: float = 50

var area_amplitude: int = 60
var metal_bodies_found: Array[CharacterBody2D] = []

@onready var col_poly: CollisionPolygon2D = $CollisionPolygon2D
@onready var timer: Timer = $TimerDisableArea


func _ready() -> void:
	# Area collider config.
	visible = false
	col_poly.disabled = true
	col_poly.polygon[1].y = -1 * float(area_amplitude) / 2
	col_poly.polygon[2].y = float(area_amplitude) / 2


func _physics_process(_delta: float) -> void:
	if input.buttons["first_power"].pressed:
		first_power.use_power()
	if input.buttons["first_power"].pressing:
		first_power.using_power()
	if input.buttons["first_power"].released:
		first_power.release_power()
		
	if input.buttons["second_power"].pressed:
		second_power.use_power()
	if input.buttons["second_power"].pressing:
		second_power.using_power()
	if input.buttons["second_power"].released:
		second_power.release_power()


func get_metal_bodies() -> bool:
	metal_bodies_found.clear()
	col_poly.rotation = input.last_joystick_direction.angle()
	col_poly.disabled = false
	visible = true
	timer.start()
	await timer.timeout
	return not metal_bodies_found.is_empty()


func _on_timer_disable_area_timeout() -> void:
	col_poly.disabled = true
	visible = false


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		for child: Node in body.get_children():
			if child is MetalBodyComponent:
				metal_bodies_found.append(body)
