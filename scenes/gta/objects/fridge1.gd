extends StaticBody
export var switch = ""
export var content = 0
onready var rng = RandomNumberGenerator.new()
var mainnode 
var checked = 0
func _ready():
	if(Global.gtc.modeselected == "Zombie"):
		mainnode = get_tree().current_scene.find_node("KineFPS",true,false).get_parent()
	else:
		mainnode = get_tree().current_scene.find_node("Kinemacron",true,false).get_parent()


	if(content == 0): # 0 - 10 NOTHING 11 soda, 12 food, 13 medecine, 14 -20 NOTHNG   , 99 mother medecine, 
		if("hospital" in Global.gtc.Zombielastspawn):
			content = rng.randi_range(7,12)
		else:
			content = rng.randi_range(13,17)
		
		
		
		
		
		
	
	
func _fridge():
	get_node("AnimationPlayer").play("open")
	if(switch != ""):
		if(Global.gtc.Zombieswitch.find(switch) == -1):
			Global.gtc.Zombieswitch.append(switch)
			if(content == 99):
				get_tree().current_scene.get_node("KineFPS")._getobj("medecinemother")
			else:
				get_tree().current_scene.get_node("KineFPS")._randomobj()


func _on_Area_body_entered(body):
	if(body.has_method("_on_J2_pressed")):
		if(body.mode != "car"and body.mode != "stopcar"):
			mainnode.closeobject = self
			mainnode._closeobject("fridge")

func _on_Area_body_exited(body):
	if(body.has_method("_on_J2_pressed")):
		if(body.mode != "car"and body.mode != "stopcar"):
			mainnode.closeobject = null
			mainnode._closeobject("null")
