extends Area

export var _scene = ""
export var _spawn = ""
export var _place = "" # name of the area, for generic place like shop, UNUSED ???
export var _mode = "" #only appear in this mode
var mainnode
func _ready():
	if(Global.gtc.modeselected == "Zombie"):
		mainnode = get_tree().current_scene.find_node("KineFPS",true,false).get_parent()
	else:
		mainnode = get_tree().current_scene.find_node("Kinemacron",true,false).get_parent()
		
	if(mainnode.mode == _mode or _mode == "all"  ):
		pass
	else:
		queue_free()
	
func _door():
	pass

func _on_door_body_entered(body):
		if(body.has_method("_on_J2_pressed") and body.mode != "stopcar"):
			if(body.mode != "car"):
				mainnode.closeobject = self
				mainnode._closeobject("door")



func _on_door_body_exited(body):
		if(body.has_method("_on_J2_pressed")and body.mode != "stopcar"):
			if(body.mode != "car"):
				mainnode.closeobject = null
				mainnode._closeobject("null")


func _on_textspeed_timeout() -> void:
	pass # Replace with function body.
