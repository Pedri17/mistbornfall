@icon("res://icons/state.png")
class_name DeathCharacterAction
extends State

@export var character: CharacterBody2D
@export var health_component: HealthComponent
@export var animation_player: AnimationPlayer
@export var inventory_component: InventoryComponent


func _ready() -> void:
	if health_component:
		health_component.dead.connect(try_enter)


func try_enter() -> bool:
	if health_component.health <= 0:
		finished.emit(name)
		return true
	return false


func physics_update(_delta: float) -> void:
	character.velocity = Vector2.ZERO


func enter(previous_state_path: String, data := {}) -> void:
	animation_player.play(name)
	
	if inventory_component:
		inventory_component.throw_all_items()
