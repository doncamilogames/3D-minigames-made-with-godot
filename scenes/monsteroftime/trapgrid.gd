extends StaticBody
export var switch = ""
var state = 0

func _ready():
	add_to_group(switch)
	get_node("AnimationPlayer").play("openspawn")
	state = 1
		
		
		
		
		
func switchreaction():
	if(Global.mot.switch.find(switch) != -1):
		if(state == 1):
			print("jijijij")
			get_node("AnimationPlayer").play_backwards("open")
			get_tree().current_scene.find_node("Kinemonster")._playsound("grid")
			state = 0
			return

		if(state == 0):
			get_node("AnimationPlayer").play("open")
			get_tree().current_scene.find_node("Kinemonster")._playsound("grid")
			state = 1
			return
