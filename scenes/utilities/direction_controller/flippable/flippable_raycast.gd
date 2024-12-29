extends RayCast2D

@export var direction_controller: DirectionController


func _ready():
	direction_controller.direction_changed.connect(on_direction_changed)


func on_direction_changed(last_direction: int, new_direction: int) -> void:
	target_position.x = abs(target_position.x) * new_direction
