@icon("res://icons/state.png")
class_name DeathCharacterAction
extends State

@export var character: CharacterBody2D
@export var health_component: HealthComponent
@export var animation_player: AnimationPlayer
@export var inventory_component: InventoryComponent
@export var horizontal_movement: HorizontalMovement
@export var ANIMATION_DEATH_FALL: StringName = "DeathFall"


func _ready() -> void:
	if health_component:
		health_component.dead.connect(try_enter)


func try_enter() -> bool:
	if health_component.health <= 0:
		finished.emit(name)
		return true
	return false


func physics_update(_delta: float) -> void:
	if horizontal_movement:
		horizontal_movement.stop(2)
	else:
		character.velocity.x = 0
	
	if not character.is_on_floor():
		animation_player.play(ANIMATION_DEATH_FALL)
	else:
		animation_player.play(name)


func enter(previous_state_path: String, data := {}) -> void:
	if character.is_on_floor():
		animation_player.play(name)
	else:
		animation_player.play(ANIMATION_DEATH_FALL)
	
	if inventory_component:
		inventory_component.throw_all_items()
