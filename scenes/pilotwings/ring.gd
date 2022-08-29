extends StaticBody



func _ready():
	pass 

func _on_Area_body_entered(body):
	if(body.has_method("_player")):
		queue_free()
		get_parent().get_parent().rings += 1
		get_parent().get_parent()._updatehud()
		get_parent().get_parent()._playsound("victory1.wav")
