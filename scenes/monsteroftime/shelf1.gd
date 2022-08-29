extends StaticBody

var open = 0
export var switch = "" #activ this switch when open
func _ready():
	pass
func _on_Area_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().get_parent().get_parent().get_node("Kinemonster").closeobject = self
		get_parent().get_parent().get_parent().get_node("Kinemonster")._updatehud()

func _on_Area_body_exited(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().get_parent().get_parent().get_node("Kinemonster").closeobject = null
		get_parent().get_parent().get_parent().get_node("Kinemonster")._updatehud()
func _action():
	if(get_node("AnimationPlayer").is_playing() == false):
		if(open == 0):
			get_node("AnimationPlayer").play("open")
			get_tree().current_scene.find_node("Kinemonster")._playsound("dooropen")

			open = 1
			if(switch != ""):
				if(Global.mot.switch.find(switch) == -1):
					Global.mot.switch.append(switch)
		else:
			get_node("AnimationPlayer").play_backwards("open")
			get_tree().current_scene.find_node("Kinemonster")._playsound("doorclose")
			open = 0
			if(switch != ""):
				if(Global.mot.switch.find(switch) != -1):
					Global.mot.switch.erase(switch)

func _dooricon():
	pass
