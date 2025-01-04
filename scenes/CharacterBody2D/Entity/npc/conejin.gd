extends CharacterBody2D


const SPEED = 300.0

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var input = $InputComponent
@onready var direction_controller = $DirectionController


func _physics_process(delta):
	if not ray_cast.is_colliding():
		input.left_joystick.value.x = direction_controller.direction
	else:
		input.left_joystick.value.x = -direction_controller.direction
	
	if is_on_floor():
		velocity.y = -150
	
	velocity.x = 50 * input.left_joystick.value.x
