@icon("res://icons/direction_component.png")
class_name DirectionController
extends Node
## Used for a controlled entity to determine the direction where is facing.
@export var input: InputComponent
@export var health_component: HealthComponent
@export var sprites: Array[Sprite2D]
@export var animated_sprites: Array[AnimatedSprite2D]
@export var raycasts: Array[RayCast2D]

signal direction_changed(last_direction: int, new_direction: int)

var direction: int = 1


func _ready() -> void:
	direction_changed.connect(_on_direction_changed)


func _physics_process(_delta: float) -> void:
	if (not health_component or not health_component.is_dead()) and (
		input.left_joystick.get_horizontal_sign() != 0 
		and direction != input.left_joystick.get_horizontal_sign()
	):
		direction_changed.emit(direction, -direction)
		direction = input.left_joystick.get_horizontal_sign()


func _on_direction_changed(_last_direction: int, new_direction: int) -> void:
	# Flip sprites.
	for sprite in sprites:
		if new_direction == 1:
			sprite.flip_h = false
		else:
			sprite.flip_h = true

	# Flip animated sprites.
	for sprite in animated_sprites:
		if new_direction == 1:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	
	# Flip raycasts
	for raycast in raycasts:
		raycast.target_position.x = abs(raycast.target_position.x) * new_direction
