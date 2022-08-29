extends Area

export var switch = ""

export var switchneeded1 = ""
export var switchneeded2 = ""
export var switchneeded3 = ""

func _ready():
	pass 

func _on_Areaswitch_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		if(switchneeded1 != ""):
			if(Global.mot.switch.find(switchneeded1) == -1):
				return
		if(switchneeded2 != ""):
			if(Global.mot.switch.find(switchneeded2) == -1):
				return
		if(switchneeded3 != ""):
			if(Global.mot.switch.find(switchneeded3) == -1):
				return
	

		if(Global.mot.switch.find(switch) == -1):
			get_tree().call_group(switch,"switchreaction")
			Global.mot.switch.append(switch)
