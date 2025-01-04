@icon("res://icons/collision.png")
class_name CollisionComponent
extends Node
## Component used for CharacterBody2D that models special collision interactions
## between bodies.
@export var character: CharacterBody2D = get_parent() as CharacterBody2D
@export var enable_physics_process: bool = false
@export var no_projectile_collisions_on_spawn: bool = true
@export var nailable_component: NailableComponent

@onready var no_projectile_collisions_timer = $NoProjectileCollisionsTimer


func _ready() -> void:
	# Just collide world when spawns.
	character.collision_mask = 1
	no_projectile_collisions_timer.start()


func _physics_process(delta: float) -> void:
	if enable_physics_process:
		process_collisions(delta)


func process_collisions(delta: float) -> void:
	var collision: KinematicCollision2D = character.move_and_collide(character.velocity * delta)
	if collision:
		# Collision with world.
		if collision.get_collider() is TileMapLayer:
			if (
				nailable_component 
				and not nailable_component.nailed
				and character.velocity.length() > nailable_component.min_velocity_lenght_to_nail
			):
				nailable_component.nailed = true

		# Change velocity on collision.
		for child in (collision.get_collider() as Node).get_children():
			if child is CollisionComponent:
				character.velocity = character.velocity * Vector2(collision.get_normal().y, collision.get_normal().x)
				return
		character.velocity = character.velocity.slide(collision.get_normal())


func _on_no_projectile_collisions_timer_timeout():
	character.collision_mask = 5
