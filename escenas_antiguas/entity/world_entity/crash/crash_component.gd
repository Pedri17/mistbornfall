class_name CrashComponent
extends Area2D

@export var entity: CharacterBody2D

var touching_wall: bool = false
var has_crashed_with: CharacterBody2D = CharacterBody2D.new()


func try_crash(from_entity: CharacterBody2D, to_entity: CharacterBody2D) -> bool:
	var from_crash_comp: CrashComponent
	var to_crash_comp: CrashComponent
	
	if from_entity and to_entity:
		# Get From components.
		for child in from_entity.get_children():
			if child is CrashComponent:
				from_crash_comp = child
		
		# Get To components.
		for child in to_entity.get_children():
			if child is CrashComponent:
				to_crash_comp = child
		
		if not to_crash_comp.has_crashed_with or to_crash_comp.has_crashed_with != from_entity:
			# Are crashable entities.
			if 0==1 and from_crash_comp and to_crash_comp:
				# Do crash.
				to_crash_comp.has_crashed_with = from_entity
				print("FROMENTVEL1: " + str(from_entity.velocity))
				print("TOENTVEL1: " + str(to_entity.velocity))
				var from_actual_vel: Vector2 = from_entity.velocity
				var to_actual_vel: Vector2 = to_entity.velocity
				from_entity.velocity = to_actual_vel
				to_entity.velocity = from_actual_vel
				print("FROMENTVEL2: " + str(from_entity.velocity))
				print("TOENTVE2: " + str(to_entity.velocity))
				return true
	return false


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		try_crash(entity, body)


func _on_area_entered(area: Area2D) -> void:
	if area is CrashComponent:
		try_crash(entity, area.entity)
