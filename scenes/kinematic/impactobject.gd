extends Spatial

func _ready():
	get_node("Particles").set_emitting(true)

func _on_Timer_timeout():
	queue_free()
