extends Node2D




func _ready() -> void:
	for child in get_children():
		if child is Node2D:
			for grandchild in child.get_children():
				if grandchild is VisibleOnScreenNotifier2D:
					print(grandchild)
					(grandchild as VisibleOnScreenEnabler2D).screen_exited.connect(say)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func say():
	print("fuera")
