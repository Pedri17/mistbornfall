@icon("res://icons/collision.png")
class_name CollisionComponent
extends Node
## Component used for CharacterBody2D that models special collision interactions
## between bodies.
@export var character: CharacterBody2D = get_parent() as CharacterBody2D
@export var enable_physics_process: bool = false


func _physics_process(delta: float) -> void:
	if enable_physics_process:
		process_collisions(delta)


func process_collisions(delta: float) -> void:
	var collision: KinematicCollision2D = character.move_and_collide(character.velocity * delta)
	if collision:
		for child in (collision.get_collider() as Node).get_children():
			if child is CollisionComponent:
				#print(owner.name
					#+"- vel: "+str(character.velocity)
					#+", nor: "+str(collision.get_normal())
					#+", angle: "+str(collision.get_angle())
					#+", res: "+str(character.velocity)
				#)
				character.velocity = character.velocity * Vector2(collision.get_normal().y, collision.get_normal().x)
				return
		character.velocity = character.velocity.slide(collision.get_normal())
