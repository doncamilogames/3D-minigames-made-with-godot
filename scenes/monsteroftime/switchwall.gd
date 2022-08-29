extends StaticBody
export var switch = ""
export var switcharm = "" #if not complete, switch whenarm is in

var state = 0
export var complete = "no"

func _ready():
	if(complete == "yes"):
		get_node("Spatial").visible = true
	else:
		if(Global.mot.switch.find(switcharm) != -1):
			complete = "yes"
			get_node("Spatial").visible = true

	if(Global.mot.switch.find(switch) != -1):
		state = 1
		get_node("AnimationPlayer").play("okspawn") 


func _on_Area_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_tree().current_scene.find_node("Kinemonster").closeobject = self
		get_tree().current_scene.find_node("Kinemonster")._updatehud()

func _on_Area_body_exited(body):
	if(body.has_method("_on_J2_pressed")):
		get_tree().current_scene.find_node("Kinemonster").closeobject = null
		get_tree().current_scene.find_node("Kinemonster")._updatehud()


func _switchicon():
	pass

func _action():

	if(complete == "yes"):
		if(get_node("AnimationPlayer").is_playing() == false):
			if(state == 0):
				get_node("AnimationPlayer").play("ok") 

				if(switch != ""):
					if(Global.mot.switch.find(switch) == -1):
						Global.mot.switch.append(switch)
						get_tree().call_group(switch,"switchreaction")
				state = 1

			else:

				get_node("AnimationPlayer").play_backwards("ok")
				if(switch != ""):
					if(Global.mot.switch.find(switch) != -1):
						Global.mot.switch.erase(switch)
						get_tree().call_group(switch,"switchreaction")
				state = 0
				
	if(complete == "no"):
		if(Global.mot.stuff.find("switcharm") != -1):
			get_node("Spatial").visible = true
			complete = "yes"
			Global.mot.switch.append(switcharm)
			Global.mot.stuff.erase("switcharm")
			get_tree().current_scene.find_node("Kinemonster")._playsound("object2")
		else:
			get_tree().current_scene.find_node("Kinemonster")._playsound("error")
