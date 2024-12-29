class_name ShootComponent
extends Node2D

@export var entity: Node
@export var inventory_component: InventoryComponent
@export var input: InputComponent
@export var movement_component: MovementComponent
@export var default_item: Item ## Optional, if there's not a InventoryComponent it will shoot that Item.

var is_ducking: bool = false
var is_shooting: bool = false
var entity_motion := Vector2(0, 0)

@onready var spr_arrow: Sprite2D = $SprArrow


func _ready() -> void:
	spr_arrow.visible = false


func _physics_process(_delta: float) -> void:
	if movement_component != null:
		is_ducking = movement_component.is_ducking

	if entity != null:
		entity_motion = entity.get_real_velocity()
	
	if(
		inventory_component == null
		or not inventory_component.is_empty()
	):
		# Pulse shoot button
		if (
			not is_shooting 
			and not is_ducking 
			and input.buttons["shoot"].pressed
		):
			is_shooting = true
		
		# While player is shooting
		if is_shooting:
			spr_arrow.visible = true

		# Release button when is shooting
		if is_shooting and input.buttons["shoot"].released:
			is_shooting = false
			if inventory_component:
				shoot_projectile(inventory_component.remove_actual())
			else:
				shoot_projectile(default_item)
		
		# Player stops shooting
		if not is_shooting:
			spr_arrow.visible = false

	spr_arrow.rotation = input.last_joystick_direction.angle()


func shoot_projectile(item: Item) -> void:
	var projectile: Node2D = load(item.entity_scene_path).instantiate()
	get_node("/root").add_child(projectile)
	projectile.visible = false
	for child in projectile.get_children():
		if child is ProjectileComponent:
			child.shoot(
				entity,
				entity.position,
				input.last_joystick_direction.normalized() + entity.get_real_velocity() / Engine.physics_ticks_per_second * 0.1
			)
