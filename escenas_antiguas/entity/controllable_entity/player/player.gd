class_name Player2
extends CharacterBody2D

@export var device: int = 0

func _ready() -> void:
	for child in get_children():
		if child is DeviceControllerComponent:
			child.device = device
