extends Spatial


var _state = "close"
var mainnode
func _ready():
	if(Global.gtc.modeselected == "Zombie"):
		mainnode = get_tree().current_scene.find_node("KineFPS",true,false).get_parent()
	else:
		mainnode = get_tree().current_scene.find_node("Kinemacron",true,false).get_parent()
func _intdoor():
	pass

func _open():
	if(_state ==  "close"):
		get_node("AnimationPlayer").play("open")
		_state =  "open"
		return
	if(_state ==  "open"):
		get_node("AnimationPlayer").play_backwards("open")
		_state =  "close"
		return



func _on_Area_body_entered(body):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car"):
				mainnode.closeobject = self
				mainnode._closeobject("intdoor")


func _on_Area_body_exited(body):
		if(body.has_method("_on_J2_pressed")):
			if(body.mode != "car"):
				mainnode.closeobject = null
				mainnode._closeobject("null")
