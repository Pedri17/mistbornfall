class_name NailableComponent
extends Area2D

@export var entity: CharacterBody2D
@export var min_velocity_to_nail: int = 0
@export var nail_on_shot: bool = false
@export var projectile: ProjectileComponent
@export var metal_body_component: MetalBodyComponent

var nailed: bool = false


func set_nailed() -> void:
	nailed = true


func set_unnailed() -> void:
	nailed = false


func _on_body_entered(_body: Node2D) -> void:
	if not nailed and entity.velocity.length() >= min_velocity_to_nail:
		if not nail_on_shot or (projectile and projectile.is_shooted):
			if (
				(not metal_body_component or not metal_body_component.nailable_on_acceleration)
				or (metal_body_component.nailable_on_acceleration 
					and metal_body_component.on_acceleration)
			):
				set_nailed()
