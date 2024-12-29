@icon("res://icons/inventory_displayer_addon.png")
class_name InventoryDisplayerAddon
extends Node2D
## Addon that can be attached to a InventoryComponent
## to show the items on it.
@export var inventory: InventoryComponent
@export var base_item_sprite_dir: PackedScene ## Scene for the BaseItemSprite used to renderize every item.

@onready var placeholder: Sprite2D = $Placeholder

var this_quantity: int
var items_displayed: int

func _ready() -> void:
	if inventory == null:
		if get_parent() is InventoryComponent:
			inventory = get_parent()
		else:
			printerr(owner.name + "." + name + ": is not atached to a InventoryComponent.")
	else:
		inventory.inventory_updated.connect(make_display)
	placeholder.visible = false


func make_display() -> void:
	# Delete old item sprites.
	for child in get_children():
		if child is Sprite2D:
			child.queue_free()

	# Restart variables
	items_displayed = 0
	var this_slot: int = inventory.actual_slot
	var item_types_remaining: int = inventory.slots.size()

	# Slots dictionary loop.
	while item_types_remaining > 0:
		# Reset slots when is out of bounds.
		if this_slot == inventory.slots.size():
			this_slot = 0
		# Get slot info.
		this_quantity = inventory.slots.values()[this_slot]
		var this_item: Item = inventory.get_item(inventory.slots.keys()[this_slot])
		
		# Create sprites.
		if this_item.spaces == 1:
			while this_quantity > 3:
				_create_sprite(this_item.y_frame, 3, 1)
			if this_quantity > 0:
				_create_sprite(this_item.texture_y_frame_coord, this_quantity, 1)
		else:
			while this_quantity > 0:
				_create_sprite(this_item.texture_y_frame_coord, 1, this_item.spaces)

		item_types_remaining -= 1
		this_slot += 1


func _create_sprite(texture_y_frame_coord: int, amount: int = 1, spaces_per_item: int = 3) -> void:
	var sprite: Sprite2D = base_item_sprite_dir.instantiate()
	get_node(".").add_child(sprite)
	sprite.position.x = (ceil(float(inventory.total_spaces) / 3) / 2 * -4) + (items_displayed * 4)
	sprite.frame_coords = Vector2(amount-1, texture_y_frame_coord) 
	if spaces_per_item > 3:
		sprite.rotation_degrees = 45
		sprite.position.x += 1.5
		items_displayed += ceil(float(spaces_per_item) / 3)
	else:
		items_displayed += 1
	
	this_quantity -= amount
