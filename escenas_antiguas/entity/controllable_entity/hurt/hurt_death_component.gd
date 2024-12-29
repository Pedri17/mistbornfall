class_name HurtDeathComponent
extends HurtComponent

func hurted() -> bool:
	if entity:
		entity.queue_free()
		return true
	return false
