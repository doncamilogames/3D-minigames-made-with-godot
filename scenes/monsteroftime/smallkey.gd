extends Area
var getter
export var switchneeded = "no"
export var switch = ""
func _ready():
	if(Global.mot.switch.find(switch) != -1):
		queue_free()

func _process(delta):
	if(getter != null):
		global_transform.origin = getter.global_transform.origin
		global_transform.origin.y += 3.0

func _on_smallkey_body_entered(body):
		if(body.has_method("_on_J2_pressed") and getter == null):
			getter = body
			Global.mot.stuff.append("smallkey")
			Global.mot.switch.append(switch)
			body._getkey()
			get_node("OmniLight").queue_free()
			set_process(true)
			get_node("Sprite3D").scale = Vector3(2,2,2)
			get_node("Timer").start()

func _on_Timer_timeout():
			queue_free()
