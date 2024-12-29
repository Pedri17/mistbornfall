class_name DamageArea
extends Area2D


@export var projectile_component: ProjectileComponent ## Optional, enables projectile hit logic
@export var entity: CharacterBody2D ## Optional if is a projectile
@export var min_velocity_to_kill: int = 10

 
func _on_body_entered(body: Node2D) -> void:
	# Mirar el velocity.x lo puse porque da error
	if not projectile_component or entity.velocity.x >= min_velocity_to_kill:
		for child in body.get_children():
			if child is HurtComponent:
				child.hurted()
