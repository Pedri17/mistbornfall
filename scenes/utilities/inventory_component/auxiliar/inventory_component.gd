@icon("res://icons/inventory_component.png")
class_name InventoryComponent
extends Node2D
## Adds to a entity the capacity of store items.
## 
## The slot can be rolled by a InputComponent

## Total number of spaces that fit on this inventory.
@export var max_spaces: int = 21 ## Spaces of items that the entity can store, each item can have different spaces' weight.
@export var input_component: InputComponent ## Optional, input component that triggers roll the slot.
@export var roll_slot_action: StringName = "roll_slot" ## Optional, InputMap name required if has the InputComponent

signal inventory_updated

var actual_slot: int = 0
var items: Array[Item] = []
var slots: Dictionary = {}

var total_metalic_weight: int = 0
var total_weight: float = 0
var total_spaces: int = 0
var total_items: int = 0


func _physics_process(_delta: float) -> void:
	if input_component != null and input_component.buttons[roll_slot_action].pressed:
		roll_slot()


func is_empty() -> bool:
	return total_items == 0


func get_item(resource_path: String) -> Item:
	for item in items:
		if item.entity_scene_path == resource_path:
			return item
	return null


func try_add(item: Item) -> bool:
	# Inventory have enough spaces to take the item.
	if total_spaces + item.spaces <= max_spaces:
		# Add item to total values. 
		total_spaces += item.spaces
		total_metalic_weight += item.metalic_weight
		total_weight += item.weight
		total_items += 1

		# Update dictionary and array.
		if slots.has(item.entity_scene_path):
			slots[item.entity_scene_path] += 1
		else:
			items.append(item)
			slots[item.entity_scene_path] = 1

		# Update displayer.
		inventory_updated.emit()
		return true
	else:
		return false


func remove_actual() -> Item:
	# If has any item.
	if not slots.is_empty():
		var to_remove_name: String = slots.keys()[actual_slot]
		var to_remove_item: Item = null
		var i: int = 0
		# Get item to remove.
		while to_remove_item == null and i < items.size():
			if items[i].entity_scene_path == to_remove_name:
				to_remove_item = items[i]
			i += 1

		# Substract item to total values.
		total_spaces -= to_remove_item.spaces
		total_metalic_weight -= to_remove_item.metalic_weight
		total_weight -= to_remove_item.weight
		total_items -= 1

		# Update dictionary and array.
		slots[to_remove_name] -= 1
		if slots[to_remove_name] == 0:
			slots.erase(to_remove_name)
			if actual_slot > slots.size()-1 and actual_slot != 0:
				actual_slot -= 1
			items.erase(to_remove_item)

		# Update displayer.
		inventory_updated.emit()
		return to_remove_item
	else:
		return null


func roll_slot() -> void:
	# Roll slot.
	if actual_slot < slots.size()-1:
		actual_slot += 1
	else:
		actual_slot = 0
	# Update displayer.
	inventory_updated.emit()
