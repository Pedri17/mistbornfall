class_name MetaLevelCamera
extends Camera2D

@export var level: Node2D

var sprites: Array[Node]
@onready var camera_size = get_viewport_rect().size / zoom
@onready var camera_rect = Rect2(get_screen_center_position() - camera_size / 2, camera_size)

var sprite_and_reflections: Array[_SpriteAndReflection] = []

enum _Direction {
	NULL,
	LEFT,
	RIGHT,
	UP,
	DOWN,
}


func _ready() -> void:
	level.child_entered_tree.connect(_on_child_entered_tree_level)
	var sprites = level.find_children("*", "AnimatedSprite2D")
	sprites.append_array(level.find_children("*", "Sprite2D"))
	
	for sprite in sprites:
		var sar := _SpriteAndReflection.new()
		sar.sprite = sprite
		sprite_and_reflections.append(sar)


func _process(delta) -> void:
	for i in range(0, sprite_and_reflections.size()):
		var sar = sprite_and_reflections[i]
		if is_instance_valid(sar.sprite):
			if sar.sprite.visible:
				# Get size.
				var spr_size: Vector2
				if sar.sprite is Sprite2D:
					spr_size = (sar.sprite as Sprite2D).get_rect().size
				elif sar.sprite is AnimatedSprite2D:
					spr_size = (sar.sprite as AnimatedSprite2D).sprite_frames.get_frame_texture((sar.sprite as AnimatedSprite2D).animation, (sar.sprite as AnimatedSprite2D).frame).get_size()

				# Check out of camera margin direction.
				var direction: _Direction = _Direction.NULL
				if sar.sprite.global_position.x + sar.sprite.offset.x + spr_size.x/2 > camera_rect.end.x:
					direction = _Direction.RIGHT
				elif sar.sprite.global_position.x + sar.sprite.offset.x - spr_size.x/2 < camera_rect.position.x:
					direction = _Direction.LEFT
				elif sar.sprite.global_position.y + sar.sprite.offset.y + spr_size.y/2 > camera_rect.end.y:
					direction = _Direction.DOWN
				elif sar.sprite.global_position.y + sar.sprite.offset.y - spr_size.y/2 < camera_rect.position.y:
					direction = _Direction.UP
				else:
					if sar.sprite is Sprite2D:
						pass
						#print(sar.sprite.owner.name+": pos: " + str(sar.sprite.global_position.x + sar.sprite.offset.x - spr_size.x/2))
				
				# Out of margin.
				if direction != _Direction.NULL:
					if sar.reflection == null:
						sar.reflection = sar.sprite.duplicate(15)
						sar.reflection.offset = sar.sprite.offset
						sar.reflection.position = sar.sprite.position
						sar.sprite.add_child(sar.reflection)
						match(direction):
							_Direction.LEFT:
								sar.reflection.position.x += camera_rect.size.x
							_Direction.RIGHT:
								sar.reflection.position.x -= camera_rect.size.x
							_Direction.UP:
								sar.reflection.position.y += camera_rect.size.y
							_Direction.DOWN:
								sar.reflection.position.y -= camera_rect.size.y
						
					else:
						sar.copy_state()
						# Sprite is out of camera.
						if (
							(direction == _Direction.LEFT and sar.sprite.global_position.x + sar.sprite.offset.x + spr_size.x/2 < camera_rect.position.x)
							or (direction == _Direction.RIGHT and sar.sprite.global_position.x + sar.sprite.offset.x - spr_size.x/2 > camera_rect.end.x)
							or (direction == _Direction.UP and sar.sprite.global_position.y + sar.sprite.offset.y + spr_size.y/2 < camera_rect.position.y)
							or (direction == _Direction.DOWN and sar.sprite.global_position.y + sar.sprite.offset.y - spr_size.y/2 > camera_rect.end.y) 
						):
							sar.sprite.owner.global_position = sar.reflection.global_position
							sar.reflection.queue_free()


func _on_child_entered_tree_level(node: Node):
	var node_sprites: = node.find_children("*", "Sprite2D")
	node_sprites.append_array(node.find_children("*", "AnimatedSprite2D"))
	for sprite in node_sprites:
		var sar := _SpriteAndReflection.new()
		sar.sprite = sprite
		sprite_and_reflections.append(sar)


class _SpriteAndReflection:
	var sprite: Node2D = null
	var reflection: Node2D = null
	
	func copy_state() -> void:
		if sprite is AnimatedSprite2D:
			(reflection as AnimatedSprite2D).animation = (sprite as AnimatedSprite2D).animation
			(reflection as AnimatedSprite2D).frame = (sprite as AnimatedSprite2D).frame
			(reflection as AnimatedSprite2D).flip_h = (sprite as AnimatedSprite2D).flip_h
		elif sprite is Sprite2D:
			(reflection as Sprite2D).frame_coords = (sprite as Sprite2D).frame_coords
			(reflection as Sprite2D).flip_h = (sprite as Sprite2D).flip_h
