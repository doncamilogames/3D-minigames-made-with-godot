extends StaticBody


export var switch = ""

func _ready():
	add_to_group(switch)
	if(Global.mot.switch.find(switch) != -1):
		queue_free()
		
		

func switchreaction():
	queue_free()
