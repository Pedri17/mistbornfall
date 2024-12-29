@icon("res://icons/state_2d.png")
class_name ShootCharacterBehavior
extends State
## Behavior for a Character that allows to shoot a Item as 
## a Projectile aiming for a direction to shoot.
@export var character: CharacterBody2D = owner as CharacterBody2D
@export var INPUT: StringName = "shoot" ## InputMap name used for the character to shoot.
@export var default_item: Item ## Optional, if there's not a inventory it shots that item.
@export_group("Components")
@export var input: InputComponent
@export var inventory: InventoryComponent ## Optional, shoot the items in this inventory.
@export_group("Behaviors")
@export var IDLE: IdleCharacterBehavior
@export var FALL: FallCharacterBehavior

@onready var spr_arrow: Sprite2D = $SprArrow


func _ready() -> void:
	spr_arrow.visible = false


func enter(previous_state_path: String, data := {}) -> void:
	spr_arrow.visible = true


func physics_update(_delta: float) -> void:
	spr_arrow.rotation = input.left_joystick.value.angle()
	
	# Release button when is shooting
	if input.buttons[INPUT].released:
		if inventory:
			shoot_projectile(inventory.remove_actual())
		else:
			shoot_projectile(default_item)
		if IDLE and character.is_on_floor():
			finished.emit(IDLE.name)
		elif FALL:
			finished.emit(FALL.name)
	
	# State change
	if not input.buttons[INPUT].pressing:
		if FALL and (not character.is_on_floor() and character.velocity.y > 10):
			finished.emit(FALL.name)
		elif IDLE and character.is_on_floor():
			IDLE.try_enter()


func shoot_projectile(item: Item) -> void:
	var projectile: Node2D = load(item.entity_scene_path).instantiate()
	get_node("/root").add_child(projectile)
	projectile.visible = false
	for child in projectile.get_children():
		if child is ProjectileComponent:
			child.shoot(
				character,
				character.position,
				input.last_joystick_direction.normalized() + character.get_real_velocity() 
					/ Engine.physics_ticks_per_second * 0.1
			)
