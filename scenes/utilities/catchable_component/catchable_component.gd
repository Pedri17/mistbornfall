@icon("res://icons/catchable_component.png")
class_name CatchableComponent
extends Node
## Adds to a node the capacity to be caught.

@export var time_uncatchable: float = 0 ## Time after spawning in which it cannot be caught.
@export var item: Item
@export var catchArea: Area2D
@export var uncatchable_on_nail: bool = false ## Optional
@export var nailable_component: NailableComponent ## Optional
@export var projectile_component: ProjectileComponent ## Optional

@onready var timer_to_catch: Timer = $TimerToCatch

func _ready() -> void:
	catchArea.body_entered.connect(_on_body_entered)
	if time_uncatchable > 0:
		timer_to_catch.start(time_uncatchable)


func _try_take_item(entity: Node, inventory: InventoryComponent) -> bool:
	# Catchable on nail.
	if not uncatchable_on_nail or (nailable_component and not nailable_component.nailed):
		# Projectile only can be taken by the shooter
		if not projectile_component or (projectile_component 
				and (projectile_component.shooted_by == null or projectile_component.shooted_by == entity
		)):
			# Take item if there's space.
			if inventory.try_add(item.duplicate()):
				get_parent().queue_free()
				return true
	return false

func _on_body_entered(body: Node2D) -> void:
	if timer_to_catch.time_left == 0:
		for child in body.get_children():
			if child is InventoryComponent:
				_try_take_item(body, child)
