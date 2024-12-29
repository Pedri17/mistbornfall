extends Node2D

@export var entity: CharacterBody2D
@export var input: InputComponent
@export var sprite: AnimatedSprite2D
@export var sprite_animation_player: AnimationPlayer
@export var effect_animation_player: AnimationPlayer
@export var shoot_component: ShootComponent
@export_group("Walk values")
@export var walk_max_speed: int = 150
@export var walk_acceleration: int = 18
@export_group("Jump values")
@export var standart_jump_velocity: int = -150
@export var duck_jump_velocity: Vector2 = Vector2(350, -180)
@export var roll_jump_velocity: Vector2 = Vector2(-80, -350)
@export var wall_jump_velocity: Vector2 = Vector2(-200, -200)
@export_subgroup("High jump")
@export var high_jump_max_height: int = -300
@export var high_jump_acceleration: int = -20
@export_group("Wall values")
@export var wall_slide_velocity_mult: float = 0.75

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

# 	Movement.
var lateral_direction: int = 0
var can_jump: bool = false
var can_do_high_jump: bool = false
var can_do_roll_jump: bool = false
var is_ducking: bool = false
var is_shooting: bool = false
var jump_height: float = 0
var was_on_floor: bool = false
var facing_direction: int = 1

@onready var raycast_wall_upper: RayCast2D = $RaycastWallUpper
@onready var raycast_wall_middle: RayCast2D = $RaycastWallMiddle
@onready var raycast_wall_lower: RayCast2D = $RaycastWallLower
@onready var timer_on_turn: Timer = $TimerOnTurn
@onready var timer_on_fall: Timer = $TimerOnFall

func _ready() -> void:
	if entity:
		entity.velocity.y = 0


func _physics_process(delta: float) -> void:
	if shoot_component != null:
		is_shooting = shoot_component.is_shooting
	
	if entity:
		if not entity.is_on_floor():
			entity.velocity.y += gravity * delta
		was_on_floor = entity.is_on_floor()
		update_direction()
		handle_lateral_movement()
		handle_jump()
		
		entity.move_and_slide()
		# Post movement update.
		if was_on_floor and not entity.is_on_floor():
			timer_on_fall.start()
	
		if not was_on_floor and entity.is_on_floor():
			effect_animation_player.play("land")

		handle_duck()
		handle_fall()


func update_direction() -> void:
	# Set lateral direction as sign.
	lateral_direction = input.to_sign(input.joystick.x)
	
	# Check if can do a roll jump.
	if (
		abs(entity.velocity.x) >= walk_max_speed * 0.5
		and lateral_direction != 0 
		and lateral_direction != facing_direction
	):
		can_do_roll_jump = true
		timer_on_turn.start()
	
	# Set facing direction.
	if lateral_direction != 0 and facing_direction != lateral_direction:
		if lateral_direction > 0:
			facing_direction = 1
			sprite.flip_h = false
		elif lateral_direction < 0:
			facing_direction = -1
			sprite.flip_h = true
	
	# Set raycast direction
	if lateral_direction != 0:
		raycast_wall_upper.target_position.x = lateral_direction * abs(raycast_wall_upper.target_position.x)
		raycast_wall_middle.target_position.x = lateral_direction * abs(raycast_wall_middle.target_position.x)
		raycast_wall_lower.target_position.x = lateral_direction * abs(raycast_wall_lower.target_position.x)

func handle_lateral_movement() -> void:
	# Handle lateral movement.
	if lateral_direction and not is_ducking and not is_shooting:
		entity.velocity.x = move_toward(entity.velocity.x, lateral_direction * walk_max_speed, walk_acceleration)
		# Avoid is_on_floor bug
		if entity.is_on_floor():
			entity.velocity.y = 10
		# On a wall.
		if entity.is_on_wall() and not entity.is_on_floor() and entity.velocity.y > 0:
			sprite_animation_player.play("wall_slide")
			# Wall grab.
			if raycast_wall_lower.is_colliding() and not raycast_wall_middle.is_colliding():
				entity.velocity.y = 0
			# Grab the wall going up to the edge.
			elif raycast_wall_lower.is_colliding() and not raycast_wall_upper.is_colliding():
				while(raycast_wall_middle.is_colliding()):
					entity.position.y += -1
					raycast_wall_middle.force_raycast_update()
				entity.velocity.y = 0
				effect_animation_player.play("wall_grab")
			# Wall slide.
			else:
				entity.velocity.y = entity.velocity.y * wall_slide_velocity_mult
	# If not is moving stops.
	else:
		if not is_shooting or entity.is_on_floor():
			entity.velocity.x = move_toward(entity.velocity.x, 0, walk_acceleration)

	# Set floor animation.
	if entity.is_on_floor() and not is_ducking:
		if entity.velocity.x == 0:
			sprite_animation_player.play("idle")
		else:
			sprite_animation_player.play("walk")


func handle_jump() -> void:
	# Is on floor logic.
	if entity.is_on_floor():
		can_jump = true
		can_do_high_jump = false

	# Handle high jump
	if (
		can_do_high_jump 
		and jump_height > high_jump_max_height
		and input.buttons["jump"].pressing
	):
		# Make sure just jump the maximun height
		if jump_height + high_jump_acceleration < high_jump_max_height:
			entity.velocity.y += high_jump_max_height - jump_height
			jump_height += high_jump_max_height - jump_height
		else:
			entity.velocity.y += high_jump_acceleration
			jump_height += high_jump_acceleration

	# Handle jump.
	if input.buttons["jump"].pressed:
		if can_jump and not entity.is_on_wall():
			# Duck jump.
			if is_ducking:
				sprite_animation_player.play("jump")
				entity.velocity.y = duck_jump_velocity.y
				entity.velocity.x += facing_direction * duck_jump_velocity.x
			# Roll jump.
			elif can_do_roll_jump:
				sprite_animation_player.play("roll")
				entity.velocity.x = lateral_direction * roll_jump_velocity.x
				entity.velocity.y = roll_jump_velocity.y
			# Standart jump.
			else:
				can_do_high_jump = true
				jump_height = standart_jump_velocity
				sprite_animation_player.play("jump")
				entity.velocity.y = standart_jump_velocity
				
			can_jump = false
			is_ducking = false
		elif entity.is_on_wall():
			sprite_animation_player.play("jump")
			# Wall jump.
			if raycast_wall_middle.is_colliding():
				entity.velocity.y = wall_jump_velocity.y
				entity.velocity.x = lateral_direction * wall_jump_velocity.x
			# Grab wall jump.
			else:
				can_do_high_jump = true
				jump_height = wall_jump_velocity.y
				entity.velocity.y = wall_jump_velocity.y
			can_jump = false


func handle_duck() -> void:
	# Handle duck.
	if (
		not is_ducking
		and input.buttons["move_down"].pressing
		and entity.is_on_floor()
	):
		print("DUCK FROM " + str(input.device))
		sprite_animation_player.play("duck")
		effect_animation_player.play("duck")
		is_ducking = true
		is_shooting = false

	# Quit ducking.
	if not input.buttons["move_down"].pressing:
		is_ducking = false


func handle_fall() -> void:
	# Infinite animation when is on air.
	if (
		not entity.is_on_floor() 
		and abs(entity.velocity.y) > 25
		and not sprite_animation_player.is_playing()
	):
		sprite_animation_player.play("fly")

# Signals.
func _on_timer_on_fall_timeout() -> void:
	can_jump = false

func _on_timer_on_turn_timeout() -> void:
	can_do_roll_jump = false
