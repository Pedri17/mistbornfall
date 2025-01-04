class_name InventoryInitialItemsAddon
extends Node

@export var inventory: InventoryComponent
@export var items: Array[Item]


func _ready():
	for item: Item in items:
		inventory.try_add(item)
