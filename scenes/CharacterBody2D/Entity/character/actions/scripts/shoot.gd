@icon("res://icons/state_2d.png")
class_name ShootCharacterAction
extends State
## Action for a Character that allows to shoot a Item as 
## a Projectile aiming for a direction to shoot.
@export var INPUT: StringName = "shoot" ## InputMap name used for the character to shoot.
@export var ANIMATION: StringName = "Idle" ## Animation name used for the character when is shooting.
@export var character: CharacterBody2D = owner as CharacterBody2D
@export var animation_player: AnimationPlayer
@export var default_item: Item ## Optional, if there's not a inventory it shots that item.
@export_group("Components")
@export var input: InputComponent
@export var inventory: InventoryComponent ## Optional, shoot the items in this inventory.
@export var horizontal_movement: HorizontalMovement
@export_group("Actions")
@export var IDLE: IdleCharacterAction
@export var FALL: FallCharacterAction

@onready var spr_arrow: Sprite2D = $SprArrow


func _ready() -> void:
	spr_arrow.visible = false


func try_enter() -> bool:
	if input.buttons[INPUT].pressed and (
		not inventory or
		not inventory.is_empty()
	):
		finished.emit(name)
		return true
	return false


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(ANIMATION)
	spr_arrow.rotation = input.left_joystick.last_direction.angle()
	spr_arrow.visible = true


func physics_update(_delta: float) -> void:
	spr_arrow.rotation = input.left_joystick.last_direction.angle()
	if horizontal_movement:
		horizontal_movement.stop()
	
	# Release button when is shooting
	if input.buttons[INPUT].released:
		if inventory:
			shoot_projectile(inventory.remove_actual())
		else:
			shoot_projectile(default_item)
		# State change
		if IDLE and character.is_on_floor():
			finished.emit(IDLE.name)
		elif FALL:
			finished.emit(FALL.name)
	
	# State change
	if not input.buttons[INPUT].pressing:
		if FALL and FALL.try_enter():
			return
		elif IDLE and IDLE.try_enter():
			return


func exit() -> void:
	spr_arrow.visible = false


func shoot_projectile(item: Item) -> void:
	var projectile: Node2D = load(item.entity_scene_path).instantiate()
	get_node("/root").get_child(0).add_child(projectile)
	projectile.visible = false
	for child in projectile.get_children():
		if child is ProjectileComponent:
			child.shoot(
				character,
				spr_arrow.global_position,
				input.left_joystick.last_direction.normalized(),
				character.get_real_velocity() 
					/ Engine.physics_ticks_per_second * 0.1
			)
