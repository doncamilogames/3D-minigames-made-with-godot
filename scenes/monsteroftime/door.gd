extends Area

export var _scene = ""
export var _spawn = ""
export var _room = "" #only if needed
export var _key = "no"


func _ready():
	if(_key != "no"):
		if(Global.mot.dooropened.find(_key) == -1 ):#if this door is not  already openend (unic names on this)
			get_node("keyhole").visible = true


func _on_door_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().get_parent().get_node("Kinemonster").closeobject = self
		get_parent().get_parent().get_node("Kinemonster")._updatehud()
func _on_door_body_exited(body):
	if(body.has_method("_on_J2_pressed")):
		get_parent().get_parent().get_node("Kinemonster").closeobject = null
		get_parent().get_parent().get_node("Kinemonster")._updatehud()

func _action():
		if(_key != "no"):# need key
			if(Global.mot.dooropened.find(_key) == -1 ):#if this door is not  already openend (unic names on this)
				if(Global.mot.stuff.find("smallkey") != -1 ):#if you got key
					Global.mot.stuff.erase("smallkey") 
					Global.mot.dooropened.append(_key)
					get_node("keyhole").visible = false
					get_tree().current_scene.find_node("Kinemonster")._playsound("object2")
				else:
					get_tree().current_scene.find_node("Kinemonster")._playsound("error")
					return
		Global.mot.spawn = _spawn
		Global.mot.changescene = _scene
		get_parent().get_node("Animtransition").play("fadeout")
		get_parent().get_parent().get_node("Kinemonster").fixedpos = get_parent().get_parent().get_node("Kinemonster/Spring/SpringArm/Camera").global_transform.origin
		if("warp" in name ):
			get_parent().get_parent().get_node("Kinemonster").mode = "warping"
		if("door" in name ):
			get_parent().get_parent().get_node("Kinemonster").mode = "dooring"
		get_tree().current_scene.find_node("Kinemonster")._playsound("dooropen")

func _dooricon():
	pass
