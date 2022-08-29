extends Area

func _ready():
	pass 

func _on_hole_body_entered(body):
		if(body.has_method("_on_J2_pressed")):
			body._playsound("fallinhole")
			get_tree().reload_current_scene()
			body._receivedamage(1)
