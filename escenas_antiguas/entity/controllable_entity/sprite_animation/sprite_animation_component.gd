class_name SpriteAnimationComponent
extends Node

@export var sprite: AnimatedSprite2D
@export var animation_players: Array[AnimationPlayer]


func play(animation: String):
	print("MANDA EJECUTAR: " + animation)
	var has_animation: bool = false
	for animation_player in animation_players:
		for libraryName in animation_player.get_animation_library_list():
			var library = animation_player.get_animation_library(libraryName)
			if library.has_animation(animation) and not animation_player.current_animation == animation:
				has_animation = true
		if has_animation:
			if get_node(animation_player.root_node) != null:
				print(str(get_node(animation_player.root_node).name) + " plays " + str(animation))
			animation_player.play(animation)


func some_is_playing():
	for animation_player in animation_players:
		if animation_player.is_playing():
			return true
	return false


func turn_sprite(flipped: bool):
	sprite.flip_h = flipped
