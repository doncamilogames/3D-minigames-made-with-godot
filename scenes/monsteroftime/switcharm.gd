extends Area
var getter

export var switch = ""
func _ready():
	if(Global.mot.switch.find(switch) != -1):
		queue_free()
		
func _process(delta):
	if(getter != null):
		global_transform.origin = getter.global_transform.origin
		global_transform.origin.y += 3.0

func _on_switcharm_body_entered(body):
	if(body.has_method("_on_J2_pressed") and getter == null):
		getter = body
		Global.mot.stuff.append("switcharm")
		Global.mot.switch.append(switch)
		body._getswitch()
		get_node("OmniLight").queue_free()
		set_process(true)
		get_node("Timer").start()



func _on_Timer_timeout():
		queue_free()

