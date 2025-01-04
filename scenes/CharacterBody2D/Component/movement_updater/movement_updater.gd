@icon("res://icons/update_node.png")
class_name MovementUpdater
extends Node
## Node used on a CharacterBody2D to execute move_and_slide or
## move_and_collide methods and update its position through its
## velocity. All physic_process on other Nodes occures after this
## execution so for actions that need to be done before the update it's
## the pre_movement_updated signal.
@export var character: CharacterBody2D = get_parent() as CharacterBody2D
@export var collision_component: CollisionComponent

signal pre_movement_updated


func _physics_process(delta):
	pre_movement_updated.emit()
	if collision_component:
		collision_component.process_collisions(delta)
	else:
		character.move_and_slide()
