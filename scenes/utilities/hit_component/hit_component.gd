@icon("res://icons/icon_skull.png")
class_name HitComponent
extends Node

@export var character: CharacterBody2D
@export var area: Area2D
@export var projectile_component: ProjectileComponent
@export var min_velocity_to_hit: int = 100

@onready var shoot_grace_timer = $ShootGraceTimer

var grace_time: bool = true # Time while the shooter cant hit himself.


func _ready():
	area.body_entered.connect(_on_body_entered)
	grace_time = true
	shoot_grace_timer.start()


func _on_body_entered(body: Node2D) -> void:
	if abs(character.velocity.x) >= min_velocity_to_hit or (
		abs(character.velocity.y) >= min_velocity_to_hit
	):
		var health: HealthComponent
		for child: Node in body.get_children():
			if child is HealthComponent:
				health = child as HealthComponent
		
		if health and (not projectile_component or (
			not grace_time or projectile_component.shot_by != body
		)):
			health.health -= 1


func _on_shoot_grace_timer_timeout() -> void:
	grace_time = false
